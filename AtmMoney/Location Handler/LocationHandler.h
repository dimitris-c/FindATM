//
//  LocationHandler.h
//  ATMMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Updated by Dimitris C.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define CURRENT_LOCATION_KEY @"currentLocation"

#define Location [LocationHandler sharedInstance]

@class Reachability;

@interface LocationHandler : NSObject <CLLocationManagerDelegate>

+ (LocationHandler *)sharedInstance;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

- (void)getAddressFromLocation:(CLLocation *)location WithCompletion:(MessageResponse)completion;

-(double)getLatitude;
-(double)getLongitude;
-(double)getAccuracy;

- (void)setupLocationManager;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
