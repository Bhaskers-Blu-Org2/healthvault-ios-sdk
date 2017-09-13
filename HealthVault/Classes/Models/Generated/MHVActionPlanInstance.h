//
// MHVActionPlanInstance.h
// MHVLib
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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

/**
* NOTE: This class is auto generated by the swagger code generator program.
* https://github.com/swagger-api/swagger-codegen.git
* Do not edit the class manually.
*/


#import <Foundation/Foundation.h>

#import "MHVActionPlanTaskInstance.h"
#import "MHVObjective.h"
#import "MHVModelBase.h"
#import "MHVEnum.h"


@protocol MHVActionPlanInstance
@end

NS_ASSUME_NONNULL_BEGIN

@interface MHVActionPlanInstanceStatusEnum : MHVEnum
+(MHVActionPlanInstanceStatusEnum *)MHVUnknown;
+(MHVActionPlanInstanceStatusEnum *)MHVArchived;
+(MHVActionPlanInstanceStatusEnum *)MHVRecommended;
+(MHVActionPlanInstanceStatusEnum *)MHVInProgress;
+(MHVActionPlanInstanceStatusEnum *)MHVCompleted;
+(MHVActionPlanInstanceStatusEnum *)MHVTemplate;
@end
@interface MHVActionPlanInstanceCategoryEnum : MHVEnum
+(MHVActionPlanInstanceCategoryEnum *)MHVUnknown;
+(MHVActionPlanInstanceCategoryEnum *)MHVHealth;
+(MHVActionPlanInstanceCategoryEnum *)MHVSleep;
+(MHVActionPlanInstanceCategoryEnum *)MHVActivity;
+(MHVActionPlanInstanceCategoryEnum *)MHVStress;
@end

@interface MHVActionPlanInstance : MHVModelBase

/* The ID of the plan instance 
 */
@property(strong,nonatomic) NSString* identifier;
/* The status of the plan 
 */
@property(strong,nonatomic) MHVActionPlanInstanceStatusEnum* status;
/* The ID of the organization that manages this plan. Read-only [optional]
 */
@property(strong,nonatomic,nullable) NSString* organizationId;
/* The name of the organization that manages this plan. Read-only [optional]
 */
@property(strong,nonatomic,nullable) NSString* organizationName;
/* The Task instances associated with this plan [optional]
 */
@property(strong,nonatomic,nullable) NSArray<MHVActionPlanTaskInstance *>* associatedTasks;
/* The name of the plan, localized [optional]
 */
@property(strong,nonatomic,nullable) NSString* name;
/* The description of the plan, localized [optional]
 */
@property(strong,nonatomic,nullable) NSString* descriptionText;
/* An HTTPS URL to an image for the plan. Suggested resolution is 212x212 with a 25px margin in the image. 
 */
@property(strong,nonatomic) NSString* imageUrl;
/* An HTTPS URL to a thumbnail image for the plan. Suggested resolution is 212x212 with a 25px margin in the image. 
 */
@property(strong,nonatomic) NSString* thumbnailImageUrl;
/* The category of the plan 
 */
@property(strong,nonatomic) MHVActionPlanInstanceCategoryEnum* category;
/* The Collection of objectives for the plan 
 */
@property(strong,nonatomic) NSArray<MHVObjective *>* objectives;

@end

NS_ASSUME_NONNULL_END