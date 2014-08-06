
// original via github.com/mikefogg/SquareCamera

// Modifications / Attempts to fix using ramdom bit of code found here and there : Kosso : August 2013

#import "ComMfoggSquarecameraView.h"
#import "ComMfoggSquarecameraViewProxy.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <CoreMedia/CoreMedia.h>


@implementation ComMfoggSquarecameraView

// Further reading. 
// http://developer.appcelerator.com/question/154132/titanium-custom-camera-module-iphone#comment-185903


@synthesize captureSession = _captureSession;
@synthesize prevLayer = _prevLayer;
@synthesize stillImageOutput = _stillImageOutput;
@synthesize stillImage = _stillImage;
@synthesize captureDevice = _captureDevice;
@synthesize flashOn = _flashOn;
@synthesize isUsingFrontFacingCamera = _isUsingFrontFacingCamera;

  /// used for KVO observation of the @"capturingStillImage" property to perform flash bulb animation
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";


- (void) dealloc
{
    [self teardownAVCapture];

    self.prevLayer = nil;
    self.stillImage = nil;
    self.stillImageOutput = nil;
    self.captureDevice = nil;
    
    RELEASE_TO_NIL(square);
        
    [super dealloc];
}

-(void)initializeState
{
    [super initializeState];
    
    self.prevLayer = nil;
    self.stillImage = nil;
    self.stillImageOutput = nil;
    self.captureDevice = nil;
    self.isUsingFrontFacingCamera = NO;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    // This is initializing the square view
    [TiUtils setView:self.square positionRect:bounds];
}

- (void)turnFlashOn:(id)args
{
    if([self.captureDevice lockForConfiguration:true]){
        [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
        [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
        self.flashOn = YES;  
        [self.captureDevice lockForConfiguration:false];
        
        [self.proxy fireEvent:@"onFlashOn"];
    };
};

- (void)turnFlashOff:(id)args
{
    if([self.captureDevice lockForConfiguration:true]){
        [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
        [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
        self.flashOn = NO;  
        [self.captureDevice lockForConfiguration:false];
        
        [self.proxy fireEvent:@"onFlashOff"];
    };
};

// utility routine to display error aleart if takePicture fails
- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Dismiss" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}





-(void)switchCamera:(id)args
{
    AVCaptureDevicePosition desiredPosition;
    if (self.isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
    }
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [[self.prevLayer session] beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[self.prevLayer session] inputs]) {
                [[self.prevLayer session] removeInput:oldInput];
            }
            [[self.prevLayer session] addInput:input];
            [[self.prevLayer session] commitConfiguration];
            break;
        }
    }
    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;
    
    [self.proxy fireEvent:@"onSwitchCamera"];
}




- (void)takePhoto:(id)args
{

    NSLog(@"[INFO] takePhoto ... ");

    AVCaptureConnection *stillImageConnection = nil;
        
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				stillImageConnection = connection;
				break;
			}
		}
		if (stillImageConnection) { break; }
	}

    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    //AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    //[stillImageConnection setVideoOrientation:avcaptureOrientation];
    // [stillImageConnection setVideoScaleAndCropFactor:effectiveScale]; // leftover from 'pinchzoom' in iOSDL demo? 
  

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
        { 

            // Not using these yet, but interesting nonetheless.
            // Could send them back with the event, for extra pudding.
            /*
            CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
                NSLog(@"[INFO] imageSampleBuffer Exif attachments: %@", exifAttachments);
            } else { 
                NSLog(@"[INFO] No imageSampleBuffer Exif attachments");
            }
             */


            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];    

            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            CGSize size = image.size;  // this will be the full size of the screen 

            NSLog(@"image.size : %@", NSStringFromCGSize(size));

            CGFloat image_width = image.size.width;
            CGFloat image_height = image.size.height;

            CGFloat image_square_wh = image_width;
            if(image_height < image_width){
                image_square_wh = image_height;
            }
            // Let's try this... make the crop from the image size dimensions, not the UIView square
            CGRect cropRect = CGRectMake(
                    0,
                    0,
                    image_square_wh,
                    image_square_wh
                );

            //CGRect cropRect = self.stillImage.frame; //  (the size of the square)
            


            NSLog(@"cropRect : %@", NSStringFromCGRect(cropRect));


            CGRect customImageRect = CGRectMake(
                                                -((((cropRect.size.width/size.width)*size.height)-cropRect.size.height)/2),
                                                0,
                                                ((cropRect.size.width/size.width)*size.height),
                                                cropRect.size.width);
            
            UIGraphicsBeginImageContext(cropRect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();  
            
            CGContextScaleCTM(context, 1.0, -1.0);  
            CGContextRotateCTM(context, -M_PI/2);  
            
            if(self.isUsingFrontFacingCamera){

                //NSLog(@"[INFO] FRONT CAMERA!");

               // CGContextScaleCTM(context, 1.0, -1.0);
            }
            
            CGContextDrawImage(context, customImageRect,
                               image.CGImage);
            
            UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();  
            UIGraphicsEndImageContext();
            
            // don't set the viewer to the new photo! 
            //self.stillImage.image = croppedImage;
            
            
            TiBlob *imageBlob = [[TiBlob alloc] initWithImage:croppedImage]; // maybe try image here 
            NSDictionary *event = [NSDictionary dictionaryWithObject:imageBlob forKey:@"media"];
            
            // HURRAH! 
            [self.proxy fireEvent:@"success" withObject:event];


           // [imageBlob release];
           // [image release];
           // [croppedImage release];
            
            // keep it running for now - since we didn't replace it with an image
            // [self.captureSession stopRunning];
  
            // what are we doing with the potential error value? 
            // proably should be sending an event if it's not nil... or something. 


     }];
}



