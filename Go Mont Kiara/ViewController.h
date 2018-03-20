//
//  ViewController.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 25/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlacePicker/GMSPlacePicker.h>
#import <CoreLocation/CoreLocation.h>
#import <Google/SignIn.h>
#import "YALFoldingTabBar.h"


@interface ViewController : UIViewController <GIDSignInUIDelegate, YALTabBarDelegate>


@property(nonatomic)CLLocationManager *locationManager;

-(void) updateSignedInUser: (NSString*)email;

@end

