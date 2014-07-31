//
//  Accordion.m
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

#import "Accordion.h"

#define ACCORDION_IPHONE_WIDTH			(320)
#define ACCORDION_IPHONE_TEXT_PADDING	(10)

@interface Accordion()

@property(nonatomic,assign) id						<AccordionDelegate> delegate;
@property(nonatomic,assign) NSInteger				prevSelectedItem;
@property(nonatomic,assign) NSInteger				currentSelectedItem;
@property(nonatomic,assign) NSInteger				selectedIndex;
@property(nonatomic,strong) NSIndexSet				*selectionIndexes;
@property(nonatomic,retain) NSMutableArray			*accordionViews;
@property(nonatomic,retain) NSMutableArray			*accordionHeaders;
@property(nonatomic,retain) NSMutableArray			*accordionViewSizes;
@property(nonatomic,retain) UIScrollView			*accordionScrollView;
@property(nonatomic,assign) CGRect					mainViewFrame;
@property(nonatomic,assign) BOOL					isParentScrollView;

@end

@implementation Accordion

@synthesize allowsMultipleSelection;
@synthesize allowsEmptySelection;
@synthesize startsWithCloseView;
@synthesize animationDuration;
@synthesize animationCurve;
@synthesize totalHeight;

@synthesize delegate;
@synthesize prevSelectedItem;
@synthesize currentSelectedItem;
@synthesize selectedIndex;
@synthesize selectionIndexes;
@synthesize accordionViews;
@synthesize accordionHeaders;
@synthesize accordionViewSizes;
@synthesize accordionScrollView;
@synthesize mainViewFrame;
@synthesize isParentScrollView;

#pragma mark - PUBLIC APIs

-(id)initWithFrame:(CGRect)frame delegate:(id<AccordionDelegate>)aDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate			 = aDelegate;
        self.mainViewFrame		 = frame;
        self.accordionScrollView = nil;
        self.isParentScrollView	 = false;
        [self initAccordion];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView delegate:(id<AccordionDelegate>)aDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate			 = aDelegate;
        self.mainViewFrame		 = frame;
        self.accordionScrollView = scrollView;
        self.isParentScrollView	 = true;
        [self initAccordion];
    }
    return self;
}

-(NSInteger)selectedIndex {
    return [selectionIndexes firstIndex];
}

-(void)setSelectedIndex:(NSInteger)index {
    [self setSelectionIndexes:[NSIndexSet indexSetWithIndex:index]];
}

-(void)setSelectionIndexes:(NSIndexSet *)indexes {
    if ([accordionHeaders count] == 0) return;
    if (!allowsMultipleSelection && [indexes count] > 1) {
        indexes = [NSIndexSet indexSetWithIndex:[indexes firstIndex]];
    }
    
    NSMutableIndexSet *cleanIndexes = [NSMutableIndexSet new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx > [accordionHeaders count] - 1) return;
        
        [cleanIndexes addIndex:idx];
    }];
    
    selectionIndexes = cleanIndexes;
    [self setNeedsLayout];
    
    if((self.delegate) && ([self.delegate respondsToSelector:@selector(accordion:currentIndex:previousIndex:)])) {
        [self.delegate accordion:self currentIndex:currentSelectedItem previousIndex:prevSelectedItem];
    }
}

