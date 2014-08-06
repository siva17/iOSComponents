//
//  WebServiceExampleVC.m
//  WebServiceInterface
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

#import "WebServiceExampleVC.h"
#import "DMSignupReq.h"
#import "DMSignupRes.h"

@interface WebServiceExampleVC ()
@property(nonatomic,retain) UITextView *wsRspTextView;
@property(nonatomic,retain) WebService *wsHandler;
@end

@implementation WebServiceExampleVC

@synthesize wsRspTextView;
@synthesize wsHandler = _wsHandler;

#pragma mark - Lazy instantiation
-(WebService *)wsHandler {
    if (!_wsHandler) _wsHandler = [[WebService alloc]initWithVC:self];
    return _wsHandler;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)wsSignup:(id)sender {
    DMWebservice *wsDM	= [[DMWebservice alloc]init];
    
    wsDM.url = WS_URL_SIGNUP;
    
    DMSignupReq *reqDM = [[DMSignupReq alloc]init];
    
    reqDM.email = @"TestEmail@test.com";
    reqDM.password = @"Test Password";
    reqDM.firstName = @"Test First Name"; // NULL Last Name for testing
    
    DMSignupReqDetails *signUpDetails = [[DMSignupReqDetails alloc]init];
    signUpDetails.address = @"This is the address of signupDetails";
    signUpDetails.mobile = @"1234567890";
    reqDM.signupDetails = signUpDetails;
    
    DMSignupReqDetails *s1 = [[DMSignupReqDetails alloc]init];
    s1.address = @"This is the address of signupDetails 1";
    s1.mobile = @"1234567890 1";
    DMSignupReqDetails *s2 = [[DMSignupReqDetails alloc]init];
    s2.address = @"This is the address of signupDetails 2";
    s2.mobile = @"1234567890 2";
    DMSignupReqDetails *s3 = [[DMSignupReqDetails alloc]init];
    s3.address = @"This is the address of signupDetails 3";
    s3.mobile = @"1234567890 3";

    reqDM.signupArray = @[s1,s2,s3];
    
    wsDM.requestDM = reqDM;
    
    DMSignupRes *resDM = [[DMSignupRes alloc]init];
    wsDM.responseDM = resDM;
    
    [self.wsHandler sendRequest:wsDM];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WebService";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSignup addTarget:self action:@selector(wsSignup:) forControlEvents:UIControlEventTouchUpInside];
    [btnSignup setTitle:@"SignUp" forState:UIControlStateNormal];
    [btnSignup setTintColor:[UIColor whiteColor]];
    [btnSignup setBackgroundColor:[UIColor grayColor]];
    btnSignup.frame = CGRectMake(20, 80, 280, 34);
	[self.view addSubview:btnSignup];
    
    wsRspTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, 300, 440)];
	[self.view addSubview:wsRspTextView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebServiceInterface Delegate

-(void)webService:(WebService *)webService response:(DMWebservice *)response {
	NSString *strRsp = @"Failed Web Service Response";
    if(response.status == WS_STATUS_SUCCESS) {
        strRsp = [NSString stringWithFormat:@"Response:\n\t%@",response];
    }
    if(strRsp) wsRspTextView.text = strRsp;
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
