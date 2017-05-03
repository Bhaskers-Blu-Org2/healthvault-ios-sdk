//
//  HVBlobUploadTask.m
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
#import "HVLib.h"
#import "HVItemBlobUploadTask.h"

@interface HVItemBlobUploadTask (HVPrivate)

-(void) uploadBlobComplete:(HVTask *)task;
-(void) updateBlobWithUrl:(NSString *) url andLength:(NSInteger) length;
-(void) putItemInHV;

@end

@implementation HVItemBlobUploadTask

@synthesize blobInfo = m_blobInfo;
@synthesize item = m_item;
@synthesize record = m_record;

-(HVItemKey *)itemKey
{
    return (HVItemKey *) self.result;
}

-(id)initWithSource:(id<HVBlobSource>)data blobInfo:(HVBlobInfo *)blobInfo forItem:(HVItem *)item record:(HVRecordReference *) record andCallback:(HVTaskCompletion)callback
{
    HVCHECK_NOTNULL(data);
    HVCHECK_NOTNULL(blobInfo);
    HVCHECK_NOTNULL(record);
    
    self = [super initWithCallback:callback];
    HVCHECK_SELF;
    
    m_blobInfo = blobInfo;
    m_item = item;
    m_record = record;
    //
    // Step 1 - upload the blob to HealthVault
    // If that succeeds, then update the item
    //
    HVBlobUploadTask* uploadTask = [[HVBlobUploadTask alloc] initWithSource:data record:record andCallback:^(HVTask *task) {
        
        [self uploadBlobComplete:task];
        
    } ];
    
    HVCHECK_NOTNULL(uploadTask);
    uploadTask.delegate = self;
    
    [self setNextTask:uploadTask];
    
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(void)totalBytesWritten:(NSInteger)byteCount
{
    if (self.delegate)
    {
        [self.delegate totalBytesWritten:byteCount];
    }
}

@end

@implementation HVItemBlobUploadTask (HVPrivate)

-(void)uploadBlobComplete:(HVTask *)task
{
    HVBlobUploadTask* uploadTask = (HVBlobUploadTask *) task;
    //
    // The URL for this blob
    //
    NSString* blobUrl = uploadTask.blobUrl;
    //
    // Update the item with the new Blob & Length info
    // The Item will now contain an updated reference to the new blob
    //
    [self updateBlobWithUrl:blobUrl andLength:uploadTask.source.length];
    //
    // Step 2. push item into HV
    //
    [self putItemInHV];
}

-(void)updateBlobWithUrl:(NSString *)url andLength:(NSInteger)length
{
    HVBlobPayloadItem* blobItem = [[HVBlobPayloadItem alloc] init];
    HVCHECK_OOM(blobItem);
    
    blobItem.blobInfo = m_blobInfo;
    blobItem.length = length;
    blobItem.blobUrl = url;
    
    [m_item.blobs addOrUpdateBlob:blobItem];
}

-(void)putItemInHV
{
    HVPutItemsTask* putTask = [[HVClient current].methodFactory newPutItemForRecord:m_record item:m_item andCallback:^(HVTask *task) {
        
        [task checkSuccess];
        self.result = ((HVPutItemsTask *) task).firstKey;
        
    } ];
    
    putTask.record = m_record;
    [self setNextTask:putTask];    
}
@end
