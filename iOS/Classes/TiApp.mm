/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#include <stdio.h>
#include <execinfo.h>

#import "TiApp.h"
#import "Webcolor.h"
#import "TiBase.h"
#import "TiErrorController.h"
#import "NSData+Additions.h"
#import "TiDebugger.h"
#import "ImageLoader.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

TiApp* sharedApp;

extern NSString * const TI_APPLICATION_DEPLOYTYPE;
extern NSString * const TI_APPLICATION_NAME;
extern NSString * const TI_APPLICATION_VERSION;

extern void UIColorFlushCache();

#define SHUTDOWN_TIMEOUT_IN_SEC	10
#define TIV @"TiVerify"

//
// thanks to: http://www.restoroot.com/Blog/2008/10/18/crash-reporter-for-iphone-applications/
//
void MyUncaughtExceptionHandler(NSException *exception) 
{
	static BOOL insideException = NO;
	
	// prevent recursive exceptions
	if (insideException==YES)
	{
		exit(1);
		return;
	}
	
	insideException = YES;
    NSArray *callStackArray = [exception callStackReturnAddresses];
    int frameCount = [callStackArray count];
    void *backtraceFrames[frameCount];
	
    for (int i=0; i<frameCount; i++) 
	{
        backtraceFrames[i] = (void *)[[callStackArray objectAtIndex:i] unsignedIntegerValue];
    }
	
	char **frameStrings = backtrace_symbols(&backtraceFrames[0], frameCount);
	
	NSMutableString *stack = [[NSMutableString alloc] init];
	
	[stack appendString:@"[ERROR] The application has crashed with an unhandled exception. Stack trace:\n\n"];
	
	if(frameStrings != NULL) 
	{
		for(int x = 0; x < frameCount; x++) 
		{
			if(frameStrings[x] == NULL) 
			{ 
				break; 
			}
			[stack appendFormat:@"%s\n",frameStrings[x]];
		}
		free(frameStrings);
	}
	[stack appendString:@"\n"];
    
	NSLog(@"%@",stack);
    
	[stack release];
	
	//TODO - attempt to report the exception
	insideException=NO;
}

@implementation TiApp

@synthesize window, remoteNotificationDelegate, controller;

+ (TiApp*)app
{
	return sharedApp;
}

-(void)changeNetworkStatus:(NSNumber*)yn
{
	ENSURE_UI_THREAD(changeNetworkStatus,yn);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = [TiUtils boolValue:yn];
}

-(void)startNetwork
{
	[networkActivity lock];
	networkActivityCount++;
	if (networkActivityCount==1)
	{
		[self changeNetworkStatus:[NSNumber numberWithBool:YES]];
	}
	[networkActivity unlock];
}

-(void)stopNetwork
{
	[networkActivity lock];
	networkActivityCount--;
	if (networkActivityCount==0)
	{
		[self changeNetworkStatus:[NSNumber numberWithBool:NO]];
	}
	[networkActivity unlock];
}

-(NSDictionary*)launchOptions
{
	return launchOptions;
}

- (UIImage*)loadAppropriateSplash
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if ([TiUtils isIPad]) {
		UIImage* image = nil;
		// Specific orientation check
		switch (orientation) {
			case UIDeviceOrientationPortrait:
				image = [UIImage imageNamed:@"Default-Portrait.png"];
				break;
			case UIDeviceOrientationPortraitUpsideDown:
				image = [UIImage imageNamed:@"Default-PortraitUpsideDown.png"];
				break;
			case UIDeviceOrientationLandscapeLeft:
				image = [UIImage imageNamed:@"Default-LandscapeLeft.png"];
				break;
			case UIDeviceOrientationLandscapeRight:
				image = [UIImage imageNamed:@"Default-LandscapeRight.png"];
				break;
		}
		if (image != nil) {
			return image;
		}
		
		// Generic orientation check
		if (UIDeviceOrientationIsPortrait(orientation)) {
			image = [UIImage imageNamed:@"Default-Portrait.png"];
		}
		else if (UIDeviceOrientationIsLandscape(orientation)) {
			image = [UIImage imageNamed:@"Default-Landscape.png"];
		}
		
		if (image != nil) {
			return image;
		}
	}
	
	// Default 
	return [UIImage imageNamed:@"Default.png"];
}

