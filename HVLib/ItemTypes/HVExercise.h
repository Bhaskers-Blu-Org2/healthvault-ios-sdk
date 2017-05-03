//
//  HVExercise.h
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

@interface HVExercise : HVItemDataTyped
{
@private
    HVApproxDateTime* m_when;
    HVCodableValue* m_activity;
    NSString* m_title;
    HVLengthMeasurement* m_distance;
    HVPositiveDouble* m_duration;
    HVNameValueCollection* m_details;
    NSMutableArray* m_segmentsXml;
}

//-------------------------
//
// Data
//
//-------------------------
//
// (Required) When did you do this exercise
//
@property (readwrite, nonatomic, strong) HVApproxDateTime* when;
//
// (Required) What activity did you perform?
// Preferred Vocabulary: exercise-activities
//
@property (readwrite, nonatomic, strong) HVCodableValue* activity;
//
// Optional (a label)
//
@property (readwrite, nonatomic, strong) NSString* title;
//
// (Optional): Distance covered, if any
//
@property (readwrite, nonatomic, strong) HVLengthMeasurement* distance;
//
// (Optional): Duration, if any
//
@property (readwrite, nonatomic, strong) HVPositiveDouble* durationMinutes;
//
// (Optional): Additional details about the exercise
// E.g number of steps, calories burned...
// 
// This collection of Name Value Pairs uses standardized names
// Standardized names should be taken from the vocabulary: exercise-detail-names
//
@property (readwrite, nonatomic, strong) HVNameValueCollection* details;
//
// (Optional): Information about exercise segments
//
@property (readwrite, nonatomic, strong) NSMutableArray* segmentsXml;

//-----------------------------
//
// Convenience properties
//
//-----------------------------
@property (readonly, nonatomic) BOOL hasDetails;
@property (readwrite, nonatomic) double durationMinutesValue;


//-------------------------
//
// Initializers
//
//-------------------------
+(HVItem *) newItem;

-(id) initWithDate:(NSDate *) date;

//-------------------------
//
// Methods
//
//-------------------------
//
// This assumes that the activity is from the standard vocabulary: exercise-activties
//
+(HVCodableValue *) createActivity:(NSString *) activity;
-(BOOL) setStandardActivity:(NSString *) activity;
//
// This assume that the exercise detail is from the standard vocab:exercise-detail-names
// 
-(HVNameValue *) getDetailWithNameCode:(NSString *) name;
-(BOOL) addOrUpdateDetailWithNameCode:(NSString *) name andValue:(HVMeasurement *) value;

//-------------------------
//
// Exercise Details (self.details)
//
//-------------------------
+(HVNameValue *) createDetailWithNameCode:(NSString *) name andValue:(HVMeasurement *) value;

+(BOOL) isDetailForCaloriesBurned:(HVNameValue *) nv;
+(BOOL) isDetailForNumberOfSteps:(HVNameValue *) nv;

//
// Uses VOCABULARIES
//  - exercise-details-names for the detail Name
//  - exercise-units for measurement units
//
+(HVCodableValue *) codeFromUnitsText:(NSString *) unitsText andUnitsCode:(NSString *) unitsCode;
+(HVCodableValue *) unitsCodeForCount;
+(HVCodableValue *) unitsCodeForCalories;

+(HVMeasurement *) measurementFor:(double) value unitsText:(NSString *) unitsText unitsCode:(NSString *) unitsCode;
+(HVMeasurement *) measurementForCount:(double) value;
+(HVMeasurement *) measurementForCalories:(double) value;

+(HVCodedValue *) detailNameWithCode:(NSString *) code;
+(HVCodedValue *) detailNameForSteps;
+(HVCodedValue *) detailNameForCaloriesBurned;

//-------------------------
//
// Vocabs
//
//-------------------------
+(HVVocabIdentifier *) vocabForActivities;
+(HVVocabIdentifier *) vocabForDetails;
+(HVVocabIdentifier *) vocabForUnits;


//-------------------------
//
// Type Information
//
//-------------------------

+(NSString *) typeID;
+(NSString *) XRootElement;

@end

