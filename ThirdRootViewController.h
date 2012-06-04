//
//  ThirdRootViewController.h
//  StrataChina
//
//  Created by Douglas Wan on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface ThirdRootViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UISegmentedControl *mapSegmentedControl;
@property (nonatomic, strong) IBOutlet UIView *mapORProfileView;
@property (nonatomic, strong) MKMapView *strataMapView;
@property (nonatomic, strong) CLLocationManager *currentLocationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end
