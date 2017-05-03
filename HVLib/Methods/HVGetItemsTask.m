//
//  GetItems.m
//  HVLib
//
//  Copyright (c) 2012 Microsoft Corporation. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "HVCommon.h"
#import "HVGetItemsTask.h"
#import "HVClient.h"

@implementation HVGetItemsTask

-(HVItemQueryCollection *)queries
{
    HVENSURE(m_queries, HVItemQueryCollection);
    return m_queries;
}

-(HVItemQuery *)firstQuery
{
    if ([NSArray isNilOrEmpty:m_queries])
    {
        return nil;
    }
    
    return [m_queries itemAtIndex:0];
}

-(HVItemQueryResults *)queryResults
{
    return (HVItemQueryResults *) self.result;
}

-(HVItemQueryResult *)queryResult
{
    HVItemQueryResults* results = self.queryResults;
    return (results) ? results.firstResult : nil;
}

-(HVItemCollection *) itemsRetrieved
{
    HVItemQueryResult* result = self.queryResult;
    return (result) ? result.items : nil;
}

-(HVItem *)firstItemRetrieved
{
    return (self.itemsRetrieved) ? [self.itemsRetrieved itemAtIndex:0] : nil;
}

-(NSString *)name
{
    return @"GetThings";
}

-(float)version
{
    return 3;
}

-(id)initWithQuery:(HVItemQuery *)query andCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(query);
    
    self = [super initWithCallback:callback];
    HVCHECK_SELF;
    
    [self.queries addObject:query];
    HVCHECK_NOTNULL(m_queries);
    
    return self;
    
LError:
    HVALLOC_FAIL;
}

-(id)initWithQueries:(HVItemQueryCollection *)queries andCallback:(HVTaskCompletion)callback
{
    HVCHECK_TRUE(![NSArray isNilOrEmpty:queries]);
    
    self = [super initWithCallback:callback];
    HVCHECK_SELF;
    
    m_queries = [queries retain];
    
    return self;
    
LError:
    HVALLOC_FAIL;
}

-(void)dealloc
{
    [m_queries release];
    [super dealloc];
}

-(void)prepare
{
    [self ensureRecord];
}

-(void)serializeRequestBodyToWriter:(XWriter *)writer
{
    for (NSUInteger i = 0, count = m_queries.count; i < count; ++i)
    {
        HVItemQuery* query = [m_queries itemAtIndex:i];
        [self validateObject:query];
        [XSerializer serialize:query withRoot:@"group" toWriter:writer];
    }
}

-(id)deserializeResponseBodyFromReader:(XReader *)reader
{
    return [super deserializeResponseBodyFromReader:reader asClass:[HVItemQueryResults class]];
}

+(HVGetItemsTask *) newForRecord:(HVRecordReference *) record query:(HVItemQuery *)query andCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(record);
    
    HVGetItemsTask* task = [[HVGetItemsTask alloc] initWithQuery:query andCallback:callback];
    HVCHECK_NOTNULL(task);
    
    task.record = record;

    return task;
    
LError:
    return nil;
}

+(HVGetItemsTask *) newForRecord:(HVRecordReference *)record queries:(HVItemQueryCollection *)queries andCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(record);
    
    HVGetItemsTask* task = [[HVGetItemsTask alloc] initWithQueries:queries andCallback:callback];
    HVCHECK_NOTNULL(task);
    
    task.record = record;
    
    return task;
    
LError:
    return nil;
}

@end