-(void)addHeader:(id)aHeader withView:(id)aView textFont:(UIFont *)textFont {
    if ((aHeader != nil) && (aView != nil)) {
        
        if([aHeader isKindOfClass:[NSString class]]) {
            NSString *headingText = [NSString stringWithString:aHeader];
            if([headingText isEqualToString:ACCORDION_NO_HEADING]) {
                aHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            } else {
            	aHeader = [[AccordionHeaderView alloc]initWithHeader:headingText];
            }
        }
        
        if([aView isKindOfClass:[NSString class]]) {
            UILabel *lblDesc = [Utilities creatUILabel:aView font:textFont foreColor:[UIColor darkGrayColor] x:ACCORDION_IPHONE_TEXT_PADDING y:ACCORDION_IPHONE_TEXT_PADDING width:(ACCORDION_IPHONE_WIDTH - (2*ACCORDION_IPHONE_TEXT_PADDING)) height:0];
            UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, lblDesc.frame.size.height + 2*ACCORDION_IPHONE_TEXT_PADDING)];
            [descView addSubview:lblDesc];
            
            aView = descView;
        }
        
        [accordionHeaders addObject:aHeader];
        [accordionViews addObject:aView];
        
        [accordionViewSizes addObject:[NSValue valueWithCGSize:[aView frame].size]];
        
        [aView setAutoresizingMask:UIViewAutoresizingNone];
        [aView setClipsToBounds:YES];
        
        CGRect frame = [aHeader frame];
        if(frame.size.height == 0) {
            NSMutableIndexSet *mis = [selectionIndexes mutableCopy];
            [mis addIndex:([accordionHeaders count] - 1)];
            [self setSelectionIndexes:mis];
        }
        
        frame.origin.x = 0;
        frame.size.width = [self frame].size.width;
        [aHeader setFrame:frame];
        
        frame = [aView frame];
        frame.origin.x = 0;
        frame.size.width = [self frame].size.width;
        [aView setFrame:frame];
        
        [accordionScrollView addSubview:aView];
        [accordionScrollView addSubview:aHeader];
        
        if([aHeader isKindOfClass:[AccordionHeaderView class]]) {
            AccordionHeaderView *aaHeader = (AccordionHeaderView *)aHeader;
            [aaHeader.lblHeader setTag:[accordionHeaders count] - 1];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedLabel:)];
            [aaHeader.lblHeader addGestureRecognizer:tapGesture];
            tapGesture = nil;
            
            [Utilities updateViewHeight:aaHeader.borderBottom height:0];
        }

        if (!self.startsWithCloseView && [selectionIndexes count] == 0) {
            [self setSelectedIndex:0];
        }
        
    }
}

#pragma mark - PRIVATE APIs

-(void)initAccordion{
    allowsMultipleSelection	= NO;
    allowsEmptySelection	= YES;
    startsWithCloseView		= YES;
    animationDuration		= 0.3;
    animationCurve			= UIViewAnimationCurveEaseIn;
    
    prevSelectedItem	= -1;
    currentSelectedItem	= -1;
    selectionIndexes	= [[NSMutableIndexSet alloc] init];
    selectedIndex		= [selectionIndexes firstIndex];
    accordionViews		= [NSMutableArray new];
    accordionHeaders	= [NSMutableArray new];
    accordionViewSizes	= [NSMutableArray new];
    
    if(isParentScrollView == false) {
        accordionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
        accordionScrollView.backgroundColor			= [UIColor clearColor];
        accordionScrollView.userInteractionEnabled	= YES;
        accordionScrollView.autoresizesSubviews		= NO;
        accordionScrollView.scrollsToTop			= NO;
        [self addSubview:accordionScrollView];
    }
    accordionScrollView.delegate = self; //??? Check -> Assuming parent is not handling scrollViewDidScroll delegate method
    
    self.backgroundColor		= [UIColor clearColor];
	self.userInteractionEnabled	= YES;
    self.autoresizesSubviews	= NO;
}

- (void)setStartsWithCloseView:(BOOL)state {
    if (state) {
        [self setSelectionIndexes:[NSIndexSet indexSet]];
    }
    startsWithCloseView = state;
}

- (void)touchDown:(id)sender {
    
    AccordionHeaderView *aHeader = [accordionHeaders objectAtIndex:[sender tag]];
    
    prevSelectedItem = currentSelectedItem;
    currentSelectedItem = [sender tag];
    
    if (allowsMultipleSelection) {
        NSMutableIndexSet *mis = [selectionIndexes mutableCopy];
        if ([selectionIndexes containsIndex:[sender tag]]) {
            if (self.allowsEmptySelection || [selectionIndexes count] > 1) {
                [mis removeIndex:[sender tag]];
                [aHeader setHeaderState:ACCORDION_HEADER_STATE_CLOSE];
            }
        } else {
            [mis addIndex:[sender tag]];
            [aHeader setHeaderState:ACCORDION_HEADER_STATE_OPEN];
        }
        
        [self setSelectionIndexes:mis];
    } else {
        // If the touched section is already opened, close it.
        if (([selectionIndexes firstIndex] == [sender tag]) && self.allowsEmptySelection) {
            [self setSelectionIndexes:[NSIndexSet indexSet]];
            [aHeader setHeaderState:ACCORDION_HEADER_STATE_CLOSE];
        } else {
            [self setSelectedIndex:[sender tag]];
            [aHeader setHeaderState:ACCORDION_HEADER_STATE_OPEN];
        }
        if((prevSelectedItem >= 0) && (prevSelectedItem != currentSelectedItem)) {
            AccordionHeaderView *prevHeader = [accordionHeaders objectAtIndex:prevSelectedItem];
            [prevHeader setHeaderState:ACCORDION_HEADER_STATE_CLOSE];
        }
    }
}

