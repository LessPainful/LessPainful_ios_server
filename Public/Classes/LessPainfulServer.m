//
//  LessPainfulServer.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 11/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "LessPainfulServer.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "LPRouter.h"
#import "ScreenshotRoute.h"
#import "MapRoute.h"
#import "RecordRoute.h"
#import "PlaybackRoute.h"
#import "ScreencastRoute.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@interface LessPainfulServer()
- (void) start;
@end
@implementation LessPainfulServer


+ (void) start {
    LessPainfulServer* server = [[LessPainfulServer alloc] init];
    [server start];
}

- (id) init
{
	self = [super init];    
	if (self != nil) {
		[DDLog addLogger:[DDTTYLogger sharedInstance]];
        MapRoute* mr = [MapRoute new];
        [LPRouter addRoute:mr forPath:@"/map"];
        [mr release];
        ScreenshotRoute *sr =[ScreenshotRoute new];
        [LPRouter addRoute:sr forPath:@"/screenshot"];
        [sr release];

        RecordRoute *rr =[RecordRoute new];
        [LPRouter addRoute:rr forPath:@"/record"];
        [rr release];

        PlaybackRoute *pr =[PlaybackRoute new];
        [LPRouter addRoute:pr forPath:@"/play"];
        [pr release];
        
        ScreencastRoute *scr = [ScreencastRoute new];
        [LPRouter addRoute:scr forPath:@"/screencast"];
        [scr release];
        

		_httpServer = [[[HTTPServer alloc]init] retain];
		
		[_httpServer setName:@"iLessPainful Server"];
		[_httpServer setType:@"_http._tcp."];
		[_httpServer setConnectionClass:[LPRouter class]];
		[_httpServer setPort:37265];
        // Serve files from our embedded Web folder
//        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
//        [_httpServer setDocumentRoot:webPath];
		NSLog( @"Creating the server: %@", _httpServer );
	}
	return self;
}

- (void) start {
    NSError *error=nil;
	if( ![_httpServer start:&error] ) {
		DDLogError(@"Error starting HTTP Server: %@",error);// %@", error);
	}
}

- (void) dealloc
{
	[_httpServer release];
	[super dealloc];
}


@end
