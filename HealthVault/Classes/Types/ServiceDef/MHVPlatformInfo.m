//
// MHVPlatformInfo.m
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

#import "MHVCommon.h"
#import "MHVPlatformInfo.h"

static const xmlChar *x_element_url = XMLSTRINGCONST("url");
static const xmlChar *x_element_version = XMLSTRINGCONST("version");
static NSString *c_element_config = @"configuration";

@implementation MHVPlatformInfo

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_url value:self.url];
    [writer writeElementXmlName:x_element_version value:self.version];
    [writer writeElementArray:c_element_config elements:self.config];
}

- (void)deserialize:(XReader *)reader
{
    self.url = [reader readStringElementWithXmlName:x_element_url];
    self.version = [reader readStringElementWithXmlName:x_element_version];
    self.config = [reader readElementArray:c_element_config
                                   asClass:[MHVConfigurationEntry class]
                             andArrayClass:[NSMutableArray class]];
}

@end
