#import <Foundation/Foundation.h>

@interface Recorder : NSObject {
	NSMutableArray* eventList;
	id playbackDelegate;
	SEL playbackDoneSelector;
    BOOL _isRecording;
}
@property (nonatomic, readonly) BOOL isRecording;
+(Recorder *)sharedRecorder;
-(void)record;
-(void)saveToFile:(NSString*)path;
-(NSArray*)events;
-(void)load:(NSArray*)events;
-(void)loadFromFile:(NSString*)path;
-(void)playbackWithDelegate:(id)delegate doneSelector:(SEL)selector;
-(void)stop;

@end
