//
//  HVAsyncTask.m
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
#import "HVAsyncTask.h"
#import "HVClient.h"

//-----------------------------------------------
//
// HVTask
//
//-----------------------------------------------
@interface HVTask (HVPrivate)

-(void) setException:(NSException *) error;
-(void) setParent:(HVTask *) task;

-(void) nextStep;

-(void) queueMethod;
-(void) executeMethod;
-(void) childCompleted:(HVTask *) task childCallback:(HVTaskCompletion) callback;

@end

@implementation HVTask

@synthesize isCancelled = m_cancelled;
@synthesize isStarted = m_started;
@synthesize isComplete = m_completed;

@synthesize taskName = m_taskName;
@synthesize exception = m_exception;
@synthesize result = m_result;
@synthesize method = m_taskMethod;
@synthesize callback = m_callback;

@synthesize operation = m_operation;
@synthesize shouldCompleteInMainThread = m_completeInMainThread;

-(BOOL)hasError
{
    return (m_exception != nil);
}

-(BOOL)isDone
{
    return (m_cancelled || m_completed);
}

-(id) result
{
    [self checkSuccess];
    return m_result;
}

-(id) init
{
    return [self initWith:nil];  // this will cause an init failure, which is what we want
}

-(id)initWith:(HVTaskMethod)current
{
    return [self initWithCallback:nil andMethod:current];
}

-(id) initWithCallback:(HVTaskCompletion)callback
{
    return [self initWithCallback:callback andChildTask:nil];
}

-(id)initWithCallback:(HVTaskCompletion)callback andMethod:(HVTaskMethod)method
{
    HVCHECK_NOTNULL(method);
    
    self = [super init];
    HVCHECK_SELF;
    
    if (callback)
    {
        self.callback = callback;
        HVCHECK_NOTNULL(m_callback);
    }
    
    [self setNextMethod:method];
    
    return self;
    
LError:
    HVALLOC_FAIL;
}

-(id)initWithCallback:(HVTaskCompletion)callback andChildTask:(HVTask *)childTask
{
    self = [super init];
    HVCHECK_SELF;
    
    if (callback)
    {
        self.callback = callback;
        HVCHECK_NOTNULL(m_callback);
    }
    
    if (childTask)
    {
        [self setNextTask:childTask];
    }
    
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(void)start
{
    [self start:^{
        [self nextStep];
    }];
}

-(void)start:(HVAction)startAction
{
    @synchronized(self)
    {
        if (self.isDone)
        {
            return;
        }
        
         // We'll free ourselves when we are done (see complete method)
        @try
        {
            m_cancelled = FALSE;
            m_started = TRUE;
            m_completeInMainThread = [NSThread isMainThread];
            if (startAction)
            {
                startAction();
            }
        }
        @catch (id exception)
        {
            [self handleError:exception];
            @throw;
        }
    }
}

-(void) cancel
{
    @synchronized(self)
    {
        if (self.isDone)
        {
            return;
        }
        
        m_cancelled = TRUE;
        @try 
        {
            if (m_operation && [m_operation respondsToSelector:@selector(cancel)])
            {
                [m_operation performSelector:@selector(cancel)];
                self.operation = nil;
            }
        }
        @catch (id exception) 
        {
            // Eat cancellation exceptions, since they are harmless
        }
        
    }
}

-(void) complete
{
    if (m_completeInMainThread && ![NSThread isMainThread])
    {
        [self invokeOnMainThread:@selector(complete)];
        return;
    }

    @synchronized(self)
    {
        self.operation = nil;
        
        if (m_completed)
        {
            return;
        }
        
        m_completed = TRUE;
        if (m_cancelled)
        {
            return;
        }
        
        @try 
        {
            if (m_callback)
            {
                m_callback(self);
            }
        }
        @catch (id exception) 
        {
            [self handleError:exception];
        }
 
    }    
}

-(void) handleError:(id)error
{
    self.exception = error;
    [error log];
}

-(void)clearError
{
    self.exception = nil;
}

-(void)checkSuccess
{
    if (m_exception)
    {
        @throw m_exception;
    }   
}

-(BOOL) setNextMethod:(HVTaskMethod) nextMethod
{
    @synchronized(self)
    {
        if (self.isDone)
        {
            return FALSE;
        }
        
        self.method = nextMethod;
        return TRUE;
    }
}

-(BOOL)setNextTask:(HVTask *) nextTask
{
    @synchronized(self)
    {
        if (self.isDone)
        {
            return FALSE;
        }
        
        if (nextTask.isComplete)
        {
            // Completed synchronously perhaps
            self.exception = nextTask.exception;
            return TRUE;
        }
        
        self.operation = nextTask;
        if (nextTask)
        {
            //
            // Make this task the completion handler, so we can intercept callbacks and handle exceptions right
            //
            HVTaskCompletion childCallback = nextTask.callback;     
            nextTask.parent = self;
            nextTask.callback = ^(HVTask *task) 
            {
                [task.parent childCompleted:task childCallback:childCallback];
            };       
        }
        return TRUE;
    }    
}

-(void) startChild:(HVTask *)childTask
{
    [self setNextTask:childTask];
    [childTask start];
}

@end

@implementation HVTask (HVPrivate)

-(void)setException:(id)error
{
    m_exception = error;
}

-(void)setParent:(HVTask *)task
{
    _parent = task;
}

-(void) nextStep
{
    @synchronized(self)
    {        
        id nextOp = nil;
        @try 
        {     
            if (m_completed)
            {
                return;
            }
            
            if (!m_cancelled)
            {
                if (m_operation)
                {
                    nextOp = m_operation;
                }
                if (nextOp)
                {
                    if ([nextOp respondsToSelector:@selector(start)])
                    {
                        [nextOp performSelector:@selector(start)];
                        return;
                    }
                }
                else if (m_taskMethod)
                {
                    [self queueMethod];
                    return;
                }
            }
        }
        @catch (id exception) 
        {
            [self handleError:exception];
        }
        @finally 
        {
            nextOp = nil;
        }
       
        [self complete];
    }
}

-(void ) queueMethod
{
    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^(void) {
        [self executeMethod];
    }];
    HVCHECK_OOM(op);
    
    self.operation = op;
    
    [[HVClient current] queueOperation:op];
}

