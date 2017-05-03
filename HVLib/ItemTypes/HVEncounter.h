//
//  HVEncounter.h
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

@interface HVEncounter : HVItemDataTyped
{
@private
    HVDateTime* m_when;
    HVCodableValue* m_type;
    NSString* m_reason;
    HVDuration* m_duration;
    HVBool* m_constentGranted;
    HVOrganization* m_facility;
}

//-------------------------
//
// Data
//
//-------------------------
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVDateTime* when;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVCodableValue* encounterType;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString* reason;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVDuration* duration;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVBool* consent;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) HVOrganization* facility;

+(NSString *) typeID;
+(NSString *) XRootElement;

+(HVItem *) newItem;

@end
