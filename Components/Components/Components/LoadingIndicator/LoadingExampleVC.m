//
//  LoadingExampleVC.m
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

#import "LoadingExampleVC.h"
#import "Loading.h"

@interface LoadingExampleVC ()
@property(nonatomic,retain) Loading *loadingIndicator;
@end

@implementation LoadingExampleVC

@synthesize loadingIndicator = _loadingIndicator;

#pragma mark - Lazy instantiation

-(Loading *)loadingIndicator {
    if (!_loadingIndicator) {
        _loadingIndicator = [[Loading alloc] initWithParentView:self.view];
    }
    return _loadingIndicator;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)stopLoading {
    [self.loadingIndicator hideLoading];
}
-(void)startLoading:(id)sender {
    [self.loadingIndicator showLoading];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(stopLoading) userInfo:nil repeats:NO];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Loading";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStart addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitle:@"Start Loading for 5 seconds" forState:UIControlStateNormal];
    [btnStart setTintColor:[UIColor whiteColor]];
    [btnStart setBackgroundColor:[UIColor grayColor]];
    btnStart.frame = CGRectMake(20, 200, 280, 50);
	[self.view addSubview:btnStart];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
