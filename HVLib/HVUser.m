//
//  HVUser.m
//  HVLib
//
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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
#import "HVUser.h"
#import "HVRecord.h"
#import "HVGetAuthorizedPeopleTask.h"
#import "HVClient.h"
#import "HVAsyncTask.h"
#import "HVAppProvisionController.h"
#import "HVRemoveRecordAuthTask.h"

static NSString* const c_element_name = @"name";
static NSString* const c_element_recordarray = @"records";
static NSString* const c_element_record = @"record";
static NSString* const c_element_current = @"current";
static NSString* const c_element_environment = @"environment";
static NSString* const c_element_instanceID = @"instanceID";

@interface HVUser (HVPrivate)

-(void) getPeopleComplete:(HVTask *) task;
-(HVGetAuthorizedPeopleTask *) newGetPeopleTask;

-(BOOL) updateWithPerson:(HVPersonInfo *) person;

-(void)imageDownloadComplete:(HVTask *)task forRecord:(HVRecord *)record;

-(void) updateLegacyRecords;
-(void) updateLegacyCurrentRecord;
-(HealthVaultRecord *) newLegacyRecord:(HVRecord *) record;
-(void) clearLegacyRecords;

@end

@implementation HVUser

@synthesize name = m_name;
@synthesize records = m_records;
@synthesize currentRecordIndex = m_currentIndex;
@synthesize environment = m_environment;
@synthesize instanceID = m_instanceID;

-(BOOL)hasRecords
{
    return (![NSArray isNilOrEmpty:m_records]);
}

-(void)setCurrentRecordIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0 || currentIndex > m_records.count)
    {
        currentIndex = 0;
    }
    
    m_currentIndex = currentIndex;
    [self updateLegacyCurrentRecord];
}

-(HVRecord *)currentRecord
{
    if ([NSArray isNilOrEmpty:m_records])
    {
        return nil;
    }
    
    return [m_records objectAtIndex:m_currentIndex];
}

-(BOOL)hasEnvironment
{
    return ![NSString isNilOrEmpty:m_environment];
}

-(BOOL)hasInstanceID
{
    return ![NSString isNilOrEmpty:m_instanceID];
}

-(id)initFromLegacyRecords:(NSArray *)recordArray
{
    HVCHECK_NOTNULL(recordArray);
    
    self = [super init];
    HVCHECK_SELF;
    
    HVCHECK_SUCCESS([self updateWithLegacyRecords:recordArray]);
        
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(BOOL)updateWithLegacyRecords:(NSArray *)records
{
    HVRecord* current = [self currentRecord];
    
    [self clear];
    
    m_records = [[HVRecordCollection alloc] init];
    HVCHECK_NOTNULL(m_records);
    
    for (HealthVaultRecord *record in records) 
    {
        if (!m_name)
        {
            m_name = record.personName;
        }
        
        HVRecord* hvRecord = [[HVRecord alloc] initWithRecord:record];
        HVCHECK_NOTNULL(hvRecord);
    
        if (current && [hvRecord.ID isEqualToString:current.ID])
        {
            m_currentIndex = m_records.count;
        }

        [m_records addObject:hvRecord];        
    }
    
    return TRUE;
    
LError:
    return FALSE;    
}

-(void) configureCurrentRecordForService:(HealthVaultService *)service
{
    HVRecord* currentRecord = self.currentRecord;
    if (currentRecord == nil)
    {
        service.currentRecord = nil;
        return;
    }
    
    HealthVaultRecord* legacyRecord = [self newLegacyRecord:currentRecord];
    service.currentRecord = legacyRecord;
}

-(void)clearRecordsForService:(HealthVaultService *)service
{
    [service.records removeAllObjects];
    service.currentRecord = nil;
}

-(HVTask *)refreshAuthorizedRecords:(HVTaskCompletion)callback
{
    HVTask* refreshTask = [[HVTask alloc] initWithCallback:callback];
    HVCHECK_NOTNULL(refreshTask);
    
    HVGetAuthorizedPeopleTask* getRecordsTask = [self newGetPeopleTask];
    HVCHECK_NOTNULL(getRecordsTask);
    
    [refreshTask setNextTask:getRecordsTask];
    
    [refreshTask start];
    
    return refreshTask;
    
LError:
    return nil;
}

-(HVTask *)authorizeAdditionalRecords:(UIViewController *)parentController andCallback:(HVTaskCompletion)callback
{
    HVTask* authTask = [[HVTask alloc] initWithCallback:callback];
    HVCHECK_NOTNULL(authTask);
    
    NSString* urlString = [[HVClient current].service getUserAuthorizationUrl];
    NSURL* url = [NSURL URLWithString:urlString];
    HVCHECK_NOTNULL(url);
    
    HVAppProvisionController* controller = [[HVAppProvisionController alloc] initWithAppCreateUrl:url andCallback:^(HVAppProvisionController *controller) {
                
        if (controller.error)
        {
            [HVClientException throwExceptionWithError:HVMAKE_ERROR(HVClientError_Web)];
        }
        
        if (authTask.isCancelled || !controller.isSuccess)
        {
            return;
        }
        
        HVGetAuthorizedPeopleTask* refreshTask = [self newGetPeopleTask];
        [authTask setNextTask:refreshTask];
        [authTask start];
    }];
    
    [parentController.navigationController pushViewController:controller animated:TRUE];

    return authTask;
    
LError:
    return nil;
}

-(HVTask *)removeAuthForRecord:(HVRecord *)record withCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(record);
    
    HVTask* removeAuthTask = [[HVTask alloc] initWithCallback:callback];
    HVCHECK_NOTNULL(removeAuthTask);
    
    HVRemoveRecordAuthTask* removeRecordAuthTask = [[HVRemoveRecordAuthTask alloc] initWithRecord:record andCallback:^(HVTask *task) {
        
        [task checkSuccess];
        
        HVGetAuthorizedPeopleTask* refreshTask = [self newGetPeopleTask];
        [task.parent setNextTask:refreshTask];
        
    }];
    HVCHECK_NOTNULL(removeRecordAuthTask);
    
    [removeAuthTask setNextTask:removeRecordAuthTask];
    [removeAuthTask start];
    
    return removeAuthTask;
    
LError:
    return nil;
}

