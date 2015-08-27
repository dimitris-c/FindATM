//
//  LocationHandler.m
//  ATMMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Updated by Dimitris C.
//

#import "LocationHandler.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

static LocationHandler *_sharedInstance = nil;

@interface LocationHandler ()
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;
@end

@implementation LocationHandler

+ (LocationHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocationHandler alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setupLocationManager];
    }
    return self;
}

- (void)didBecomeActive {
    if([CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied)
        [self showMessage];
}
#pragma mark get Wifi Data

- (void)setupLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;

}

- (void)startUpdatingLocation {

    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    Log(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if(status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [self startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusRestricted) {
        [self showMessage];
    }
    else if(status == kCLAuthorizationStatusDenied) {
        [self showMessage];
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
    //new location arrived
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
}

- (void)getAddressFromLocation:(CLLocation *)location WithCompletion:(MessageResponse)completion {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (!error) {
            NSString *locatedAt = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];

            if (completion != nil) {
                completion(locatedAt);
            }
        }
        
    }];
    
}

- (double)getLatitude {
    return self.currentLocation.coordinate.latitude;
}

- (double)getLongitude {
    
    return self.currentLocation.coordinate.longitude;
}

- (double)getAccuracy {
    return self.currentLocation.horizontalAccuracy;
}

-(void)showMessage {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services are off"
                                                        message:@"To use location you must turn on permission in the Location Services Settings"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Settings", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
    else
        self.currentLocation = nil;
}
@end
