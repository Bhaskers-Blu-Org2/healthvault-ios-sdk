//
//  HVClientResult.m
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

#import "HVClientResult.h"
#import "HVCore.h"
#import "HVValidator.h"

static HVClientResult* s_success = nil;
static HVClientResult* s_unknownError = nil;

@implementation HVClientResult

@synthesize error = m_error;
@synthesize lineNumber = m_line;
@synthesize fileName = m_file;

-(BOOL) isSuccess
{
    return (m_error == HVClientResult_Success);
}

-(BOOL) isError
{
    return (m_error != HVClientResult_Success);
}

+(void) initialize
{
    s_success = [[HVClientResult alloc] initWithCode:HVClientResult_Success];
    s_unknownError = [[HVClientResult alloc] initWithCode:HVClientError_Unknown];
}

-(id) init
{
    return [self initWithCode:HVClientError_Unknown];
}

-(id) initWithCode:(enum HVClientResultCode)code
{
    return [self initWithCode:code fileName:"" lineNumber:0];
}

-(id) initWithCode:(enum HVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line
{
    self = [super init];
    HVCHECK_SELF;
    
    m_error = code;
    m_file = fileName;
    m_line = line;
    
    return self;
    
LError:
    HVALLOC_FAIL;
}

-(NSString *)description
{
    if (self.isError)
    {
        return [NSString stringWithFormat:@"ClientError:%d file:%s line:%d", m_error, m_file, m_line];
    }
    
    return [super description];
}

+(HVClientResult *) unknownError
{
    return s_unknownError;
}

+(HVClientResult *) success
{
    return s_success;
}

+(HVClientResult *) fromCode:(enum HVClientResultCode)code
{
    return [[HVClientResult alloc] initWithCode:code];
}

+(HVClientResult *) fromCode:(enum HVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line
{
    return [[HVClientResult alloc] initWithCode:code fileName:fileName lineNumber:line];
}

@end
