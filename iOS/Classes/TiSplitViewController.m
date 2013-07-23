/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiBase.h"


#ifdef USE_TI_UIIPADSPLITWINDOW

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2

#import "TiSplitViewController.h"
#import "TiViewProxy.h"
#import "TiUIiPhoneNavigationGroupProxy.h"
#import <MessageUI/MessageUI.h>

@implementation TiSplitViewController
@synthesize proxy, master, detail;

-(id)initWithRootController:(TiRootViewController *)rootController 
				masterProxy:(TiViewProxy*)master_ 
				detailProxy:(TiViewProxy*)detail_ 
				 splitProxy:(TiUIiPadSplitWindowProxy*)split_
{
	if (self = [super init]) {
		_test3Root = [rootController retain];
		proxy = split_;
		
		// In order for the split view to render correctly, we have to enforce the window's orientation modes
		// before setting up the view controllers.  Very finnicky about when the containing mystery views
		// are positioned!
		//lastOrientation = [[UIDevice currentDevice] orientation];
		[self enforceOrientationModesFromWindow:(TiWindowProxy*)split_ rotate:YES];
		
		// Split view throws a hissyfit unless its detail and master are nav groups, apparently!
		UINavigationController* leftNav;
		UINavigationController* rightNav;

		// Quick hack; OK to do this even if we're stashing nav group proxies, because we're just
		// using these to resposition (and create the nav controller if necessary)
		master = [[TiViewController alloc] initWithViewProxy:master_];
		detail = [[TiViewController alloc] initWithViewProxy:detail_];
		
		if ([master_ isKindOfClass:[TiUIiPhoneNavigationGroupProxy class]]) {
			leftNav = [[(TiUIiPhoneNavigationGroupProxy*)master_ controller] retain];
		}
		else {
			leftNav = [[UINavigationController alloc] initWithRootViewController:master];		
			leftNav.navigationBarHidden = YES;
		}
		
		if ([detail_ isKindOfClass:[TiUIiPhoneNavigationGroupProxy class]]) {
			rightNav = [[(TiUIiPhoneNavigationGroupProxy*)detail_ controller] retain];
		}
		else {
			rightNav = [[UINavigationController alloc] initWithRootViewController:detail];
			rightNav.navigationBarHidden = YES;  
		}
		
		self.viewControllers = [NSArray arrayWithObjects:leftNav, rightNav ,nil];

		[leftNav release];
		[rightNav release];
	}
	return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(_test3Root);
	RELEASE_TO_NIL(master);
	RELEASE_TO_NIL(detail);
	[super dealloc];
}

-(CGRect)resizeView
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	[[self view] setFrame:rect];
	VerboseLog(@"(%f,%f),(%fx%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
	//Because of the transition in landscape orientation, TiUtils can't be used here... SetFrame compensates for it.
	return rect;
}

-(void)loadView
{
	[[NSNotificationCenter defaultCenter] removeObserver:_test3Root name:UIDeviceOrientationDidChangeNotification object:nil];
	[super loadView];
}

-(void)repositionSubviews
{
	[[master proxy] reposition];
	[[detail proxy] reposition];
}

-(void)manuallyRotateToOrientation:(UIInterfaceOrientation)newOrientation duration:(NSTimeInterval)duration
{
	UIApplication * ourApp = [UIApplication sharedApplication];
	if (newOrientation != [ourApp statusBarOrientation])
	{
		[ourApp setStatusBarOrientation:newOrientation animated:YES];
	}
	
	// if already in the orientation, don't do it again
	if (lastOrientation==newOrientation)
	{
		return;
	}
	
	CGAffineTransform transform;
	
	switch (newOrientation)
	{
		case UIInterfaceOrientationPortraitUpsideDown:
			transform = CGAffineTransformMakeRotation(M_PI);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			transform = CGAffineTransformMakeRotation(-M_PI_2);
			break;
		case UIInterfaceOrientationLandscapeRight:
			transform = CGAffineTransformMakeRotation(M_PI_2);
			break;
		default:
			transform = CGAffineTransformIdentity;
			break;
	}
	
	if (duration > 0.0)
	{
		[UIView beginAnimations:@"orientation" context:nil];
		[UIView setAnimationDuration:duration];
	}
	
	[[self view] setTransform:transform];
	[self resizeView];
	
	//Propigate this to everyone else. This has to be done INSIDE the animation.
	[self repositionSubviews];
	
	if (duration > 0.0)
	{
		[UIView commitAnimations];
	}
	lastOrientation = newOrientation;
}

