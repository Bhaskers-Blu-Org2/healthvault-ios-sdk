//
//  HVFamilyHistory.h
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

#import <Foundation/Foundation.h>
#import "HVTypes.h"
#import "HVVocab.h"

@interface HVFamilyHistory : HVItemDataTyped
{
@private
    HVRelative* m_relative;
    HVConditionEntryCollection* m_conditions;
}

//-------------------------
//
// Data
//
//-------------------------
//
// (Optional) Relative 
//
@property (readwrite, nonatomic, strong) HVRelative* relative;
//
// (Optional) Any conditions this relative had
//
@property (readwrite, nonatomic, strong) HVConditionEntryCollection* conditions;
//
// Convenience 
//
@property (readonly, nonatomic) BOOL hasConditions;
@property (readonly, nonatomic, strong) HVConditionEntry* firstCondition;

//-------------------------
//
// Initializers
//
//-------------------------
-(id) initWithRelative:(HVRelative *) relative andCondition:(HVConditionEntry *) condition;

+(HVItem *) newItem;

//-------------------------
//
// Text
//
//-------------------------
-(NSString *) toString;

//-------------------------
//
// Type info
//
//-------------------------

+(NSString *) typeID;
+(NSString *) XRootElement;

@end