- (UIView*)attachSplash
{
	CGFloat splashY = -TI_STATUSBAR_HEIGHT;
	if ([[UIApplication sharedApplication] isStatusBarHidden])
	{
		splashY = 0;
	}
	RELEASE_TO_NIL(loadView);
	CGRect viewFrame = [[UIScreen mainScreen] bounds];
	BOOL flipLandscape = ([TiUtils isIPad] && UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]));
	loadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, splashY, 
															 flipLandscape ? viewFrame.size.height : viewFrame.size.width, 
															 flipLandscape ? viewFrame.size.width : viewFrame.size.height)];
	loadView.image = [self loadAppropriateSplash];
	[controller.view addSubview:loadView];
	splashAttached = YES;
	return loadView;
}

- (void)loadSplash
{
	sharedApp = self;
	networkActivity = [[NSLock alloc] init];
	networkActivityCount = 0;
	
	// attach our main view controller... IF we haven't already loaded the main window.
	if (!loaded) {
		[self attachSplash];
	}
	[window addSubview:controller.view];
    
    [window makeKeyAndVisible];
}

- (BOOL)isSplashVisible
{
	return splashAttached;
}

-(UIView*)splash
{
	return loadView;
}

- (void)hideSplash:(id)event
{
	// this is called when the first window is loaded
	// and should only be done once (obviously) - the
	// caller is responsible for setting up the animation
	// context before calling this and committing it afterwards
	if (loadView!=nil && splashAttached)
	{
		splashAttached = NO;
		loaded = YES;
		[loadView removeFromSuperview];
		RELEASE_TO_NIL(loadView);
	}
}

-(void)initController
{
	sharedApp = self;
	networkActivity = [[NSLock alloc] init];
	networkActivityCount = 0;
	
	// attach our main view controller
	controller = [[TiRootViewController alloc] init];
	
	// Force view load
	controller.view.backgroundColor = [UIColor clearColor];
	
	if (![TiUtils isiPhoneOS3_2OrGreater]) {
		[self loadSplash];
	}
}

-(void)attachXHRBridgeIfRequired
{
#ifdef USE_TI_UIWEBVIEW
	if (xhrBridge==nil)
	{
		xhrBridge = [[XHRBridge alloc] initWithHost:self];
		[xhrBridge boot:self url:nil preload:nil];
	}
#endif
}

