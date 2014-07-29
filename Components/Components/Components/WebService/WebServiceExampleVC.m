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

@interface WebServiceExampleVC ()
@property(nonatomic,retain) WebServiceInterface *wsSignup;
@property(nonatomic,retain) WebServiceInterface *wsLogin;
@property(nonatomic,retain) WebServiceInterface *wsHomeList;
@property(nonatomic,retain) WebServiceInterface *wsHomeListSearch;
@property(nonatomic,retain) UITextView			*wsRspTextView;
@end

@implementation WebServiceExampleVC

@synthesize wsSignup	= _wsSignup;
@synthesize wsLogin		= _wsLogin;
@synthesize wsHomeList	= _wsHomeList;
@synthesize wsHomeListSearch = _wsHomeListSearch;
@synthesize wsRspTextView;

#pragma mark - Lazy instantiation

-(WebServiceInterface *)wsSignup {
    if (!_wsSignup) {
        _wsSignup = [[WebServiceInterface alloc]initWithVC:self webServiceType:WS_SIGNUP];
    }
    return _wsSignup;
}
-(WebServiceInterface *)wsLogin {
    if (!_wsLogin) {
        _wsLogin = [[WebServiceInterface alloc]initWithVC:self webServiceType:WS_LOGIN];
    }
    return _wsLogin;
}
-(WebServiceInterface *)wsHomeList {
    if (!_wsHomeList) {
        _wsHomeList = [[WebServiceInterface alloc]initWithVC:self webServiceType:WS_HOME_LIST];
    }
    return _wsHomeList;
}
-(WebServiceInterface *)wsHomeListSearch {
    if (!_wsHomeListSearch) {
        _wsHomeListSearch = [[WebServiceInterface alloc]initWithVC:self webServiceType:WS_HOME_LIST];
    }
    return _wsHomeListSearch;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)wsSignup:(id)sender {
    NSMutableDictionary *wsParams	= [[NSMutableDictionary alloc]init];
    DMSignupReq *dataModel			= [[DMSignupReq alloc]init];
    dataModel.username				= @"TestUserName";
    dataModel.password				= @"TestPassword";
    dataModel.firstName				= @"TestFisrtName";
    dataModel.lastName				= @"TestLastName";
    [wsParams setObject:dataModel forKey:WSI_KEY_REQUEST_DATA_MODEL];
    [self.wsSignup sendRequest:wsParams];
    RELEASE_MEM(dataModel);
    RELEASE_MEM(wsParams);
}
-(void)wsLogin:(id)sender {
    NSMutableDictionary *wsParams	= [[NSMutableDictionary alloc]init];
    DMLoginReq *dataModel			= [[DMLoginReq alloc]init];
    dataModel.username				= @"TestUserName";
    dataModel.password				= @"TestPassword";
    [wsParams setObject:dataModel forKey:WSI_KEY_REQUEST_DATA_MODEL];
    [self.wsLogin sendRequest:wsParams];
    RELEASE_MEM(dataModel);
    RELEASE_MEM(wsParams);
}
-(void)wsHomeList:(id)sender {
    NSMutableDictionary *wsParams	= [[NSMutableDictionary alloc]init];
    DMHomeListReq *dataModel		= [[DMHomeListReq alloc]init];
    dataModel.requestName			= @"TestRequest";
    dataModel.searchName			= NULL;
    [wsParams setObject:dataModel forKey:WSI_KEY_REQUEST_DATA_MODEL];
    [self.wsHomeList sendRequest:wsParams];
    RELEASE_MEM(dataModel);
    RELEASE_MEM(wsParams);
}
-(void)wsHomeListSearch:(id)sender {
    NSMutableDictionary *wsParams	= [[NSMutableDictionary alloc]init];
    DMHomeListReq *dataModel		= [[DMHomeListReq alloc]init];
    dataModel.requestName			= NULL;
    dataModel.searchName			= @"TestSearch";
    [wsParams setObject:dataModel forKey:WSI_KEY_REQUEST_DATA_MODEL];
    [self.wsHomeListSearch sendRequest:wsParams];
    RELEASE_MEM(dataModel);
    RELEASE_MEM(wsParams);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WebService Interface";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSignup addTarget:self action:@selector(wsSignup:) forControlEvents:UIControlEventTouchUpInside];
    [btnSignup setTitle:@"SignUp" forState:UIControlStateNormal];
    [btnSignup setTintColor:[UIColor whiteColor]];
    [btnSignup setBackgroundColor:[UIColor grayColor]];
    btnSignup.frame = CGRectMake(20, 70, 130, 34);
	[self.view addSubview:btnSignup];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin addTarget:self action:@selector(wsLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin setTintColor:[UIColor whiteColor]];
    [btnLogin setBackgroundColor:[UIColor grayColor]];
    btnLogin.frame = CGRectMake(170, 70, 130, 34);
	[self.view addSubview:btnLogin];
    
    UIButton *btnHomeList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnHomeList addTarget:self action:@selector(wsHomeList:) forControlEvents:UIControlEventTouchUpInside];
    [btnHomeList setTitle:@"HomeList" forState:UIControlStateNormal];
    [btnHomeList setTintColor:[UIColor whiteColor]];
    [btnHomeList setBackgroundColor:[UIColor grayColor]];
    btnHomeList.frame = CGRectMake(20, 110, 130, 34);
	[self.view addSubview:btnHomeList];
    
    UIButton *btnHomeListSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnHomeListSearch addTarget:self action:@selector(wsHomeListSearch:) forControlEvents:UIControlEventTouchUpInside];
    [btnHomeListSearch setTitle:@"HomeListSearch" forState:UIControlStateNormal];
    [btnHomeListSearch setTintColor:[UIColor whiteColor]];
    [btnHomeListSearch setBackgroundColor:[UIColor grayColor]];
    btnHomeListSearch.frame = CGRectMake(170, 110, 130, 34);
	[self.view addSubview:btnHomeListSearch];
    
    wsRspTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, 300, 440)];
	[self.view addSubview:wsRspTextView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebServiceInterface Delegate

-(void)webServiceResponse:(WebServiceInterface *)webServiceInterface status:(WSI_STATUS)status response:(id)response {
	NSString *strRsp = nil;
    if(status == WSI_STATUS_SUCCESS) {
    	if (webServiceInterface == self.wsSignup) {
            DMSignup *rsp = [webServiceInterface getDataModel:response];
			strRsp = [NSString stringWithFormat:@"Signup Response: \n\tUser ID\t\t: %@\n\tUserName\t: %@\n\tStatus\t\t: %d\n\terrorMsg\t\t: %@",
                                rsp.userID,rsp.userName,rsp.status,rsp.errorMsg];
        } else if (webServiceInterface == self.wsLogin) {
            DMLogin *rsp = [webServiceInterface getDataModel:response];
			strRsp = [NSString stringWithFormat:@"Login Response: \n\tUser ID\t\t: %@\n\tUserName\t: %@\n\tStatus\t\t: %d\n\terrorMsg\t\t: %@",
                      rsp.userID,rsp.userName,rsp.status,rsp.errorMsg];
        } else if (webServiceInterface == self.wsHomeList) {
            DMHomeList *rsp = [webServiceInterface getDataModel:response];
			strRsp = [NSString stringWithFormat:@"HomeList Response: \n\tStatus\t: %d\n\terrorMsg\t: %@\n\tList:\n",rsp.status,rsp.errorMsg];
            for (DMHomeListItem *listItem in rsp.homeList) {
                strRsp = [NSString stringWithFormat:@"%@\t\tID\t\t\t: %@\n\t\tName\t\t: %@\n\t\tDescription\t: %@\n\n",strRsp,listItem.listItemID,listItem.listItemName,listItem.listItemDescription];
            }
        } else if (webServiceInterface == self.wsHomeListSearch) {
            DMHomeList *rsp = [webServiceInterface getDataModel:response];
			strRsp = [NSString stringWithFormat:@"HomeList Search Response: \n\tStatus\t: %d\n\terrorMsg\t: %@\n\tList:\n",rsp.status,rsp.errorMsg];
            for (DMHomeListItem *listItem in rsp.homeList) {
                strRsp = [NSString stringWithFormat:@"%@\t\tID\t\t\t: %@\n\t\tName\t\t: %@\n\t\tDescription\t: %@\n\n",strRsp,listItem.listItemID,listItem.listItemName,listItem.listItemDescription];
            }
        }
    } else {
        strRsp = @"Failed Web Service Response";
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
