//
//  LocationManagerExampleVC.m
//  Location
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

#import "LocationManagerExampleVC.h"
#import "Loading.h"

@interface LocationManagerExampleVC ()
@property(nonatomic,retain) LocationManager *locManager;
@property(nonatomic,retain) Loading			*loadingIndicator;
@property(nonatomic,retain) UITextView		*locTextView;
@end

@implementation LocationManagerExampleVC

@synthesize locManager = _locManager;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize locTextView;

#pragma mark - Lazy instantiation

-(LocationManager *)locManager {
    if (!_locManager) {
        _locManager = [[LocationManager alloc] initWithDelegate:self];
        if(_locManager) {
            [_locManager configErrorAlertWithShowStatus:NO message:nil];
        }
    }
    return _locManager;
}

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

-(void)startLocation:(id)sender {
    if(self.locManager) {
        [self.loadingIndicator showLoading];
    	[self.locManager startLocationTracking];
    }
}
-(void)stopLocation:(id)sender {
    if(self.locManager) {
    	[self.locManager stopLocationTracking];
        [self.loadingIndicator hideLoading];
    }
}
-(void) viewWillDisappear:(BOOL)animated {
    [self stopLocation:NULL];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Location Manager";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStart addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitle:@"Start" forState:UIControlStateNormal];
    [btnStart setTintColor:[UIColor blackColor]];
    [btnStart setBackgroundColor:[UIColor greenColor]];
    btnStart.frame = CGRectMake(20, 70, 130, 34);
	[self.view addSubview:btnStart];
    
    UIButton *btnStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStop addTarget:self action:@selector(stopLocation:) forControlEvents:UIControlEventTouchUpInside];
    [btnStop setTitle:@"Stop" forState:UIControlStateNormal];
    [btnStop setTintColor:[UIColor whiteColor]];
    [btnStop setBackgroundColor:[UIColor redColor]];
    btnStop.frame = CGRectMake(170, 70, 130, 34);
	[self.view addSubview:btnStop];
    
    locTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 300, 440)];
	[self.view addSubview:locTextView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate

-(void) locationManager:(LocationManager *)locationManager details:(CLPlacemark *)details {
    [self.loadingIndicator hideLoading];
    if(details) {
        AppLog(APP_LOG_FLOW, @"Got Location update");
        NSString *locationDetails = [NSString stringWithFormat:
                                     @"altitude: %f\nlatitude: %f\nlongitude: %f",
                                     details.location.altitude,
                                     details.location.coordinate.latitude,
                                     details.location.coordinate.longitude];
        NSString *otherDetails = [NSString stringWithFormat:@"\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@",
                                  @"name:",					details.name,
                                  @"thoroughfare:",			details.thoroughfare,
                                  @"subThoroughfare:",		details.subThoroughfare,
                                  @"locality:",				details.locality,
                                  @"subLocality:",			details.subLocality,
                                  @"administrativeArea:",	details.administrativeArea,
                                  @"postalCode:",			details.postalCode,
                                  @"ISOcountryCode:",		details.ISOcountryCode,
                                  @"country:",				details.country,
                                  @"inlandWater:",			details.inlandWater,
                                  @"ocean:",				details.ocean,
                                  @"areasOfInterest:",		details.areasOfInterest];
        NSString *addressDict = [NSString stringWithFormat:@"\n\naddressDictionary: %@",details.addressDictionary];
        locTextView.text = [NSString stringWithFormat:@"%@%@%@",locationDetails,otherDetails,addressDict];
    } else {
        AppLog(APP_LOG_FLOW, @"Failed to get Location update");
        locTextView.text = @"Failed to get Location update";
    }
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