- (void)boot
{
	//NSLog(@"[INFO] %@/%@ (%s.d1e8c8)",TI_APPLICATION_NAME,TI_APPLICATION_VERSION,TI_VERSION_STR);
	
	sessionId = [[TiUtils createUUID] retain];
    
#ifdef DEBUGGER_ENABLED
	[[TiDebugger sharedDebugger] start];
#endif
	
	kjsBridge = [[KrollBridge alloc] initWithHost:self];
	
	[kjsBridge boot:self url:nil preload:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	if ([TiUtils isIOS4OrGreater])
	{
		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	}
#endif
}

- (void)validator
{
	[[[NSClassFromString(TIV) alloc] init] autorelease];
}

- (void)booted:(id)bridge
{
	if ([bridge isKindOfClass:[KrollBridge class]])
	{
		//NSLog(@"[DEBUG] application booted in %f ms", ([NSDate timeIntervalSinceReferenceDate]-started) * 1000);
		fflush(stderr);
		[self performSelectorOnMainThread:@selector(validator) withObject:nil waitUntilDone:YES];
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	NSSetUncaughtExceptionHandler(&MyUncaughtExceptionHandler);
	[self initController];
	[self boot];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions_
{
	started = [NSDate timeIntervalSinceReferenceDate];
	NSSetUncaughtExceptionHandler(&MyUncaughtExceptionHandler);
    
	// nibless window
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
	[self initController];
    
	// get the current remote device UUID if we have one
	NSString *curKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"APNSRemoteDeviceUUID"];
	if (curKey!=nil)
	{
		remoteDeviceUUID = [curKey copy];
	}
    
	launchOptions = [[NSMutableDictionary alloc] initWithDictionary:launchOptions_];
	
	NSURL *urlOptions = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSString *sourceBundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
	NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	
	// reset these to be a little more common if we have them
	if (urlOptions!=nil)
	{
		[launchOptions setObject:[urlOptions absoluteString] forKey:@"url"];
		[launchOptions removeObjectForKey:UIApplicationLaunchOptionsURLKey];
	}
	if (sourceBundleId!=nil)
	{
		[launchOptions setObject:sourceBundleId forKey:@"source"];
		[launchOptions removeObjectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
	}
	if (notification!=nil)
	{
		remoteNotification = [[notification objectForKey:@"aps"] retain];
	}
	
	[self boot];
	
	return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	[launchOptions removeObjectForKey:UIApplicationLaunchOptionsURLKey];	
	[launchOptions setObject:[url absoluteString] forKey:@"url"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSNotificationCenter * theNotificationCenter = [NSNotificationCenter defaultCenter];
    
	//This will send out the 'close' message.
	[theNotificationCenter postNotificationName:kTiWillShutdownNotification object:self];
	
	NSCondition *condition = [[NSCondition alloc] init];
    
#ifdef USE_TI_UIWEBVIEW
	[xhrBridge shutdown:nil];
#endif	
    
	//These shutdowns return immediately, yes, but the main will still run the close that's in their queue.	
	[kjsBridge shutdown:condition];
	
	[condition lock];
	[condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:SHUTDOWN_TIMEOUT_IN_SEC]];
	[condition unlock];
	
	//This will shut down the modules.
	[theNotificationCenter postNotificationName:kTiShutdownNotification object:self];
	
	RELEASE_TO_NIL(condition);
	RELEASE_TO_NIL(kjsBridge);
#ifdef USE_TI_UIWEBVIEW 
	RELEASE_TO_NIL(xhrBridge);
#endif	
	RELEASE_TO_NIL(remoteNotification);
	RELEASE_TO_NIL(sessionId);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[Webcolor flushCache];
	// don't worry about KrollBridge since he's already listening
#ifdef USE_TI_UIWEBVIEW
	[xhrBridge gc];
#endif 
}

-(void)applicationWillResignActive:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kTiSuspendNotification object:self];
	
	// suspend any image loading
	[[ImageLoader sharedLoader] suspend];
	
	[kjsBridge gc];
	
#ifdef USE_TI_UIWEBVIEW
	[xhrBridge gc];
#endif 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// you can get a resign when you have to show a system dialog or you get
	// an incoming call, for example, and then you'll get this message afterwards
	// this is slightly different than enter foreground
	[[NSNotificationCenter defaultCenter] postNotificationName:kTiResumeNotification object:self];
	
	// resume any image loading
	[[ImageLoader sharedLoader] resume];
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
	[TiUtils queueAnalytics:@"ti.background" name:@"ti.background" data:nil];
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kTiResumeNotification object:self];
	[TiUtils queueAnalytics:@"ti.foreground" name:@"ti.foreground" data:nil];
}

-(id)remoteNotification
{
	return remoteNotification;
}

#pragma mark Push Notification Delegates

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	// NOTE: this is called when the app is *running* after receiving a push notification
	// otherwise, if the app is started from a push notification, this method will not be 
	// called
	RELEASE_TO_NIL(remoteNotification);
	remoteNotification = [[userInfo objectForKey:@"aps"] retain];
	
	if (remoteNotificationDelegate!=nil)
	{
		[remoteNotificationDelegate performSelector:@selector(application:didReceiveRemoteNotification:) withObject:application withObject:remoteNotification];
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{ 
	NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] 
						stringByReplacingOccurrencesOfString:@">" withString:@""] 
					   stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	RELEASE_TO_NIL(remoteDeviceUUID);
	remoteDeviceUUID = [token copy];
	
	NSString *curKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"APNSRemoteDeviceUUID"];
	if (curKey==nil || ![curKey isEqualToString:remoteDeviceUUID])
	{
		// this is the first time being registered, we need to indicate to our backend that we have a 
		// new registered device to enable this device to receive notifications from the cloud
		[[NSUserDefaults standardUserDefaults] setObject:remoteDeviceUUID forKey:@"APNSRemoteDeviceUUID"];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:remoteDeviceUUID forKey:@"deviceid"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTiRemoteDeviceUUIDNotification object:self userInfo:userInfo];
		//NSLog(@"[DEBUG] registered new device ready for remote push notifications: %@",remoteDeviceUUID);
	}
	
	if (remoteNotificationDelegate!=nil)
	{
		[remoteNotificationDelegate performSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:) withObject:application withObject:deviceToken];
	}
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	if (remoteNotificationDelegate!=nil)
	{
		[remoteNotificationDelegate performSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:) withObject:application withObject:error];
	}
}

