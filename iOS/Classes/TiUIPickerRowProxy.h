/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#ifdef USE_TI_UIPICKER

#import "TiViewProxy.h"

@interface TiUIPickerRowProxy : TiViewProxy 
{
@private
    UIImage* snapshot;
}

-(UIView*)viewWithFrame:(CGRect)theFrame reusingView:(UIView*)theView;

@end

#endif