-(void)executeMethod
{
    HVTaskMethod method = m_taskMethod;
    @try 
    {
        self.method = nil;
        self.operation = nil;
        if (method)
        {
            method(self);
        }
        
        [self nextStep];
        
        return;
    }
    @catch (id exception) 
    {
        [self handleError:exception];
    }
    @finally 
    {
        method = nil;
    }
    
    [self complete];
    
}

-(void) childCompleted:(HVTask *)child childCallback:(HVTaskCompletion)callback
{
    @try 
    {
        self.operation = nil;
        if (callback)
        {
            callback(child);
        }
        
        [self scheduleNextChildStep];
        [self nextStep];
        
        return;
    }
    @catch (id exception) 
    {
        [self handleError:exception];
    }
    @finally 
    {
        [child setParent:nil];
    }
    
    [self complete];
} 

-(void) scheduleNextChildStep
{
    
}

@end

//-----------------------------------------------
//
// HVTaskSequenceRunner
//
//-----------------------------------------------
@interface HVTaskSequenceRunner : HVTask
{
@protected
    HVTaskSequence* m_sequence;
}

-(id) initWithSequence:(HVTaskSequence *) sequence;

-(BOOL) moveToNextTask;
-(void) notifyAborted;

@end


//-----------------------------------------------
//
// HVTaskSequence
//
//-----------------------------------------------
@implementation HVTaskSequence

@synthesize name = m_name;


-(id)nextObject
{
    return [self nextTask];
}

-(HVTask *)nextTask
{
    return nil;
}

-(void)onAborted
{
    
}

+(HVTask *)run:(HVTaskSequence *)sequence callback:(HVTaskCompletion)callback
{
    HVTask* task = [HVTaskSequence newRunTaskFor:sequence callback:callback];
    [task start];
    
    return task;
}

+(HVTask *)newRunTaskFor:(HVTaskSequence *)sequence callback:(HVTaskCompletion)callback
{
    HVTask* task = [[HVTask alloc] initWithCallback:callback];
    HVCHECK_NOTNULL(task);

    HVTaskSequenceRunner* runner = [[HVTaskSequenceRunner alloc] initWithSequence:sequence];
    HVCHECK_NOTNULL(runner);
    
    [task setNextTask:runner];
    
    return task;
    
LError:
    return nil;
}

@end

@implementation HVTaskStateMachine

@synthesize stateID = m_stateID;

@end

//-----------------------------------------------
//
// HVTaskSequenceRunner
//
//-----------------------------------------------

@implementation HVTaskSequenceRunner

-(id)initWithSequence:(HVTaskSequence *)sequence
{
    HVCHECK_NOTNULL(sequence);
    
    self = [super initWithCallback:^(HVTask *task) {
        
        [task checkSuccess];
        
    }];
    HVCHECK_SELF;
    
    m_sequence = sequence;
    self.taskName = sequence.name;
    
    return self;
    
LError:
    HVALLOC_FAIL;
}


-(void)start
{
    [HVTaskSequenceRunner setNextTaskInSequence:self];
    [super start];
}

-(void)cancel
{
    [super cancel];
    [self notifyAborted];
}

-(void) scheduleNextChildStep
{
    [HVTaskSequenceRunner setNextTaskInSequence:self];
}

+(void) setNextTaskInSequence:(HVTask *) task
{
    HVTaskSequenceRunner* runner = (HVTaskSequenceRunner *) task;
    BOOL isCancelled = TRUE;
    @try
    {
        isCancelled = [runner moveToNextTask];
    }
    @finally
    {
        if (isCancelled)
        {
            [runner notifyAborted];
        }
    }
}

// Return false if aborted -- i.e. cancelled
-(BOOL) moveToNextTask
{
    while (!self.isCancelled)
    {
        HVTask* nextTask = [m_sequence nextTask];
        if (!nextTask)
        {
            self.operation = nil;
            return FALSE;
        }
        
        if (![self setNextTask:nextTask] ||
            !nextTask.isComplete ||
            nextTask.hasError
            )
        {
            return FALSE;
        }
        //
        // Move on to the next state
        //
    }
    
    return TRUE; // aborted
}

-(void)notifyAborted
{
    safeInvokeAction(^{
        [m_sequence onAborted];
    });
}

@end
