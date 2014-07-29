//
//  AsyncImageLoaderExampleVC.m
//  AsyncImageLoading
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

#import "AsyncImageLoaderExampleVC.h"
#import "AsyncImageLoader.h"

#define CELL_HEIGHT			(160)
#define CELL_HEIGHT_LABEL	(30)

@interface AsyncImageLoaderExampleVC ()
@property(nonatomic,retain) NSArray				*tblContents;
@property(nonatomic,retain) AsyncImageLoader	*asyncImgLoader;
@end

@implementation AsyncImageLoaderExampleVC

@synthesize tblContents;
@synthesize asyncImgLoader = _asyncImgLoader;

#pragma mark - Lazy instantiation

-(AsyncImageLoader *)asyncImgLoader {
    if (!_asyncImgLoader) {
        _asyncImgLoader = [[AsyncImageLoader alloc] init];
    }
    return _asyncImgLoader;
}

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Async Image Loader";
    tblContents = [[NSArray alloc] initWithObjects:
                   @"http://www.siva4u.com/public/img01.jpg",
                   @"http://www.siva4u.com/public/FailedTest.jpg",
                   @"http://www.siva4u.com/public/img02.jpg",
                   @"http://www.siva4u.com/public/img03.jpg",
                   @"http://www.siva4u.com/public/img04.jpg",
                   @"http://www.siva4u.com/public/img05.jpg",
                   @"http://www.siva4u.com/public/img06.jpg",
                   @"http://www.siva4u.com/public/img07.jpg",
                   @"http://www.siva4u.com/public/img08.jpg",
                   @"http://www.siva4u.com/public/img09.jpg",
                   @"http://www.siva4u.com/public/img10.jpg",
                   nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView		*cellLabelView;
    UILabel		*cellLabel;
    UIImageView	*cellImageView;
    
	CGRect cellFrameImage		= CGRectMake(0,0,320,CELL_HEIGHT);
	CGRect cellFrameLabelView	= CGRectMake(0,CELL_HEIGHT-CELL_HEIGHT_LABEL,320,CELL_HEIGHT_LABEL);
	CGRect cellFrameLabel		= CGRectMake(20,0,300,CELL_HEIGHT_LABEL);

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AsyncImageLoaderExampleVC"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AsyncImageLoaderExampleVC"];
    }
	if(cell) {        
        NSString *imgUrl = [tblContents objectAtIndex:indexPath.row];
        
        cellImageView = [[UIImageView alloc] initWithFrame:cellFrameImage];
        [cell.contentView addSubview:cellImageView];
        
        cellLabelView	= [[UIView alloc] initWithFrame:cellFrameLabelView];
        cellLabelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        cellLabel		= [[UILabel alloc] initWithFrame:cellFrameLabel];
        cellLabel.text	= [imgUrl stringByReplacingOccurrencesOfString:@"http://www.siva4u.com/public/" withString:@""];
        cellLabel.font	= [UIFont boldSystemFontOfSize:18.0];
        cellLabel.textColor = [UIColor whiteColor];
        cellLabel.backgroundColor = [UIColor clearColor];
        [cellLabelView addSubview:cellLabel];
        
        [cell.contentView addSubview:cellLabelView];
        
        [self.asyncImgLoader updateImageView:cellImageView imageUrl:imgUrl];
        AppLog(APP_LOG_INFO, @"URL: %@",imgUrl);
    }
    return cell;
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
