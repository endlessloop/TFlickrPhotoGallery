//
//  UIViewController+LoadingView.h
//
//  Created by Praveen
//  Copyright (c) 2013 Praveen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingView;

@interface UIViewController (LoadingView)

- (LoadingView *)loadingView;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
