//
//  TouchDoneNextOperation.m
//  MobileBank
//
//  Created by Karl Krukow on 21/08/11.
//  Copyright (c) 2011 Trifork. All rights reserved.
//

#import "TouchDoneNextOperation.h"
#import "UIScriptParser.h"
#import "Recorder.h"
#import "Resources.h"
#import "LPTouchUtils.h"

@implementation TouchDoneNextOperation
- (NSString *) description {
	return [NSString stringWithFormat:@"Touch Done/Next"];
}

- (id) performWithTarget:(UIView*)_view error:(NSError **)error {
    UIScriptParser* p=[[UIScriptParser alloc]initWithUIScript:@"view:'UIKBKeyView'"];
    [p parse];
    NSMutableArray* views = [NSMutableArray arrayWithCapacity:32];
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        [views addObjectsFromArray:[window subviews]];
    }
    NSArray* result = [p evalWith:views];

    NSUInteger index=-1;
    NSUInteger maxPointIndex=-1;
    CGPoint maxPoint = CGPointZero;
    for (UIView* view in result) {
        index++;
        CGPoint vp = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height);
        
        if (vp.x >= maxPoint.x && vp.y >= maxPoint.y) {
            maxPoint = vp;
            maxPointIndex = index;
        }
    }
    
    UIView* theView = [result objectAtIndex:maxPointIndex];

    _events =  [[Resources transformEvents: [Resources eventsFromEncoding:[_arguments objectAtIndex:0]]  
                            toPoint:[LPTouchUtils centerOfView: theView ]] retain];
    [self play:_events];
        
	return theView;
}

-(void) play:(NSArray *)events {
    _done = NO;
    [[Recorder sharedRecorder] load: _events];
    [[Recorder sharedRecorder] playbackWithDelegate: self doneSelector: @selector(playbackDone:)];

}

//-(void) waitUntilPlaybackDone {
//    while(!_done) {
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 3, false);
//    }
//}

-(void) playbackDone:(NSDictionary *)details {
    _done = YES;
    [_events release];
    _events=nil;
}
@end