//TODO: this should be compiled out in production mode
-(void)showModalError:(NSString*)message
{
	if ([TI_APPLICATION_DEPLOYTYPE isEqualToString:@"production"])
	{
		NSLog(@"[ERROR] application received error: %@",message);
		return;
	}
	ENSURE_UI_THREAD(showModalError,message);
	TiErrorController *error = [[[TiErrorController alloc] initWithError:message] autorelease];
	[controller presentModalViewController:error animated:YES];
}

-(void)attachModal:(UIViewController*)modalController toController:(UIViewController*)presentingController animated:(BOOL)animated
{
	UIViewController * currentModalController = [presentingController modalViewController];
    
	if (currentModalController == modalController)
	{
		NSLog(@"[WARN] Trying to present a modal window that already is a modal window.");
		return;
	}
	if (currentModalController == nil)
	{
		[presentingController presentModalViewController:modalController animated:animated];
		return;
	}
	[self attachModal:modalController toController:currentModalController animated:animated];
}

-(void)showModalController:(UIViewController*)modalController animated:(BOOL)animated
{
	UINavigationController *navController = nil; //[(TiRootViewController *)controller focusedViewController];
	if (navController==nil)
	{
		navController = [controller navigationController];
	}
	// if we have a nav controller, use him, otherwise use our root controller
	[controller windowFocused:modalController];
	if (navController!=nil)
	{
		[self attachModal:modalController toController:navController animated:animated];
	}
	else
	{
		[self attachModal:modalController toController:controller animated:animated];
	}
}

-(void)hideModalController:(UIViewController*)modalController animated:(BOOL)animated
{
	UIViewController *navController = [modalController parentViewController];
	if (navController==nil)
	{
        //		navController = [controller currentNavController];
	}
	[controller windowClosed:modalController];
	if (navController!=nil)
	{
		[navController dismissModalViewControllerAnimated:animated];
	}
	else 
	{
		[controller dismissModalViewControllerAnimated:animated];
	}
}


- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	RELEASE_TO_NIL(kjsBridge);
#ifdef USE_TI_UIWEBVIEW
	RELEASE_TO_NIL(xhrBridge);
#endif	
	RELEASE_TO_NIL(loadView);
	RELEASE_TO_NIL(window);
	RELEASE_TO_NIL(launchOptions);
	RELEASE_TO_NIL(controller);
	RELEASE_TO_NIL(networkActivity);
	RELEASE_TO_NIL(userAgent);
	RELEASE_TO_NIL(remoteDeviceUUID);
	RELEASE_TO_NIL(remoteNotification);
#ifdef DEBUGGER_ENABLED
	[[TiDebugger sharedDebugger] stop];
#endif
	[super dealloc];
}

- (NSString*)userAgent
{
	if (userAgent==nil)
	{
		UIDevice *currentDevice = [UIDevice currentDevice];
		NSString *currentLocaleIdentifier = [[NSLocale currentLocale] localeIdentifier];
		NSString *currentDeviceInfo = [NSString stringWithFormat:@"%@/%@; %@; %@;",[currentDevice model],[currentDevice systemVersion],[currentDevice systemName],currentLocaleIdentifier];
		NSString *ktest3UserAgentPrefix = [NSString stringWithFormat:@"%s%s%s %s%s","Appc","eler","ator","Tita","nium"];
		userAgent = [[NSString stringWithFormat:@"%@/%s (%@)",ktest3UserAgentPrefix,TI_VERSION_STR,currentDeviceInfo] retain];
	}
	return userAgent;
}

-(BOOL)isKeyboardShowing
{
	return keyboardShowing;
}

-(NSString*)remoteDeviceUUID
{
	return remoteDeviceUUID;
}

-(NSString*)sessionId
{
	return sessionId;
}

#pragma mark Keyboard Delegates

- (void)keyboardDidHide:(NSNotification*)notification 
{
	keyboardShowing = NO;
}

- (void)keyboardDidShow:(NSNotification*)notification
{
	keyboardShowing = YES;
}

-(KrollBridge*)krollBridge
{
	return kjsBridge;
}

@end
