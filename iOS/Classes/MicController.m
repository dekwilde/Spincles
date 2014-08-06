#import "MicController.h"


static MicController *sharedListener = nil;


@implementation MicController


+ (MicController *)sharedListener {
	@synchronized(self) {
		if (sharedListener == nil)
			[[self alloc] init];
	}
	
	return sharedListener;
}

- (void)dealloc {
	//[sharedListener stop];
	//[levelTimer release];
	[recorder release];
    [super dealloc];
}

#pragma mark -
#pragma mark Listening

- (void)listen {
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord
     error: nil];
  
    
    
	
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
	
    //kAudioFormatAppleIMA4
    //kAudioFormatMPEG4AAC
    /*
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                     [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                     [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                     [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                     nil];
    */
    
	NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
                              /*
							  [NSNumber numberWithFloat: 44100.0],                  AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatMPEG4AAC],      AVFormatIDKey,
							  [NSNumber numberWithInt: 2],                          AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],          AVEncoderAudioQualityKey,
                              [NSNumber numberWithInt:16],                          AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO],                         AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool:NO],                         AVLinearPCMIsFloatKey,
							  nil];
                                */
	NSError *error;
	
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
		//levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
	} else {
		//NSLog([error description]);
    }
}
- (void)stop {
	[recorder release];
}

/*
- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
	
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
	
	//if (lowPassResults < 0.95)
	//NSLog(@"Mic blow detected");
	NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);

		
}
 */

#pragma mark -
#pragma mark Levels getters

- (Float32)averagePower {
	[recorder updateMeters];
	
	const double ALPHA = 0.7;
	double peakPowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	//return [recorder averagePowerForChannel:0];
	return lowPassResults;
	//NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);

}
- (Float32)peakPower {
	[recorder updateMeters];
	
	const double ALPHA = 0.7;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	//return [recorder peakPowerForChannel:0];
	return lowPassResults;
	//NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
	
}

#pragma mark -
#pragma mark Singleton Pattern

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedListener == nil) {
			sharedListener = [super allocWithZone:zone];
			return sharedListener;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)init {
	if ([super init] == nil)
		return nil;
	
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (void)release {
	// Do nothing.
}

- (id)autorelease {
	return self;
}


@end
