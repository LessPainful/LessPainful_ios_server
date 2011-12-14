//
//  NoContentResponse.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 15/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "NoContentResponse.h"

@implementation NoContentResponse


- (UInt64)contentLength {return 0;}

- (UInt64)offset {return 0;}
- (void)setOffset:(UInt64)offset{}

- (NSData *)readDataOfLength:(NSUInteger)length {return nil;}

- (BOOL)isDone {return YES;}

- (NSInteger)status {return 203;}
@end
