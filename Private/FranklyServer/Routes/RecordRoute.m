//
//  RecordRoute.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 15/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "RecordRoute.h"
#import "HTTPDataResponse.h"
#import "Recorder.h"
#import "NoContentResponse.h"

@interface RecordRoute()
- (void) startRecording;
- (NSData *) stopRecording;
@end

@implementation RecordRoute

- (void) setParameters:(NSDictionary*) parameters {
    _params = [parameters retain];
}
- (void) setConnection:(HTTPConnection *)connection {
    _conn = connection;
}

- (void) dealloc {
    [_params release];_params=nil;
    _conn=nil;
    [super dealloc];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    return [method isEqualToString:@"POST"];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSString* action = [_params objectForKey:@"action"];
    if ([action isEqualToString:@"start"]) {
        [self startRecording];
        return [[[NoContentResponse alloc] init] autorelease];
    }
    else if ([action isEqualToString:@"stop"]) {
        NSData* path = [self stopRecording];
        return [[[HTTPDataResponse alloc] initWithData:path] autorelease];
    } else {
        return nil;
    }
    
}


- (void) startRecording {
    [[Recorder sharedRecorder] record];
}
- (NSData *) stopRecording {
    [[Recorder sharedRecorder] stop];
    
    NSString *error=nil;
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:[[Recorder sharedRecorder] events]
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if (error) {
        NSLog(@"error getting plist data: %@",error);
        return nil;
    } else {
        return plistData;
    }
//
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    static NSDateFormatter *fm = nil;
//    if (!fm) {
//        fm=[[NSDateFormatter alloc] init];
//        [fm setDateFormat:@"ddMM'-'HH':'mm':'SSSS"];
//    }
//    NSString* timestamp = [fm stringFromDate:[NSDate date]];
//    NSString* tempFile = [NSString stringWithFormat:@"record_%@_%@.plist",appID,timestamp,nil];
//    
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:tempFile];
//    
//
//    [[Recorder sharedRecorder] saveToFile:plistPath];
//    return tempFile;
}

@end
