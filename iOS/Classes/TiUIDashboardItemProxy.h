/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#ifdef USE_TI_UIDASHBOARDVIEW

#import "TiViewProxy.h"
#import "LauncherItem.h"

@interface TiUIDashboardItemProxy : TiViewProxy {
@private
	LauncherItem *item;
}

@property(nonatomic,readwrite,retain) LauncherItem *item;

@end

#endif