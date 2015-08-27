//
//  MapViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Updated by Dimitris C.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "MapViewController.h"
#import "Bank.h"
#import "LocationHandler.h"
#import "ATMDetailBankViewController.h"

@interface MKCustomPointAnnotation : MKPointAnnotation

@property(nonatomic,strong)Bank *currentBank;

-(instancetype)initWithBank:(Bank *)bank;

@end

@implementation MKCustomPointAnnotation

-(instancetype)initWithBank:(Bank *)bank {

    self = [super init];
    if(self)  {
        self.title = [Bank getBankNameFromType:bank.bankType];
        self.subtitle = bank.address;
        self.coordinate = bank.location;
        self.currentBank = bank;
    }
    return self;
}

@end

@interface MapViewController ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation MapViewController

- (void)viewDidLoad {
        // Do any additional setup after loading the view.
    [super viewDidLoad];
     self.navigationItem.title = NSLocalizedStringFromTable(@"mapviewcontroller.title", @"Localization", nil);
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               CGRectGetWidth(self.view.frame),
                                                               CGRectGetHeight(self.view.frame))];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];

    [self showAnnotations];

}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.mapView.frame = CGRectMake(0,  0,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    // redisplay the annotation on the map
    [self.mapView showAnnotations:self.annotations animated:NO];
}

- (void)showAnnotations {
    
    self.annotations = [[NSMutableArray alloc] init];
    [self.coords enumerateObjectsUsingBlock:^(Bank *obj, NSUInteger idx, BOOL *stop) {
        
        MKPointAnnotation * newAnnotation = [[MKCustomPointAnnotation alloc] initWithBank:obj];
        [self.annotations addObject:newAnnotation];
        
    }];
    [self.mapView addAnnotations:self.annotations];
    
    [self.mapView showAnnotations:self.annotations animated:NO];
    self.mapView.camera.altitude *= 1.5;

}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([Location getLatitude], [Location getLongitude]);
//    MKCoordinateRegion mapRegion;
//    mapRegion.center = location;
//    mapRegion.span.latitudeDelta = 0.08f;
//    mapRegion.span.longitudeDelta = 0.08f;
//    
//    [mapView setRegion:mapRegion animated: NO];
//    
////    [mapView setCenterCoordinate:location animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MKCustomPointAnnotation *)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView;
    static NSString *reuseIdentifier = @"MapAnnotation";

    annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];       
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;

        annotationView.image = [UIImage imageNamed:@"map-pin-annotation.png"];
        
        NSString *imageName = [Bank getImageNameFromBankState:annotation.currentBank.bankState];
        UIImageView *imageBankState = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        annotationView.leftCalloutAccessoryView = imageBankState;
        
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKCustomPointAnnotation *annotation = view.annotation;
    
    [SVProgressHUD show];
    [Eng.getNearestBanks getBankHistoryWithId:annotation.currentBank.buid
                               withCompletion:^{
                                   
                                   [SVProgressHUD dismiss];
                                   UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                   [self.navigationItem setBackBarButtonItem:backButtonItem];
                                   
                                   ATMDetailBankViewController *atmDetailViewController = [[ATMDetailBankViewController alloc] initWithBank:annotation.currentBank];
                                   [self.navigationController pushViewController:atmDetailViewController animated:YES];
                                   
                                }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"network.failure.title", @"Localization", nil)];                                       
                                   }];
    

    
}


@end
