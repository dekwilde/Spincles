//
//  MicController.h
//  Mic
//
//  Created by DekWilde on 10/26/11.
//  Copyright 2011 DekWilde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface MicController : NSObject {
	AVAudioRecorder *recorder;
	//NSTimer *levelTimer;
	double lowPassResults;	
}

+ (MicController *)sharedListener;
- (void)listen;
- (void)stop;
//- (void)levelTimerCallback:(NSTimer *)timer;
- (Float32)averagePower;
- (Float32)peakPower;
@end

