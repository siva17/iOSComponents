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

#import "AccordionHeaderView.h"

#define DEGREES_TO_RADIANS(angle)	(angle / 180.0 * M_PI)

@interface AccordionHeaderView()
@property(nonatomic,retain) NSString *headerPrevState;
@end

@implementation AccordionHeaderView

@synthesize headerState;

#pragma mark - PRIVATE APIs

-(void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees {
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

#pragma mark - PUBLIC APIs

-(id)initWithHeader:(NSString *)strHeader {
    self = [[[NSBundle mainBundle] loadNibNamed:@"AccordionHeaderView_iPhone"
                                          owner:self
                                        options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
        self.lblHeader.text	= strHeader;
        self.headerState	= ACCORDION_HEADER_STATE_CLOSE;
        self.headerPrevState= ACCORDION_HEADER_STATE_CLOSE;
    }
    return self;
}

-(void)setHeaderState:(NSString *)state {
    self.headerPrevState = headerState;
    headerState = state;
    if(![self.headerState isEqualToString:self.headerPrevState]) {
        [self rotateImage:self.imgViewArrow
                 duration:0.5
                    curve:UIViewAnimationCurveEaseIn
                  degrees:(([self.headerState isEqualToString:ACCORDION_HEADER_STATE_OPEN])?(-90):(0))];
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
