//
//  RecordRoute.h
//  iLessPainfulServer
//
//  Created by Karl Krukow on 15/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRoute.h"
@interface RecordRoute : NSObject<LPRoute> {
    NSDictionary *_params;
    HTTPConnection *_conn;
}
@end
