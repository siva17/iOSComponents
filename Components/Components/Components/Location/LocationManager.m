//
//  LocationManager.m
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

#import "LocationManager.h"

#define DEFAULT_LOCATION_FETCH_INTERVAL	(60.0)

@interface LocationManager ()
@property(nonatomic,retain) id <LocationManagerDelegate> delegate;
@property(nonatomic,assign) CLLocationCoordinate2D	defaultLocation;
@property(nonatomic,retain) CLLocationManager		*locationManager;
@property(nonatomic,retain) CLPlacemark				*locationDetails;
@property(nonatomic,retain) NSTimer					*locationTimer;
@property(nonatomic,retain) NSString				*errorAlertMessage;
@property(nonatomic)		BOOL					showErrorAlert;
@end

@implementation LocationManager

@synthesize fetchInterval;

@synthesize delegate;
@synthesize defaultLocation;
@synthesize locationManager;
@synthesize locationDetails;
@synthesize locationTimer;
@synthesize errorAlertMessage;
@synthesize showErrorAlert;

#pragma mark - Local APIs

-(void) callDelegateWithPlaceMark:(CLPlacemark *)placemark {
    // Check whether Delete is initialized by caller
    if (self.delegate) {
        // Check whether Delete is implemented by caller
        if ([self.delegate respondsToSelector:@selector(locationManager: details:)]) {
            // If implemented, call the delegate function
            [delegate locationManager:self details:placemark];
        }
    }
}

-(void) locationFetch {
    [locationManager startUpdatingLocation];
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            AppLog(APP_LOG_FLOW, @"\nLocality: %@\nCountry: %@\n\n", placemark.locality, placemark.country);
            [self callDelegateWithPlaceMark:placemark];
        } else {
            AppLog(APP_LOG_FLOW, @"Error %@", error.description);
            [self callDelegateWithPlaceMark:NULL];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(self.showErrorAlert == YES) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error"
                                   message:self.errorAlertMessage
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
    }
    [self callDelegateWithPlaceMark:NULL];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *) oldLocation {
    if (newLocation != nil) [self reverseGeocode:newLocation];
    [locationManager stopUpdatingLocation];
}

#pragma mark - Public APIs

-(id)initWithDelegate:(id)thisDelegate {
    self = [super init];
    if (self) {
        delegate = thisDelegate;
        fetchInterval = DEFAULT_LOCATION_FETCH_INTERVAL;
        locationManager = [[CLLocationManager alloc] init];
        if(locationManager) {
            defaultLocation.latitude	= 0;
            defaultLocation.longitude	= 0;
	        locationManager.delegate	= self;
    	    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.errorAlertMessage = @"Failed to Get Your Location";
            self.showErrorAlert = YES;
        }
    }
    return self;
}

-(id)initWithLocation:(CLLocationCoordinate2D)location delegate:(id)thisDelegate {
    self = [super init];
    if (self) {
        delegate = thisDelegate;
        fetchInterval = DEFAULT_LOCATION_FETCH_INTERVAL;
        locationManager = [[CLLocationManager alloc] init];
        if(locationManager) {
            defaultLocation = location;
	        locationManager.delegate = self;
    	    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.errorAlertMessage = @"Failed to Get Your Location";
            self.showErrorAlert = YES;
        }
    }
    return self;
}

-(void)configErrorAlertWithShowStatus:(BOOL)show message:(NSString *)message {
    self.showErrorAlert = show;
    self.errorAlertMessage = message;
}

-(void)startLocationTracking {
    if(locationManager) {
        if((defaultLocation.longitude == 0) && (defaultLocation.latitude == 0)) {
            [locationManager startUpdatingLocation];
        } else {
            CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:defaultLocation.latitude longitude:defaultLocation.longitude];
            [self reverseGeocode:thisLocation];
        }
    }
    if(locationTimer) [locationTimer invalidate];
    locationTimer = [NSTimer scheduledTimerWithTimeInterval:fetchInterval target:self selector:@selector(locationFetch) userInfo:nil repeats:YES];
}

-(void)stopLocationTracking {
    if(locationTimer) [locationTimer invalidate];
    if(locationManager) [locationManager stopUpdatingLocation];
}

@end