-(void)manuallyRotateToOrientation:(UIInterfaceOrientation) newOrientation
{
	[self manuallyRotateToOrientation:newOrientation duration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
}

-(void)setOrientationModes:(NSArray *)newOrientationModes
{
	for (int i=0; i<MAX_ORIENTATIONS; i++)
	{
		allowedOrientations[i] = NO;
	}
	
	BOOL noOrientations = YES;
	if (newOrientationModes != nil && ![newOrientationModes isKindOfClass:[NSNull class]]) {
		for (id mode in newOrientationModes)
		{
			UIInterfaceOrientation orientation = [TiUtils orientationValue:mode def:-1];
			switch (orientation)
			{
				case UIDeviceOrientationPortrait:
				case UIDeviceOrientationPortraitUpsideDown:
				case UIDeviceOrientationLandscapeLeft:
				case UIDeviceOrientationLandscapeRight:
					allowedOrientations[orientation] = YES;
					noOrientations = NO;
					break;
				case -1:
					break;
				default:
					NSLog(@"[WARN] An invalid orientation was requested. Ignoring.");
					break;
			}
		}
	}
	
	if (noOrientations)
	{
		allowedOrientations[UIInterfaceOrientationPortrait] = YES;
		if ([TiUtils isIPad])
		{
			allowedOrientations[UIInterfaceOrientationPortraitUpsideDown] = YES;
			allowedOrientations[UIInterfaceOrientationLandscapeLeft] = YES;
			allowedOrientations[UIInterfaceOrientationLandscapeRight] = YES;
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	orientationRequestTimes[interfaceOrientation] = [NSDate timeIntervalSinceReferenceDate];
	return allowedOrientations[interfaceOrientation];
}

-(void)refreshOrientationModesIfNeeded:(TiWindowProxy *)oldCurrentWindow
{
	[_test3Root refreshOrientationModesIfNeeded:oldCurrentWindow];
}

-(void)enforceOrientationModesFromWindow:(TiWindowProxy *) newCurrentWindow rotate:(BOOL)yn
{	
	Class arrayClass = [NSArray class];
	Class windowClass = [TiWindowProxy class];
	SEL proxySel = @selector(proxy);
	
	NSArray * candidateOrientationModes = [newCurrentWindow valueForKey:@"orientationModes"];

	[self setOrientationModes:candidateOrientationModes];

	if (yn) {
		UIInterfaceOrientation requestedOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		NSTimeInterval latestRequest = 0.0;
		for (int i=0; i<MAX_ORIENTATIONS; i++)
		{
			if (allowedOrientations[i] && (orientationRequestTimes[i]>latestRequest))
			{
				requestedOrientation = i;
				latestRequest = orientationRequestTimes[i];
			}
		}
		[self manuallyRotateToOrientation:requestedOrientation duration:0.0];
	}
}

-(void)windowFocused:(UIViewController*)focusedViewController
{
	if ([focusedViewController isKindOfClass:[UINavigationController class]] && ![focusedViewController isKindOfClass:[MFMailComposeViewController class]])
	{
		UIViewController * topViewController = [(UINavigationController *)focusedViewController topViewController];
		if (topViewController != nil)
		{
			focusedViewController = topViewController;
		}
	}
	
	TiWindowProxy * focusedProxy = nil;
	if ([focusedViewController respondsToSelector:@selector(proxy)])
	{
		focusedProxy = (TiWindowProxy *)[(id)focusedViewController proxy];
	}
	
	[self enforceOrientationModesFromWindow:(id)focusedProxy rotate:YES];	
}

-(void)windowClosed:(UIViewController *)closedViewController
{
	// No-op on split views
}

-(void)setBackgroundImage:(UIImage*)image
{
	// No-op on split views
}

-(void)setBackgroundColor:(UIColor*)color
{
	// No-op on split view
}

@end
#endif
#endif
