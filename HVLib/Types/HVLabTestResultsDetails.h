//
//  HVLabTestResultsDetails.h
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
//

#import <Foundation/Foundation.h>
#import "HVType.h"
#import "HVApproxDateTime.h"
#import "HVCodableValue.h"
#import "HVLabTestResultValue.h"
#import "HVCollection.h"

@interface HVLabTestResultsDetails : HVType
{
@private
    HVApproxDateTime* m_when;
    NSString* m_name;
    HVCodableValue* m_substance;
    HVCodableValue* m_collectionMethod;
    HVCodableValue* m_clinicalCode;
    HVLabTestResultValue* m_value;
    HVCodableValue* m_status;
    NSString* m_note;
}

@property (readwrite, nonatomic, strong) HVApproxDateTime* when;
@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, strong) HVCodableValue* substance;
@property (readwrite, nonatomic, strong) HVCodableValue* collectionMethod;
@property (readwrite, nonatomic, strong) HVCodableValue* clinicalCode;
@property (readwrite, nonatomic, strong) HVLabTestResultValue* value;
@property (readwrite, nonatomic, strong) HVCodableValue* status;
@property (readwrite, nonatomic, strong) NSString* note;

@end

@interface HVLabTestResultsDetailsCollection : HVCollection

-(void) addItem:(HVLabTestResultsDetails *) item;
-(HVLabTestResultsDetails *) itemAtIndex:(NSUInteger) index;

@end