- (void)takeCamera:(id)args
{
    NSLog(@"[INFO] takeCamera ... ");
    
    AVCaptureConnection *stillImageConnection = nil;
    
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				stillImageConnection = connection;
				break;
			}
		}
		if (stillImageConnection) { break; }
	}
    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];    
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         
         CGSize size = image.size;  // this will be the full size of the screen
         
         //CGRect cropRect = self.stillImage.frame; //  (the size of the square)
         CGRect cropRect = CGRectMake(
                                      0,
                                      0,
                                      36,
                                      58
                                      );
         
         CGRect customImageRect = CGRectMake(
                                             -((((cropRect.size.width/size.width)*size.height)-cropRect.size.height)/2),
                                             0,
                                             ((cropRect.size.width/size.width)*size.height),
                                             cropRect.size.width);
         
         UIGraphicsBeginImageContext(cropRect.size);
         CGContextRef context = UIGraphicsGetCurrentContext();
         
         CGContextScaleCTM(context, 1.0, -1.0);
         CGContextRotateCTM(context, -M_PI/2);
         CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
         CGContextFillRect(context, self.frame);
         //CGContextSetAlpha(context, 0.0);
         
         
         CGContextDrawImage(context, customImageRect,
                            image.CGImage);
         
         UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         
         
         
         TiBlob *imageBlob = [[TiBlob alloc] initWithImage:croppedImage]; // maybe try image here
         
         NSDictionary *event = [NSDictionary dictionaryWithObject:imageBlob forKey:@"media"];
         
         // HURRAH!
         [self.proxy fireEvent:@"success" withObject:event];
         
         
         // [imageBlob release];
         // [image release];
         // [croppedImage release];
         
         // keep it running for now - since we didn't replace it with an image
         // [self.captureSession stopRunning];
         
         // what are we doing with the potential error value?
         // proably should be sending an event if it's not nil... or something.
         
         
     }];
    
}







#pragma mark -
#pragma mark AVCaptureSession delegate
// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"[INFO] captureOutPut ... ");

    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];

    
    CGSize size = image.size;  // this will be the full size of the screen
    
    //CGRect cropRect = self.stillImage.frame; //  (the size of the square)
    CGRect cropRect = CGRectMake(
                                 0,
                                 0,
                                 36,
                                 48
                                 );
    
    CGRect customImageRect = CGRectMake(
                                        -((((cropRect.size.width/size.width)*size.height)-cropRect.size.height)/2),
                                        0,
                                        ((cropRect.size.width/size.width)*size.height),
                                        cropRect.size.width);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, -M_PI/2);
    //CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    //CGContextFillRect(context, self.frame);
    //CGContextSetAlpha(context, 0.0);
    
    
    CGContextDrawImage(context, customImageRect,
                       image.CGImage);
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    
    TiBlob *imageBlob = [[TiBlob alloc] initWithImage:croppedImage]; // maybe try image here
    
    NSDictionary *event = [NSDictionary dictionaryWithObject:imageBlob forKey:@"media"];
    
    // HURRAH!
    [self.proxy fireEvent:@"success" withObject:event];
    
    
    
    
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    UIImage *image =  [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}




