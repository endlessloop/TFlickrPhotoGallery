//
//  UIViewController+LoadingView.m
//
//  Created by Praveen
//  Copyright (c) 2013 Praveen. All rights reserved.
//

#import "UIViewController+LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@interface LoadingView : UIView

- (id)init;

@end

@implementation LoadingView

- (id)init {
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
		self.layer.cornerRadius = 5.0f;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicatorView.center = self.center;
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
	}
	return self;
}

@end

@implementation UIViewController (LoadingView)

#pragma mark - Private methods

- (LoadingView *)loadingView {
	LoadingView *loadingView = nil;
	for (UIView *subView in self.view.subviews) {
		if ([subView isKindOfClass:[LoadingView class]]) {
			loadingView = (LoadingView *)subView;
			break;
		}
	}
	return loadingView;
}

#pragma mark - Public methods

- (void)showLoadingView {
	LoadingView *loadingView = [self loadingView];
	
	if (loadingView == nil) {
		loadingView = [[LoadingView alloc] init];
		loadingView.center = self.view.center;
		
		self.view.userInteractionEnabled = NO;
		[self.view addSubview:loadingView];
	}
}

- (void)hideLoadingView {
	LoadingView *loadingView = [self loadingView];
	
	if (loadingView != nil) {
		[loadingView removeFromSuperview];
		
		self.view.userInteractionEnabled = YES;
	}
}

@end
