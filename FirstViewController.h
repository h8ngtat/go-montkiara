//
//  FirstViewController.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 26/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlacePicker/GMSPlacePicker.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController

//<GMSMapViewDelegate>

@property (nonatomic,retain) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString *name2;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *cat;

//@property (strong, nonatomic) NSString *lat;
//@property (strong, nonatomic) NSString *lon;
//
@property double latitude;
@property double longitude;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *catLabel;




@end