-(void)touchedLabel:(UITapGestureRecognizer *)tapGesture {
    [self touchDown:[tapGesture view]];
}

- (void)animationDone {
    for (int i=0; i<[accordionViews count]; i++) {
        if (![selectionIndexes containsIndex:i]) [[accordionViews objectAtIndex:i] setHidden:YES];
    }
}

- (void)layoutSubviews {
    int height = ((isParentScrollView)?(mainViewFrame.origin.y):(0));
    NSUInteger accordionsCount = [accordionViews count];
    for (int i=0; i<accordionsCount; i++) {
        AccordionHeaderView *aHeader = [accordionHeaders objectAtIndex:i];
        id aView = [accordionViews objectAtIndex:i];
        
        if(i == (accordionsCount -1 )) {
            if([aHeader isKindOfClass:[AccordionHeaderView class]]) {
                // Last objects ned to have border bottom also
                [Utilities updateViewHeight:aHeader.borderBottom height:1];
            }
        }
        
        CGSize originalSize = [[accordionViewSizes objectAtIndex:i] CGSizeValue];
        CGRect viewFrame = [aView frame];
        CGRect headerFrame = [aHeader frame];
        headerFrame.origin.y = height;
        height += headerFrame.size.height;
        viewFrame.origin.y = height;
        
        if ([selectionIndexes containsIndex:i]) {
            viewFrame.size.height = originalSize.height;
            [aView setFrame:CGRectMake(0, viewFrame.origin.y, [self frame].size.width, 0)];
            [aView setHidden:NO];
        } else {
            viewFrame.size.height = 0;
        }
        
        height += viewFrame.size.height;
        
        if (!CGRectEqualToRect([aHeader frame], headerFrame) || !CGRectEqualToRect([aView frame], viewFrame)) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDone)];
            [UIView setAnimationDuration:self.animationDuration];
            [UIView setAnimationCurve:self.animationCurve];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [aHeader setFrame:headerFrame];
            [aView setFrame:viewFrame];
            [UIView commitAnimations];
        }
    }
    
    CGPoint offset = accordionScrollView.contentOffset;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationCurve:self.animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [accordionScrollView setContentSize:CGSizeMake([self frame].size.width, height)];
    [UIView commitAnimations];
    
    
    if (offset.y + accordionScrollView.frame.size.height > height) {
        offset.y = height - accordionScrollView.frame.size.height;
        if (offset.y < 0) {
            offset.y = 0;
        }
    }
    [accordionScrollView setContentOffset:offset animated:YES];
    [self scrollViewDidScroll:accordionScrollView];
    totalHeight = height;
    if((self.delegate) && ([self.delegate respondsToSelector:@selector(accordion:layoutSubviewsWithTotalHeight:)])) {
        [self.delegate accordion:self layoutSubviewsWithTotalHeight:totalHeight];
    }
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int i = 0;
    for (UIView *view in accordionViews) {
        if (view.frame.size.height > 0) {
            UIView *header = [accordionHeaders objectAtIndex:i];
            CGRect content = view.frame;
            content.origin.y -= header.frame.size.height;
            content.size.height += header.frame.size.height;
            
            CGRect frame = header.frame;
            if (CGRectContainsPoint(content, aScrollView.contentOffset)) {
                if (aScrollView.contentOffset.y < content.origin.y + content.size.height - frame.size.height) {
                    frame.origin.y = aScrollView.contentOffset.y;
                } else {
                    frame.origin.y = content.origin.y + content.size.height - frame.size.height;
                }
                
            } else {
                frame.origin.y = view.frame.origin.y - frame.size.height;
            }
            header.frame = frame;
        }
        i++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
