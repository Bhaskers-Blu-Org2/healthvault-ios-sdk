//
//  HVContact.h
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
#import "HVAddress.h"
#import "HVPhone.h"
#import "HVEmail.h"

@interface HVContact : HVType
{
@private
    HVAddressCollection* m_address;
    HVPhoneCollection* m_phone;
    HVEmailCollection* m_email;
}

//-------------------------
//
// Data
//
//-------------------------
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVAddressCollection* address;
// 
// (Optional)
//
@property (readwrite, nonatomic, strong) HVPhoneCollection* phone;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVEmailCollection* email;

//
// Convenience
//
@property (readonly, nonatomic) BOOL hasAddress;
@property (readonly, nonatomic) BOOL hasPhone;
@property (readonly, nonatomic) BOOL hasEmail;

@property (readonly, nonatomic, strong) HVAddress* firstAddress;
@property (readonly, nonatomic, strong) HVPhone* firstPhone;
@property (readonly, nonatomic, strong) HVEmail* firstEmail;

//-------------------------
//
// Initializers
//
//-------------------------
-(id) initWithPhone:(NSString *) phone;
-(id) initWithEmail:(NSString *) email;
-(id) initWithPhone:(NSString *) phone andEmail:(NSString *) email;

@end
