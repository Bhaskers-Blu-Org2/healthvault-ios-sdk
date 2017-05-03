//
//  HVPerson.h
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

#import "HVType.h"
#import "HVCodableValue.h"
#import "HVContact.h"
#import "HVName.h"

@interface HVPerson : HVType
{
@private
    HVName* m_name;
    NSString* m_organization;
    NSString* m_training;
    NSString* m_id;
    HVContact* m_contact;
    HVCodableValue* m_type;
}

//-------------------------
//
// Data
//
//-------------------------
//
// (Required) Person's name
//
@property (readwrite, nonatomic, strong) HVName* name;
//
// (Optional) 
//
@property (readwrite, nonatomic, strong) NSString* organization;
//
// (Optional) 
//
@property (readwrite, nonatomic, strong) NSString* training;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString* idNumber;
//
// (Optional) Contact information
//
@property (readwrite, nonatomic, strong) HVContact* contact;
//
// (Optional) 
// Vocabulary: person-types
//
@property (readwrite, nonatomic, strong) HVCodableValue* type;

//-------------------------
//
// Initializers
//
//-------------------------
-(id) initWithName:(NSString *) name andPhone:(NSString *) number;
-(id) initWithName:(NSString *)name andEmail:(NSString *)email;
-(id) initWithName:(NSString *)name phone:(NSString *) number andEmail:(NSString *)email;

-(id) initWithFirstName:(NSString *) first lastName:(NSString *) last andPhone:(NSString *) number;
-(id) initWithFirstName:(NSString *) first lastName:(NSString *) last andEmail:(NSString *)email;
-(id) initWithFirstName:(NSString *) first lastName:(NSString *) last phone:(NSString *) phone andEmail:(NSString *)email;


//-------------------------
//
// Vocab
//
//-------------------------
+(HVVocabIdentifier *) vocabForPersonType;

//-------------------------
//
// Text
//
//-------------------------
//
// Returns the person's full name, if any
//
-(NSString *) toString;

@end
