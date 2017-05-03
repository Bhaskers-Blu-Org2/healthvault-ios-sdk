//
//  HVBloodGlucose.m
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

#import "HVCommon.h"
#import "HVBloodGlucose.h"

static NSString* const c_typeid = @"879e7c04-4e8a-4707-9ad3-b054df467ce4";
static NSString* const c_typename = @"blood-glucose";

static const xmlChar* x_element_when = XMLSTRINGCONST("when");
static const xmlChar* x_element_value = XMLSTRINGCONST("value");
static const xmlChar* x_element_type = XMLSTRINGCONST("glucose-measurement-type");
static const xmlChar* x_element_operatingTemp = XMLSTRINGCONST("outside-operating-temp");
static const xmlChar* x_element_controlTest = XMLSTRINGCONST("is-control-test");
static const xmlChar* x_element_normalcy = XMLSTRINGCONST("normalcy");
static const xmlChar* x_element_context = XMLSTRINGCONST("measurement-context");

static NSString* const c_vocab_measurement = @"glucose-measurement-type";

@interface HVBloodGlucose (HVPrivate)

+(HVCodableValue *) newMeasurementText:(NSString *) text andCode:(NSString *) code;
+(HVCodedValue *) newMeasurementCode:(NSString *) code;

@end

@implementation HVBloodGlucose

@synthesize when = m_when;
@synthesize value = m_value;
@synthesize measurementType = m_measurementType;
@synthesize isOutsideOperatingTemp = m_outsideOperatingTemp;
@synthesize isControlTest = m_controlTest;
@synthesize context = m_context;

-(NSDate *)getDate
{
    return [m_when toDate];
}

-(NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [m_when toDateForCalendar:calendar];
}

-(double)inMgPerDL
{
    return (m_value) ? m_value.mgPerDL : NAN;
}

-(void)setInMgPerDL:(double)inMgPerDL
{
    HVENSURE(m_value, HVBloodGlucoseMeasurement);
    m_value.mgPerDL = inMgPerDL;
}

-(double)inMmolPerLiter
{
    return (m_value) ? m_value.mmolPerLiter : NAN;
}

-(void)setInMmolPerLiter:(double)inMmolPerLiter
{
    HVENSURE(m_value, HVBloodGlucoseMeasurement);
    m_value.mmolPerLiter = inMmolPerLiter;
}

-(enum HVRelativeRating)normalcy
{
    return (m_normalcy) ? (enum HVRelativeRating) m_normalcy.value : HVRelativeRating_None;
}

-(void)setNormalcy:(enum HVRelativeRating)normalcy
{
    if (normalcy == HVRelativeRating_None)
    {
        m_normalcy = nil;
    }
    else 
    {
        HVENSURE(m_normalcy, HVOneToFive);
        m_normalcy.value = normalcy;
    }
}

-(id)initWithMmolPerLiter:(double)value andDate:(NSDate *)date
{
    HVCHECK_NOTNULL(date);
    
    self = [super init];
    HVCHECK_SELF;
    
    self.inMmolPerLiter = value;
    HVCHECK_NOTNULL(m_value);
    
    m_when = [[HVDateTime alloc] initWithDate:date];
    HVCHECK_NOTNULL(m_when);
    
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(NSString *)stringInMgPerDL:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMgPerDL];
}

-(NSString *)stringInMmolPerLiter:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMmolPerLiter];
}

-(NSString *)toString
{
    return [self stringInMmolPerLiter:@"%.3f mmol/L"];
}

-(NSString *)normalcyText
{
    return stringFromRating(self.normalcy);
}

+(HVCodableValue *)createPlasmaMeasurementType
{
    return [HVBloodGlucose newMeasurementText:@"Plasma" andCode:@"p"];
}

+(HVCodableValue *)createWholeBloodMeasurementType
{
    return [HVBloodGlucose newMeasurementText:@"Whole blood" andCode:@"wb"];
}

+(HVVocabIdentifier *)vocabForContext
{
    return [[HVVocabIdentifier alloc] initWithFamily:c_hvFamily andName:@"glucose-measurement-context"];    
}

+(HVVocabIdentifier *)vocabForMeasurementType
{
    return [[HVVocabIdentifier alloc] initWithFamily:c_hvFamily andName:@"glucose-measurement-type"];    
}

+(HVVocabIdentifier *)vocabForNormalcy
{
    return [[HVVocabIdentifier alloc] initWithFamily:c_hvFamily andName:@"normalcy-one-to-five"];    
}

-(HVClientResult *)validate
{
    HVVALIDATE_BEGIN
    
    HVVALIDATE(m_when, HVClientError_InvalidBloodGlucose);
    HVVALIDATE(m_value, HVClientError_InvalidBloodGlucose);
    HVVALIDATE(m_measurementType, HVClientError_InvalidBloodGlucose);
    HVVALIDATE_OPTIONAL(m_outsideOperatingTemp);
    HVVALIDATE_OPTIONAL(m_controlTest);
    HVVALIDATE_OPTIONAL(m_normalcy);
    HVVALIDATE_OPTIONAL(m_context);

    HVVALIDATE_SUCCESS
}

-(void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:m_when];
    [writer writeElementXmlName:x_element_value content:m_value];
    [writer writeElementXmlName:x_element_type content:m_measurementType];
    [writer writeElementXmlName:x_element_operatingTemp content:m_outsideOperatingTemp];
    [writer writeElementXmlName:x_element_controlTest content:m_controlTest];
    [writer writeElementXmlName:x_element_normalcy content:m_normalcy];
    [writer writeElementXmlName:x_element_context content:m_context];
}

-(void)deserialize:(XReader *)reader
{
    m_when = [reader readElementWithXmlName:x_element_when asClass:[HVDateTime class]];
    m_value = [reader readElementWithXmlName:x_element_value asClass:[HVBloodGlucoseMeasurement class]];
    m_measurementType = [reader readElementWithXmlName:x_element_type asClass:[HVCodableValue class]];
    m_outsideOperatingTemp = [reader readElementWithXmlName:x_element_operatingTemp asClass:[HVBool class]];
    m_controlTest = [reader readElementWithXmlName:x_element_controlTest asClass:[HVBool class]];
    m_normalcy = [reader readElementWithXmlName:x_element_normalcy asClass:[HVOneToFive class]];
    m_context = [reader readElementWithXmlName:x_element_context asClass:[HVCodableValue class]];
}

+(NSString *)typeID
{
    return c_typeid;
}

+(NSString *) XRootElement
{
    return c_typename;
}

+(HVItem *) newItem
{
    return [[HVItem alloc] initWithType:[HVBloodGlucose typeID]];
}

-(NSString *)typeName
{
    return NSLocalizedString(@"Blood Glucose", @"Blood Glucose Type Name");
}

@end

@implementation HVBloodGlucose (HVPrivate)
    
+(HVCodableValue *)newMeasurementText:(NSString *)text andCode:(NSString *)code
{
    HVCodedValue* codedValue = [HVBloodGlucose newMeasurementCode:code];
    HVCodableValue* codableValue = [[HVCodableValue alloc] initWithText:text andCode:codedValue];
    return codableValue;
}

+(HVCodedValue *) newMeasurementCode:(NSString *)code
{
    return [[HVCodedValue alloc] initWithCode:code andVocab:c_vocab_measurement];
}

@end
