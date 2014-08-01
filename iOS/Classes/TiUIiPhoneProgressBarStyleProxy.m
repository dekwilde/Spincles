/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#ifdef USE_TI_UIIPHONEPROGRESSBARSTYLE

#import "TiUIiPhoneProgressBarStyleProxy.h"


@implementation TiUIiPhoneProgressBarStyleProxy

-(NSString*)apiName
{
    return @"Ti.UI.iPhone.ProgressBarStyle";
}

MAKE_SYSTEM_PROP(PLAIN,UIProgressViewStyleDefault);
MAKE_SYSTEM_PROP(DEFAULT,UIProgressViewStyleDefault);
MAKE_SYSTEM_PROP(BAR,UIProgressViewStyleBar);

@end

#endif