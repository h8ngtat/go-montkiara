//
//  FirstViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 26/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "FirstViewController.h"
#import "AppData.h"
#import "User.h"


@interface FirstViewController ()

@end

@implementation FirstViewController {
    GMSPlacePicker *_placePicker;
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    //    locationManager.delegate = self; // we set the delegate of locationManager to self.
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    //    [locationManager requestAlwaysAuthorization];
    //
    //    [locationManager startUpdatingLocation];  //requesting location updates
    
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.hidden = YES;
    NSLog(@"User's location: %@", mapView_.myLocation);
    
}


//
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [errorAlert show];
//    NSLog(@"Error: %@",error.description);
//}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *crnLoc = [locations lastObject];
//    _lat = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
//    _lon = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
//    double _latitude = [_lat doubleValue];
//    double _longitude = [_lon doubleValue];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSString *)deviceLocation
//{
//    NSString *theLocation = [NSString stringWithFormat:@"%f, %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
//    return theLocation;
//}

// The code snippet below shows how to create a GMSPlacePicker
// centered on Sydney, and output details of a selected place.
- (IBAction)pickPlace:(UIButton *)sender {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(51.5108396, -0.0922251);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
        } else {
            NSLog(@"No place selected");
        }
    }];
}


// Add a UIButton in Interface Builder to call this function
- (IBAction)pickPlaceOld:(UIButton *)sender {
    
    CLLocation *myLocation = mapView_.myLocation;
    
    //    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.788204, -122.411937);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            _name2 = place.name;
            NSLog(@"%@",place.name);
            self.nameLabel.text = place.name;
            _address2 = place.formattedAddress;
            self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                      componentsJoinedByString:@"\n"];;
            NSLog(@"%@",place.formattedAddress);
            
            
            _cat = place.types[0];
            self.catLabel.text = place.types[0];
            NSLog(@"%@",_cat);
            
        } else {
            _name2 = @"No place selected";
            _address2 = @"";
        }
    }];
}



- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}
@end