-(UIView*)square
{   
    if (square == nil) {
        
        square = [[UIView alloc] initWithFrame:[self frame]];
        [self addSubview:square]; 
        


        self.stillImage = [[UIImageView alloc] init];
        self.stillImage.frame = [square bounds];
        [self addSubview:self.stillImage];


        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // If camera is avaialble
        


            self.captureSession = [[AVCaptureSession alloc] init];


            self.captureSession.sessionPreset = AVCaptureSessionPresetLow;

 

            self.prevLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
            self.prevLayer.frame = self.square.bounds;
            self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.square.layer addSublayer:self.prevLayer];
            

            self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

            if([self.captureDevice lockForConfiguration:true]){
                [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
                self.flashOn = NO;  
                [self.captureDevice lockForConfiguration:false];
            };
            

            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
            if (!input) {
                // Handle the error appropriately.
                NSLog(@"ERROR: trying to open camera: %@", error);
            }

            AVCaptureVideoDataOutput *videoDataOutput = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
            [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
            // Now do the dispatch queue .. 
            //dispatch_queue_t videoDataOutputQueue;
            dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("MyvideoDataOutputQueue", NULL);
            [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
            dispatch_release(videoDataOutputQueue);
            /////////////////////////////////////////////////////////////
            // OUTPUT #1: Still Image
            /////////////////////////////////////////////////////////////
            // Add an output object to our session so we can get a still image
            // We retain a handle to the still image output and use this when we capture an image.
            self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];

            // https://developer.apple.com/library/ios/samplecode/SquareCam/Listings/SquareCam_SquareCamViewController_m.html#//apple_ref/doc/uid/DTS40011190-SquareCam_SquareCamViewController_m-DontLinkElementID_7
            // see KVO note above
            //[self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:AVCaptureStillImageIsCapturingStillImageContext];


            NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
            [self.stillImageOutput setOutputSettings:outputSettings];

            [self.captureSession addInput:input];
            [self.captureSession addOutput:self.stillImageOutput];
            
            [outputSettings release];


            // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
            NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
            [videoDataOutput setVideoSettings:rgbOutputSettings];

           

            // # commenting out to see if we need to do this : (maybe for older devices) 
            //videoDataOutput.minFrameDuration = CMTimeMake(1, 15);

 
            [self.captureSession addOutput:videoDataOutput];

            [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];

            // and off we go! ... 
            [self.captureSession startRunning];
            
            // uh oh ... 
            bail:
                [self.captureSession release];
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                                        message:[error localizedDescription]
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"oh dear" 
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                    [self teardownAVCapture];
                }


            
        } else {
            // If camera is NOT avaialble
            [self.proxy fireEvent:@"noCamera"];
        }        
        /////////////////////////////////////////////////////////////////////////////
    }
    
    return square;
}


- (void)teardownAVCapture
{

    NSLog(@"[INFO] TEAR DOWN CAPTURE");

    [self.captureSession stopRunning];

    [_videoDataOutput release];
    if (videoDataOutputQueue)
        dispatch_release(videoDataOutputQueue);
    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage"];
    [self.stillImageOutput release];
    [self.prevLayer removeFromSuperlayer];
    [self.prevLayer release];
}


// perform a flash bulb animation using KVO to monitor the value of the capturingStillImage property of the AVCaptureStillImageOutput class
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == AVCaptureStillImageIsCapturingStillImageContext ) {
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if ( isCapturingStillImage ) {
            // do flash bulb like animation
            flashView = [[UIView alloc] initWithFrame:[self.stillImage frame]];
            [flashView setBackgroundColor:[UIColor whiteColor]];
            [flashView setAlpha:0.f];

            [self addSubview:flashView];
            // fade it in            
            [UIView animateWithDuration:.3f
                             animations:^{
                                 [flashView setAlpha:1.f];
                             }
             ];
        }
        else {
            // fade it out
            [UIView animateWithDuration:.3f
                            animations:^{
                                [flashView setAlpha:0.f];
                            }
                            completion:^(BOOL finished){
                                // get rid of it
                                [flashView removeFromSuperview];
                                [flashView release];
                                flashView = nil;
                            }
             ];
        }
    }
}


// utility routing used during image capture to set up capture orientation
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}


@end
