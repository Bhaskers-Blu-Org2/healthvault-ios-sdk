//
// MHVActionPlansApi.m
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
#import "MHVRemoteMonitoringClient.h"
#import "MHVJsonSerializer.h"
#import "MHVActionPlansApi.h"
#import "MHVActionPlan.h"
#import "MHVActionPlanAdherenceSummary.h"
#import "MHVActionPlanInstance.h"
#import "MHVActionPlansResponseActionPlanInstance_.h"
#import "MHVErrorResponse.h"


@implementation MHVRemoteMonitoringClient (MHVActionPlansApi)

NSString* _Nonnull kMHVActionPlansApiErrorDomain = @"MHVActionPlansApiErrorDomain";
NSInteger kMHVActionPlansApiMissingParamErrorCode = 234513;

#pragma mark - Api Methods

///
/// Remove an action plan objective
/// 
///  @param actionPlanId The instance of the plan that the objective belongs to. 
///
///  @param objectiveId The instance of the objective to delete. 
///
///  @returns void
///
- (void)actionPlanObjectivesDeleteWithActionPlanId:(NSString* _Nonnull)actionPlanId
    objectiveId:(NSString* _Nonnull)objectiveId
    completion:(void(^_Nonnull)(NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlanId' is set
    if (actionPlanId == nil)
    {
        NSParameterAssert(actionPlanId);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlanId"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(error);
        }
    }

    // verify the required parameter 'objectiveId' is set
    if (objectiveId == nil)
    {
        NSParameterAssert(objectiveId);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"objectiveId"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans/{actionPlanId}/Objectives/{objectiveId}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (actionPlanId != nil)
    {
        pathParams[@"actionPlanId"] = actionPlanId;
    }
    if (objectiveId != nil)
    {
        pathParams[@"objectiveId"] = objectiveId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;

    [self requestWithPath:resourcePath
                      httpMethod:@"DELETE"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                      completion:completion];
}

///
/// Post an action plan instance
/// 
///  @param actionPlan The instance of the plan to create. 
///
///  @returns MHVActionPlanInstance*
///
- (void)actionPlansCreateWithActionPlan:(MHVActionPlan* _Nonnull)actionPlan
    completion:(void(^_Nonnull)(MHVActionPlanInstance* _Nullable output, NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlan' is set
    if (actionPlan == nil)
    {
        NSParameterAssert(actionPlan);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlan"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;
    NSString *json = [MHVJsonSerializer serialize:actionPlan];
    bodyParam = [json dataUsingEncoding:NSUTF8StringEncoding];

    [self requestWithPath:resourcePath
                      httpMethod:@"POST"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlanInstance class]
                      completion:completion];
}

///
/// Delete an action plan instance
/// 
///  @param actionPlanId The instance of the plan to delete. 
///
///  @returns void
///
- (void)actionPlansDeleteWithActionPlanId:(NSString* _Nonnull)actionPlanId
    completion:(void(^_Nonnull)(NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlanId' is set
    if (actionPlanId == nil)
    {
        NSParameterAssert(actionPlanId);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlanId"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans/{actionPlanId}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (actionPlanId != nil)
    {
        pathParams[@"actionPlanId"] = actionPlanId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;

    [self requestWithPath:resourcePath
                      httpMethod:@"DELETE"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                      completion:completion];
}

///
/// Get a collection of action plans
/// 
///  @param maxPageSize The maximum number of entries to return per page. Defaults to 1000. (optional)
///
///  @returns MHVActionPlansResponseActionPlanInstance_*
///
- (void)actionPlansGetWithMaxPageSize:(NSNumber* _Nullable)maxPageSize
    completion:(void(^_Nonnull)(MHVActionPlansResponseActionPlanInstance_* _Nullable output, NSError* _Nullable error))completion
{
    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (maxPageSize != nil)
    {
        queryParams[@"maxPageSize"] = maxPageSize;
    }

    NSData *bodyParam = nil;

    [self requestWithPath:resourcePath
                      httpMethod:@"GET"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlansResponseActionPlanInstance_ class]
                      completion:completion];
}

///
/// Gets adherence information for an action plan.
/// 
///  @param startTime The start time. 
///
///  @param endTime The end time. 
///
///  @param actionPlanId The action plan identifier. 
///
///  @param objectiveId The objective to filter the report to. (optional)
///
///  @param taskId The task to filter the report to. (optional)
///
///  @returns MHVActionPlanAdherenceSummary*
///
- (void)actionPlansGetAdherenceWithStartTime:(NSDate* _Nonnull)startTime
    endTime:(NSDate* _Nonnull)endTime
    actionPlanId:(NSString* _Nonnull)actionPlanId
    objectiveId:(NSString* _Nullable)objectiveId
    taskId:(NSString* _Nullable)taskId
    completion:(void(^_Nonnull)(MHVActionPlanAdherenceSummary* _Nullable output, NSError* _Nullable error))completion
{
    // verify the required parameter 'startTime' is set
    if (startTime == nil)
    {
        NSParameterAssert(startTime);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"startTime"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    // verify the required parameter 'endTime' is set
    if (endTime == nil)
    {
        NSParameterAssert(endTime);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"endTime"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    // verify the required parameter 'actionPlanId' is set
    if (actionPlanId == nil)
    {
        NSParameterAssert(actionPlanId);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlanId"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans/{actionPlanId}/Adherence"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (actionPlanId != nil)
    {
        pathParams[@"actionPlanId"] = actionPlanId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (startTime != nil)
    {
        queryParams[@"startTime"] = startTime;
    }
    if (endTime != nil)
    {
        queryParams[@"endTime"] = endTime;
    }
    if (objectiveId != nil)
    {
        queryParams[@"objectiveId"] = objectiveId;
    }
    if (taskId != nil)
    {
        queryParams[@"taskId"] = taskId;
    }

    NSData *bodyParam = nil;

    [self requestWithPath:resourcePath
                      httpMethod:@"GET"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlanAdherenceSummary class]
                      completion:completion];
}

///
/// Get an instance of a specific action plan
/// 
///  @param actionPlanId The action plan to update. 
///
///  @returns MHVActionPlanInstance*
///
- (void)actionPlansGetByIdWithActionPlanId:(NSString* _Nonnull)actionPlanId
    completion:(void(^_Nonnull)(MHVActionPlanInstance* _Nullable output, NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlanId' is set
    if (actionPlanId == nil)
    {
        NSParameterAssert(actionPlanId);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlanId"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans/{actionPlanId}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (actionPlanId != nil)
    {
        pathParams[@"actionPlanId"] = actionPlanId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;

    [self requestWithPath:resourcePath
                      httpMethod:@"GET"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlanInstance class]
                      completion:completion];
}

///
/// Update/Replace a complete action plan instance with no merge.
/// 
///  @param actionPlan The instance of the plan to update. The entire plan will be replaced with this version. 
///
///  @returns MHVActionPlanInstance*
///
- (void)actionPlansReplaceWithActionPlan:(MHVActionPlanInstance* _Nonnull)actionPlan
    completion:(void(^_Nonnull)(MHVActionPlanInstance* _Nullable output, NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlan' is set
    if (actionPlan == nil)
    {
        NSParameterAssert(actionPlan);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlan"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;
    NSString *json = [MHVJsonSerializer serialize:actionPlan];
    bodyParam = [json dataUsingEncoding:NSUTF8StringEncoding];

    [self requestWithPath:resourcePath
                      httpMethod:@"PUT"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlanInstance class]
                      completion:completion];
}

///
/// Update an action plan instance with merge
/// 
///  @param actionPlan The instance of the plan to update. Only the fields present in the passed in model will be updated. All other fields and colelctions              will be left, as is, unless invalid. 
///
///  @returns MHVActionPlanInstance*
///
- (void)actionPlansUpdateWithActionPlan:(MHVActionPlanInstance* _Nonnull)actionPlan
    completion:(void(^_Nonnull)(MHVActionPlanInstance* _Nullable output, NSError* _Nullable error))completion
{
    // verify the required parameter 'actionPlan' is set
    if (actionPlan == nil)
    {
        NSParameterAssert(actionPlan);
        if(completion)
        {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"actionPlan"] };
            NSError* error = [NSError errorWithDomain:kMHVActionPlansApiErrorDomain code:kMHVActionPlansApiMissingParamErrorCode userInfo:userInfo];
            completion(nil, error);
        }
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/ActionPlans"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];

    NSData *bodyParam = nil;
    NSString *json = [MHVJsonSerializer serialize:actionPlan];
    bodyParam = [json dataUsingEncoding:NSUTF8StringEncoding];

    [self requestWithPath:resourcePath
                      httpMethod:@"PATCH"
                      pathParams:pathParams
                     queryParams:queryParams
                            body:bodyParam
                     resultClass:[MHVActionPlanInstance class]
                      completion:completion];
}



@end
