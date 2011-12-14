//
//  Operation.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 14/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "Operation.h"
#import "ScrollToRowOperation.h"
#import "TouchDoneNextOperation.h"
#import "ScrollOperation.h"
#import "QueryOperation.h"
#import "SetTextOperation.h"
#import "Recorder.h"

@implementation Operation

+ (id) operationFromDictionary:(NSDictionary*) dictionary {
    NSString *opName = [dictionary valueForKey:@"method_name"];
    Operation* op = nil;
    if ([opName isEqualToString:@"scrollToRow"]) {
        op = [[ScrollToRowOperation alloc] initWithOperation:dictionary];
    } else if ([opName isEqualToString:@"scroll"]) {
        op = [[ScrollOperation alloc] initWithOperation:dictionary];
    } else if ([opName isEqualToString:@"touchDone"]) {
        op = [[TouchDoneNextOperation alloc] initWithOperation:dictionary];
    } else if ([opName isEqualToString:@"query"]) {
        op = [[QueryOperation alloc] initWithOperation:dictionary];
    } else if ([opName isEqualToString:@"setText"]) {
        op = [[SetTextOperation alloc] initWithOperation:dictionary];
    } else {
        op = [[Operation alloc] initWithOperation:dictionary];
    }
    return [op autorelease];
}

- (id) initWithOperation:(NSDictionary *)operation {
	self = [super init];
	if (self != nil) {
		_selector =  NSSelectorFromString( [operation objectForKey:@"method_name"] );
		_arguments = [[operation objectForKey:@"arguments"] retain];
	}
	return self;
}

- (void) dealloc
{
	[_arguments release];_arguments=nil;
	[super dealloc];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"Operation<SEL=%@,Args=%@>",NSStringFromSelector(_selector),_arguments];
}

- (id) performWithTarget:(UIView*)target error:(NSError **)error {
	NSMethodSignature *tSig = [target methodSignatureForSelector:_selector];
	NSUInteger argc = tSig.numberOfArguments - 2;
	if( argc != [_arguments count] ) {
        *error = [NSError errorWithDomain:@"iLessPainful Server" code:1 
                                 userInfo:
                  [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Arity mismatch", @"reason",
                    [NSString stringWithFormat:@"%@ applied to selector %@ with %i args",self,NSStringFromSelector(_selector),argc],@"details"
                   ,nil]];
        return nil;
    }
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:tSig];
	[invocation setSelector:_selector];
	
	NSInteger index = 2; 
	for( NSObject* arg in _arguments) {
		[invocation setArgument:&arg atIndex:index++];
	}
    
	[invocation invokeWithTarget:target];
    
	
	const char *returnType = tSig.methodReturnType;
	
	id returnValue;
	if( !strcmp(returnType, @encode(void)) )
		returnValue =  nil;
	else if( !strcmp(returnType, @encode(id)) ) // retval is an objective c object
	{
		[invocation getReturnValue:&returnValue];
	}else {
		// handle primitive c types by wrapping them in an NSValue
		
		NSUInteger length = [tSig methodReturnLength];
		void *buffer = (void *)malloc(length);
		[invocation getReturnValue:buffer];
		
		// for some reason using [NSValue valueWithBytes:returnType] is creating instances of NSConcreteValue rather than NSValue, so 
		//I'm fudging it here with case-by-case logic
		if( !strcmp(returnType, @encode(BOOL)) ) 
		{
			returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
		}else if( !strcmp(returnType, @encode(NSInteger)) )
		{
			returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
		}else if( !strcmp(returnType, @encode(float)) )
		{
			returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
		}else {
			returnValue = [[[NSValue valueWithBytes:buffer objCType:returnType] copy] autorelease];
		}
		free(buffer);//memory leak here, but apparently NSValue doesn't copy the passed buffer, it just stores the pointer
	}
	return returnValue;	
}

-(void) wait:(CFTimeInterval)seconds {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, seconds, false);
}

-(void) play:(NSArray *)events {
    _done = NO;
    _events = [events retain];
    [[Recorder sharedRecorder] load: events];
    [[Recorder sharedRecorder] playbackWithDelegate: self doneSelector: @selector(playbackDone:)];
}

//-(void) waitUntilPlaybackDone {
//    while(!_done) {
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
//    }
//}

-(void) playbackDone:(NSDictionary *)details {
    _done = YES;
    [_events release];
    _events = nil;
}


@end
