//
//  AccordionExampleVC.h
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

#import "AccordionExampleVC.h"

@implementation AccordionExampleVC

#pragma mark - View lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Accordion";
    self.view.backgroundColor = [UIColor grayColor];
    
    Accordion *thisAccordionView = [[Accordion alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64) delegate:self];
    [thisAccordionView setAllowsMultipleSelection:YES];	// Set this if you want to allow multiple selection
    [thisAccordionView setAllowsEmptySelection:YES];	// Set this to NO if you want to have at least one open section at all times
    [thisAccordionView setStartsWithCloseView:YES];		// Set this to YES if none to open by default.
    [self.view addSubview:thisAccordionView];
    
    AccordionHeaderView *head1 = [[AccordionHeaderView alloc]initWithHeader:@"ORANGE"];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    view1.backgroundColor = [UIColor orangeColor];
    [thisAccordionView addHeader:head1 withView:view1 textFont:nil];
    
    AccordionHeaderView *head2 = [[AccordionHeaderView alloc]initWithHeader:@"WHITE"];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    view2.backgroundColor = [UIColor whiteColor];
    [thisAccordionView addHeader:head2 withView:view2 textFont:nil];
    
    AccordionHeaderView *head3 = [[AccordionHeaderView alloc]initWithHeader:@"GREEN"];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    view3.backgroundColor = [UIColor greenColor];
    [thisAccordionView addHeader:head3 withView:view3 textFont:nil];
    
    [thisAccordionView addHeader:ACCORDION_NO_HEADING withView:@"Accordion view with no header and so opened" textFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    [thisAccordionView setNeedsLayout];
}

-(void)accordion:(Accordion *)accordion currentIndex:(NSInteger)currentIndex previousIndex:(NSInteger)previousIndex {
    NSLog(@"Current: %ld, Previous: %ld",(long)currentIndex, (long)previousIndex);
    
}
-(void)accordion:(Accordion *)accordion layoutSubviewsWithTotalHeight:(CGFloat)height {
    NSLog(@"Current View Height: %f",height);
}

@end
