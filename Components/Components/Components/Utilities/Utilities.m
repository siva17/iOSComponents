//
//  Utilities.m
//  Utilities
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

#import "Utilities.h"

@implementation Utilities
+(void)updateViewHeight:(UIView *)thisView height:(CGFloat)height {
    CGRect thisViewFrame = thisView.frame;
    thisViewFrame.size.height = height;
    thisView.frame = thisViewFrame;
}

+(UILabel *)creatUILabel:(NSString *)text
                    font:(UIFont *)font
               foreColor:(UIColor *)foreColor
                       x:(CGFloat)x
                       y:(CGFloat)y
                   width:(CGFloat)width
                  height:(CGFloat)height {
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y,width,height)];
    fromLabel.text = text;
    fromLabel.font = font;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = foreColor;
    fromLabel.textAlignment = NSTextAlignmentCenter;
    
    return fromLabel;
}

+(CGFloat)getHeightOfLabelWithText:(NSString *)lblText lblFont:(UIFont *)lblFont frameSize:(CGSize)frameSize {
    CGSize expectedSize = [lblText boundingRectWithSize:frameSize
                                                options:(NSStringDrawingUsesDeviceMetrics) attributes:@{NSFontAttributeName: lblFont}
                                                context:nil].size;
    int numberOfLines = ((expectedSize.width/frameSize.width) + 1.0) ;
    return ((expectedSize.height) * numberOfLines * (1.2));
}

@end
