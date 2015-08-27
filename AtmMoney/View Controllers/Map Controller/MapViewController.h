//
//  MapViewController.h
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Updated by Dimitris C.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *coords;

- (void)showAnnotations;

@end
