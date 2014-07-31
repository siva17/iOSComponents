//
//  Accordion.h
//  Accordion
//
//  Created by Siva Rama Krishna Ravuri
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
// Original version is from below author
/*
 AccordionView.h
 
 Created by Wojtek Siudzinski on 19.12.2011.
 Copyright (c) 2011 Appsome. All rights reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
//
#import <UIKit/UIKit.h>
#import "AccordionHeaderView.h"

#define ACCORDION_NO_HEADING	@""

@class Accordion;
@protocol AccordionDelegate <NSObject>
-(void)accordion:(Accordion *)accordion currentIndex:(NSInteger)currentIndex previousIndex:(NSInteger)previousIndex;
-(void)accordion:(Accordion *)accordion layoutSubviewsWithTotalHeight:(CGFloat)height;
@end

@interface Accordion : UIView <UIScrollViewDelegate>

@property(nonatomic,assign) BOOL					allowsMultipleSelection;
@property(nonatomic,assign) BOOL					allowsEmptySelection;
@property(nonatomic,assign) BOOL					startsWithCloseView;
@property(nonatomic,assign) NSTimeInterval			animationDuration;
@property(nonatomic,assign) UIViewAnimationCurve	animationCurve;
@property(nonatomic,readonly) CGFloat				totalHeight;

-(id)initWithFrame:(CGRect)frame delegate:(id<AccordionDelegate>)aDelegate;
-(id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView delegate:(id<AccordionDelegate>)aDelegate;
-(void)addHeader:(id)aHeader withView:(id)aView textFont:(UIFont *)textFont;

@end
