//
//  AppDelegate.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 25/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Google/SignIn.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, GIDSignInDelegate
>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLProximity lastProximity;

@end

