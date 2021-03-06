//
// MHVHeartrateZone.m
// MHVLib
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


#import "MHVHeartrateZone.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_lower_bound = @"lower-bound";
static NSString *const c_element_upper_bound = @"upper-bound";

@implementation MHVHeartrateZone

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name value:self.name];
    [writer writeElement:c_element_lower_bound content:self.lowerBound];
    [writer writeElement:c_element_upper_bound content:self.upperBound];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readStringElement:c_element_name];
    self.lowerBound = [reader readElement:c_element_lower_bound asClass:[MHVZoneBoundary class]];
    self.upperBound = [reader readElement:c_element_upper_bound asClass:[MHVZoneBoundary class]];
}

@end