-(HVTask *)downloadRecordImageFor:(HVRecord *)record withCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(record);
    
    HVTask* task = [[HVTask alloc] initWithCallback:callback];
    HVCHECK_NOTNULL(task);
    
    HVGetPersonalImageTask* getImageTask = [[HVGetPersonalImageTask alloc] initWithRecord:record andCallback:^(HVTask *task) {
        [self imageDownloadComplete:task forRecord:record];
    }];
    HVCHECK_NOTNULL(getImageTask);
    
    [task setNextTask:getImageTask];
    [task start];
    
LError:
    return nil;
}

-(void)clear
{
    m_name = nil;
    m_records = nil;
    m_currentIndex = 0;    
}

-(HVClientResult *) validate
{
    HVVALIDATE_BEGIN
    
    if (m_records)
    {
        for (HVRecord *record in m_records) 
        {
            HVCHECK_RESULT([record validate]);
        }
    }
    
    HVVALIDATE_SUCCESS
}

-(void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name value:m_name];
    [writer writeElementArray:c_element_recordarray itemName:c_element_record elements:m_records];
    [writer writeElement:c_element_current intValue:(int)m_currentIndex];
    [writer writeElement:c_element_environment value:m_environment];
    [writer writeElement:c_element_instanceID value:m_instanceID];
}

-(void)deserialize:(XReader *)reader
{
    m_name = [reader readStringElement:c_element_name];
    m_records = (HVRecordCollection *)[reader readElementArray:c_element_recordarray itemName:c_element_record asClass:[HVRecord class] andArrayClass:[HVRecordCollection class]];
    
    NSInteger index = 0;
    index = [reader readIntElement:c_element_current];
    m_currentIndex = index;
    
    m_environment = [reader readStringElement:c_element_environment];
    m_instanceID = [reader readStringElement:c_element_instanceID];
}

@end

@implementation HVUser (HVPrivate)

-(void)getPeopleComplete:(HVTask *)task
{
    HVGetAuthorizedPeopleTask* getPeopleTask = (HVGetAuthorizedPeopleTask *) task;
    NSArray* persons = getPeopleTask.persons;
    if ([NSArray isNilOrEmpty:persons])
    {
        // NO authorized people! App must be reauthorized
        [self clear];
        [self clearLegacyRecords];
        return;
    }
    
    HVPersonInfo* person = [persons objectAtIndex:0];
    [self updateWithPerson:person];
}

-(HVGetAuthorizedPeopleTask *)newGetPeopleTask
{
    return [[HVGetAuthorizedPeopleTask alloc] initWithCallback:^(HVTask *task) {
        [self getPeopleComplete:task];        
    }];
    
}

-(BOOL) updateWithPerson:(HVPersonInfo *) person
{
    HVCHECK_NOTNULL(person);
    
    NSString* currentRecordID = (self.currentRecord) ? self.currentRecord.ID : nil;
    m_currentIndex = 0;
    
    self.name = person.name;
    self.records = person.records;
    
    if ([self hasRecords])
    {
        for (NSUInteger i = 0, count = m_records.count; i < count; ++i)
        {
            HVRecord* record = [m_records itemAtIndex:i];
            if (currentRecordID && [record.ID isEqualToString:currentRecordID])
            {
                m_currentIndex = i;
            }
        }
        [self updateLegacyRecords];
    }
    else 
    {
        [self clearLegacyRecords];
    }
    
    return TRUE;
    
LError:
    return FALSE;    
    
}

-(void)imageDownloadComplete:(HVTask *)task forRecord:(HVRecord *)record
{
    NSData* imageData = ((HVGetPersonalImageTask *) task).imageData;
    if (imageData)
    {
        [[[HVClient current].localVault getRecordStore:record] putPersonalImage:imageData];
    }
    else
    {
        [[[HVClient current].localVault getRecordStore:record] deletePersonalImage];
    }
}

-(void)updateLegacyRecords
{
    [self clearLegacyRecords];    
    [self updateLegacyCurrentRecord];
}

-(void)updateLegacyCurrentRecord
{
    [self configureCurrentRecordForService:[HVClient current].service];
}

-(HealthVaultRecord *)newLegacyRecord:(HVRecord *)record
{
    HealthVaultRecord* legacyRecord = [[HealthVaultRecord alloc] init];
    legacyRecord.personId = record.personID;
    legacyRecord.recordId = record.ID;
    legacyRecord.recordName = record.name;
    legacyRecord.relationship = record.relationship;
    
    return legacyRecord;
}

-(void)clearLegacyRecords
{
    [self clearRecordsForService:[HVClient current].service];
}

@end
