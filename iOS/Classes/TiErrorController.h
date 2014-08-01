/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

@interface TiErrorController : UIViewController {
	
	NSString *error;
    UILabel *disclosureLabel;
    UILabel *messageLabel;
    UIButton *dismissButton;
    UIView *centerView;
    UILabel *titleLabel;
}

-(id)initWithError:(NSString*)error_;

@end
