//
//  MHVHttp.m
//  MHVLib
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
#import "MHVCommon.h"
#import "MHVHttp.h"
#import "MHVClient.h"

@implementation MHVHttpException

@synthesize error = m_error;
@synthesize statusCode = m_statusCode;

-(id)initWithError:(NSError *)error
{
    self = [super initWithName:@"MHVHttpException" reason:@"Http Error" userInfo:nil];
    HVCHECK_SELF;
    
    m_error = error;
    
    return self;
    
LError:
    HVALLOC_FAIL;
}

-(id)initWithStatusCode:(int)statusCode
{
    self = [super initWithName:@"MHVHttpException" reason:[NSHTTPURLResponse localizedStringForStatusCode:m_statusCode] userInfo:nil];
    HVCHECK_SELF;
    
    m_statusCode = statusCode;
    
    return self;
    
LError:
    HVALLOC_FAIL;    
}

-(NSString *)description
{
    if (m_statusCode > 0 && m_statusCode != 200)
    {
        return [NSHTTPURLResponse localizedStringForStatusCode:m_statusCode];
    }
    
    if (m_error)
    {
        return [m_error localizedDescription];
    }
    
    return [super description];
}


@end

static NSString* const c_header_contentLength = @"Content-Length";
static NSString* const c_header_contentType = @"Content-Type";
static NSString* const c_header_contentRange = @"Content-Range";

@implementation NSMutableURLRequest (HVURLRequestExtensions)

-(void)setContentLength:(NSUInteger)length
{
    NSString* value = [NSString stringWithFormat: @"%lu", (unsigned long)length];
    [self setValue:value forHTTPHeaderField:c_header_contentLength];
}

-(void) setContentRangeStart:(NSUInteger) start end:(NSUInteger) end
{
    NSString* value = [NSString stringWithFormat:@"bytes %lu-%lu/*", (unsigned long)start, (unsigned long)end];
    [self setValue:value forHTTPHeaderField:c_header_contentRange];
    
}

-(void)setContentType:(NSString *)type
{
    [self setValue:type forHTTPHeaderField:c_header_contentType];
}

-(void)setGzipCompression
{
    [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; 
}

@end


@interface MHVHttp (HVPrivate)

-(void) clear;
-(BOOL) retry;
-(void) startImpl;

@end

@implementation MHVHttp

-(NSMutableURLRequest *)request
{
    HVENSURE(m_request, NSMutableURLRequest);
    return m_request;
}

@synthesize connection = m_connection;
@synthesize maxAttempts = m_maxAttempts;
@synthesize currentAttempt = m_currentAttempt;
@synthesize delegate = m_delegate;

-(id)initWithUrl:(NSURL *)url andCallback:(HVTaskCompletion)callback
{
    return [self initWithVerb:nil url:url andCallback:callback];
}

-(id)initWithVerb:(NSString *)verb url:(NSURL *)url andCallback:(HVTaskCompletion)callback
{
    self = [super initWithCallback:callback];
    HVCHECK_SELF;
    
    self.request.URL = url;
    if (verb)
    {
        self.request.HTTPMethod = verb;
    }
 
    HVCHECK_NOTNULL(m_request);
    if ([MHVClient current].settings.httpTimeout > 0)
    {
        m_request.timeoutInterval = [MHVClient current].settings.httpTimeout;
    }
    
    m_maxAttempts = 2;  // By default, make at least 2 attempts - due to the vagaries of the internet
    
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(void)start
{
    if ([NSThread isMainThread])
    {
        [self startImpl];
    }
    else
    {
        //
        // NSURLConnection needs to be created on a thread with a guaranteed RunLoop in default mode
        // Only way to truly guarantee this is to default to the main thread
        //
        [self invokeOnMainThread:@selector(startImpl)];
    }

    [super start];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (m_currentAttempt < m_maxAttempts)
    {
        //
        // Retry the request
        //
        if ([self retry])
        {
            return;
        }
    }

    MHVHttpException* ex = [[MHVHttpException alloc] initWithError:error];
    [super handleError:ex];
 
    [self complete];
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (m_delegate)
    {
        [m_delegate totalBytesWritten:totalBytesWritten];
    }
}

@end

@implementation MHVHttp (HVPrivate)

-(void)startImpl
{
    if (!m_connection)
    {
        m_connection = [[NSURLConnection alloc] initWithRequest:m_request delegate:self];
    }
    
    if (!self.operation)
    {
        self.operation = m_connection;
    }
    
    m_currentAttempt++;    
}

-(void)clear
{
    self.operation = nil;
    m_connection = nil;
}

-(BOOL) retry
{
    [self clear];
    @try 
    {
        [self start];
        return TRUE;
    }
    @catch (id exception) 
    {
        
    }
    
    return FALSE; // Retry could not start
}
@end
