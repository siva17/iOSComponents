//
//  Loading.m
//  LoadingIndicator
//
//  Created by Siva RamaKrishna Ravuri
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "Loading.h"

#define DEFAULT_TIMEOUT_INTERVAL	30.0f
#define DEFAULT_LOADING_TEXT		@"Loading"

@interface Loading ()
@property(nonatomic,retain) MBProgressHUD	*loadingIndicator;
@property(nonatomic,retain) UIView			*parentView;
@end

@implementation Loading

@synthesize loadingIndicator;
@synthesize parentView;

#pragma mark - De-Allocs

-(void) initialize {
    RELEASE_MEM(loadingIndicator);
    RELEASE_MEM(parentView);
}

-(void) dealloc {
    [self initialize];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

-(void) releaseLoadingIndicator {
    if (loadingIndicator) {
        [loadingIndicator removeFromSuperview];
        RELEASE_MEM(loadingIndicator);
    }
}

- (void) myTask {
	sleep(DEFAULT_TIMEOUT_INTERVAL);
}

#pragma mark - Loading APIs

-(id) initWithParentView: (UIView *)view {
    self = [super init];
    if(self) {
        [self initialize];
        self.parentView = view;
    }
    return self;
}

-(void) showLoading {
    [self showLoadingWithText:DEFAULT_LOADING_TEXT];
}

-(void) showLoadingWithText:(NSString *)loadingText {
    [self releaseLoadingIndicator];
    loadingIndicator             = [[MBProgressHUD alloc] initWithView:parentView];
    loadingIndicator.minShowTime = DEFAULT_TIMEOUT_INTERVAL;
    loadingIndicator.delegate    = self;
    loadingIndicator.labelText   = loadingText;
    loadingIndicator.backgroundColor = DEFAULT_THEME_COLOR_ALPHA(0.2);
    loadingIndicator.color = DEFAULT_THEME_COLOR_ALPHA(1);
    [parentView addSubview:loadingIndicator];
    [loadingIndicator showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

-(void) hideLoading {
    [loadingIndicator setHidden:YES];
}

#pragma MBProgressHUD delegate methods
-(void) hudWasHidden:(MBProgressHUD *)hud {
    [self releaseLoadingIndicator];
}

@end
