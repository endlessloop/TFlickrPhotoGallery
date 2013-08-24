//
//  TAppDelegate.h
//  TFlickr
//
//  Created by Praveen on 8/24/13.
//  Copyright (c) 2013 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFlickrAlbumsViewController.h"

@interface TAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TFlickrAlbumsViewController *flickrAlbumsViewController;

@end
