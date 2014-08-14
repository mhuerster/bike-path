//
//  XYZViewController.m
//  BikePath1
//
//  Created by Molly Huerster on 8/14/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "XYZViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface XYZViewController ()

@end

@implementation XYZViewController {
    GMSMapView *mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
//    NSLog(@"User's location: %@", mapView_.myLocation);
    mapView_.settings.myLocationButton = YES;
//    mapView_.settings.compassButton = YES;
    mapView_.settings.zoomGestures = YES;
    self.view = mapView_;
    NSLog(@"User's location: %@", mapView_.myLocation);
    // Creates a marker in the center of the map.
    // GMSMarker *marker = [[GMSMarker alloc] init];
    // marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    // marker.title = @"Sydney";
    // marker.snippet = @"Australia";
    // marker.map = mapView_;
}

//- (void)didTapMyLocationButtonForMapView: (GMSMapView*) mapView{
//    NSLog(@"User's location: %@", mapView_.myLocation);
////    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
