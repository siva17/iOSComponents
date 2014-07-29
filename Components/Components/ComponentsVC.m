//
//  ComponentsVC.m
//  Components
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

#import "ComponentsVC.h"

#import "AccordionExampleVC.h"
#import "AsyncImageLoaderExampleVC.h"
#import "LoadingExampleVC.h"
#import "LocationManagerExampleVC.h"
#import "WebServiceExampleVC.h"

@interface ComponentsVC()
@property(nonatomic,retain) NSArray						*tblContents;
@property(nonatomic,retain) AccordionExampleVC			*accordionVC;
@property(nonatomic,retain) AsyncImageLoaderExampleVC	*asyncImageLoaderVC;
@property(nonatomic,retain) LoadingExampleVC			*loadingIndicatorVC;
@property(nonatomic,retain) LocationManagerExampleVC	*locationManagerVC;
@property(nonatomic,retain) WebServiceExampleVC			*wsInterfaceVC;
@end

@implementation ComponentsVC

@synthesize tblContents;
@synthesize accordionVC;
@synthesize asyncImageLoaderVC;
@synthesize loadingIndicatorVC;
@synthesize locationManagerVC;
@synthesize wsInterfaceVC;

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Components";
    tblContents = [[NSArray alloc] initWithObjects:
                   @"Accordion",
                   @"Asyc Image Loader",
                   @"Loading",
                   @"Location Manager",
                   @"WebService Interface",
                   nil];
    [self.tableView reloadData];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tblContents count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComponentsVC"];
	if(cell) {
        cell.textLabel.text = [tblContents objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppLog(APP_LOG_INFO,@"Clicked: %d",indexPath.row);
    switch (indexPath.row) {
        case 0:
            RELEASE_MEM(accordionVC);
            accordionVC = [[AccordionExampleVC alloc] init];
            [self.navigationController pushViewController:accordionVC animated:YES];
            break;
            
        case 1:
            RELEASE_MEM(asyncImageLoaderVC);
            asyncImageLoaderVC = [[AsyncImageLoaderExampleVC alloc] init];
            [self.navigationController pushViewController:asyncImageLoaderVC animated:YES];
            break;
            
        case 2:
            RELEASE_MEM(loadingIndicatorVC);
            loadingIndicatorVC  = [[LoadingExampleVC alloc] init];
            [self.navigationController pushViewController:loadingIndicatorVC animated:YES];
            break;
            
        case 3:
            RELEASE_MEM(locationManagerVC);
            locationManagerVC  = [[LocationManagerExampleVC alloc] init];
            [self.navigationController pushViewController:locationManagerVC animated:YES];
            break;
            
        case 4:
            RELEASE_MEM(wsInterfaceVC);
            wsInterfaceVC = [[WebServiceExampleVC alloc] init];
            [self.navigationController pushViewController:wsInterfaceVC animated:YES];
            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

s// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
