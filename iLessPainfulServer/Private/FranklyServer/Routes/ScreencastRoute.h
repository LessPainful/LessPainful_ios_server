//
//  ScreencastRoute.h
//  iLessPainfulServer
//
//  Created by Karl Krukow on 27/08/11.
//  Copyright (c) 2011 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "LPRoute.h"
#import "ScreenCaptureView.h"

@interface ScreencastRoute : NSObject<LPRoute> {
    NSDictionary *_params;
    HTTPConnection *_conn;
    ScreenCaptureView *_screenCapture;
    
}
@end
