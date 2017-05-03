//
//  HVItemTypes.h
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

#import "HVWeight.h"
#import "HVBloodPressure.h"
#import "HVCholesterol.h"
#import "HVCholesterolV2.h"
#import "HVBloodGlucose.h"
#import "HVCholesterolV2.h"
#import "HVHeartRate.h"
#import "HVHeight.h"
#import "HVPeakFlow.h"
#import "HVExercise.h"
#import "HVDailyMedicationUsage.h"
#import "HVEmotionalState.h"
#import "HVSleepJournalAM.h"
#import "HVSleepJournalPM.h"
#import "HVDietaryIntake.h"
#import "HVDailyDietaryIntake.h"
#import "HVAllergy.h"
#import "HVCondition.h"
#import "HVImmunization.h"
#import "HVMedication.h"
#import "HVProcedure.h"
#import "HVVitalSigns.h"
#import "HVEncounter.h"
#import "HVFamilyHistory.h"
#import "HVCCD.h"
#import "HVCCR.h"
#import "HVInsurance.h"
#import "HVEmergencyOrProviderContact.h"
#import "HVPersonalContactInfo.h"
#import "HVBasicDemographics.h"
#import "HVPersonalDemographics.h"
#import "HVPersonalImage.h"
#import "HVAssessment.h"
#import "HVQuestionAnswer.h"
#import "HVFile.h"
#import "HVMessage.h"
#import "HVLabTestResults.h"
#import "HVItemRaw.h"

@interface HVItem (HVTypedExtensions)

-(HVItemDataTyped *) getDataOfType:(NSString *) typeID;

-(HVWeight *) weight;
-(HVBloodPressure *) bloodPressure;
//
// Deprecated. Use cholesterolV2
//
-(HVCholesterol *) cholesterol;
-(HVCholesterolV2 *) cholesterolV2;
-(HVBloodGlucose *) bloodGlucose;
-(HVHeight *) height;
-(HVHeartRate *) heartRate;
-(HVPeakFlow *) peakFlow;
-(HVExercise *) exercise;
-(HVDailyMedicationUsage *) medicationUsage;
-(HVEmotionalState *) emotionalState;
-(HVAssessment *) assessment;
-(HVQuestionAnswer *) questionAnswer;
-(HVDailyDietaryIntake *) dailyDietaryIntake;
-(HVDietaryIntake *) dietaryIntake;
-(HVSleepJournalAM *) sleepJournalAM;
-(HVSleepJournalPM *) sleepJournalPM;

-(HVAllergy *) allergy;
-(HVCondition *) condition;
-(HVImmunization *) immunization;
-(HVMedication *) medication;
-(HVProcedure *) procedure;
-(HVVitalSigns *) vitalSigns;
-(HVEncounter *) encounter;
-(HVFamilyHistory *) familyHistory;
-(HVCCD *) ccd;
-(HVCCR *) ccr;
-(HVInsurance *) insurance;
-(HVMessage *) message;
-(HVLabTestResults *) labResults;

-(HVEmergencyOrProviderContact *) emergencyOrProviderContact;
-(HVPersonalContactInfo *) personalContact;

-(HVBasicDemographics *) basicDemographics;
-(HVPersonalDemographics *) personalDemographics;
-(HVPersonalImage *) personalImage;

-(HVFile *) file;

@end
