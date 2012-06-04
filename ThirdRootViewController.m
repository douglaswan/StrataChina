//
//  ThirdRootViewController.m
//  StrataChina
//
//  Created by Douglas Wan on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdRootViewController.h"
#import "avenueAnnotation.h"

@interface ThirdRootViewController ()

@end

@implementation ThirdRootViewController

@synthesize mapSegmentedControl;
@synthesize mapORProfileView;
@synthesize strataMapView;
@synthesize currentLocationManager;
@synthesize currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"地图";
        self.tabBarItem.image = [UIImage imageNamed:@"TABvenues.png"];
        UIImage *backroundImageNavigationBar = [UIImage imageNamed:@"navbar.png"];
        // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setBackgroundImage:backroundImageNavigationBar
                                           forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = nil;
        }
    return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    MKAnnotationView *result = Nil;
    
    if ([annotation isKindOfClass:[avenueAnnotation class]] == NO)
    {
        return result;
    }
    
    if ([mapView isEqual:self.strataMapView] == NO)
    {
        return result;
    }
    
    avenueAnnotation *senderAnnotation = (avenueAnnotation *)annotation;
    
    NSString *pinReusableIdentifier = @"hotelPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annotationView == nil )
    {
        annotationView = [[[MKPinAnnotationView alloc]
                          initWithAnnotation:senderAnnotation
                          reuseIdentifier:pinReusableIdentifier]
                          autorelease];
        
        [annotationView setCanShowCallout:YES];
        annotationView.animatesDrop = YES;
        
        UIButton *getDirectionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [getDirectionButton addTarget:self
                               action:@selector(getDirections)
                     forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = getDirectionButton;
        
    }
    
    annotationView.pinColor = senderAnnotation.pinColor;
    
    result = annotationView;
    return result;
}

- (void) showMap
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.95737, 116.28003);
    
    self.strataMapView = [[MKMapView alloc] initWithFrame:self.mapORProfileView.bounds];
    self.strataMapView.mapType = MKMapTypeStandard;
    MKCoordinateSpan hotelSpan = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion hotelRegion = MKCoordinateRegionMake(location, hotelSpan);
    
    [self.strataMapView setRegion:hotelRegion];
    
    self.strataMapView.delegate = self;
        
    self.strataMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapORProfileView addSubview:self.strataMapView];
    
    avenueAnnotation *hotelAnnotation = [[avenueAnnotation alloc] initWithCoordinates:location
                                                                                 title:@"北京海淀永泰福朋喜来登酒店"
                                                                              subtitle:@"北京市海淀区远大路25号A座"];
    
    hotelAnnotation.pinColor = MKPinAnnotationColorPurple;
    
    [self.strataMapView addAnnotation:hotelAnnotation];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        self.currentLocationManager = [[CLLocationManager alloc] init];
        self.currentLocationManager.delegate = self;
        
        [self.currentLocationManager startUpdatingLocation];
    }
    else 
    {
        NSLog(@"Location services are not enabled!");
    }
}

- (void) segmentChanged: (UISegmentedControl *)paramSender
{
    if ([paramSender isEqual:self.mapSegmentedControl])
    {
        NSInteger selectdSegmentIndex = [paramSender selectedSegmentIndex];
        
        if (selectdSegmentIndex == 0)
        {
            [self showMap];
        }
        if (selectdSegmentIndex == 1)
        {
            //show floor map
            UIImage *profileImage = [UIImage imageNamed:@"layout.png"];
            UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:self.mapORProfileView.bounds];
            profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            profileImageView.image = profileImage;
            [self.mapORProfileView addSubview:profileImageView];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapSegmentedControl addTarget:self
                                 action:@selector(segmentChanged:)
                       forControlEvents:UIControlEventValueChanged];
    

    
    [self showMap];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void) getDirections
{
    NSLog(@"Go...");
    
    CLLocationCoordinate2D start = self.currentLocation.coordinate; 
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(39.95737, 116.28003);
    
    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                     start.latitude, start.longitude, destination.latitude, destination.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.currentLocationManager stopUpdatingLocation];
    self.currentLocationManager = nil;
    
    self.strataMapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
