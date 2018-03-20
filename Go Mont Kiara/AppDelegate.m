//
//  AppDelegate.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 25/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "AppDelegate.h"
#import "IBeaconViewController.h"
#import "ViewController.h"
#import "LoginViewController.h"

//model
#import "YALTabBarItem.h"
//controller
#import "YALFoldingTabBarController.h"

//helpers
#import "YALAnimatingTabBarConstants.h"


#import "AWSHandlers.h"
#import <AWSAPIGateway/AWSAPIGateway.h>

@import GooglePlaces;
@import GoogleMaps;


@interface AppDelegate (){
    double lastTen1;
    int counter1;
    double lastTen2;
    int counter2;
    int match;
    
    double approx1;
    double approx2;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //AWS Test start
    AWSHandlers *awsHandler = [[AWSHandlers alloc]init];
    [awsHandler setupAWS];
    [awsHandler invalidateAWSCredentialsAndHandlers];
    //AWS Test end
    
    
    
    
    
    
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyAsHsep1HGaNuG46jXO0P97iz-1_C2Vj84"];
    [GMSServices provideAPIKey:@"AIzaSyAsHsep1HGaNuG46jXO0P97iz-1_C2Vj84"];
    
    
    /** beacon impl
    // Override point for customization after application launch.
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"fda50693-a4e2-4fb1-afcf-c6eb07647825"];
    
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:@"SKYBEACON1"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    // New iOS 8 request for Always Authorization, required for iBeacons to work!
    //if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      //  [self.locationManager requestAlwaysAuthorization];
   // }
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    
    
    //[self.locationManager startMonitoringForRegion:beaconRegion2];
    //[self.locationManager startRangingBeaconsInRegion:beaconRegion2];
    
    [self.locationManager startUpdatingLocation];
    
    lastTen1 = 0;
    lastTen2 = 0;
    counter1 = 0;
    counter2 = 0;
    
    match = 0;
    approx1 = 0;
    approx2 = 0;
    **/
    
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;

    [self setupYALTabBarController];
    
    
    
    
    /**
    
    SamplesApplicationData* data = [SamplesApplicationData getInstance];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
    
    data.clientId = [dictionary objectForKey:@"clientId"];
    data.authority = [dictionary objectForKey:@"authority"];
    data.resourceId = [dictionary objectForKey:@"resourceString"];
    data.redirectUriString = [dictionary objectForKey:@"redirectUri"];
    data.taskWebApiUrlString = [dictionary objectForKey:@"taskWebAPI"];
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"YourIdentityPoolId"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1  credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
**/
    
    
    
    return YES;
}

- (void)setupYALTabBarController {
    YALFoldingTabBarController *tabBarController = (YALFoldingTabBarController *) self.window.rootViewController;
    
    //prepare leftBarItems
    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                      leftItemImage:[UIImage imageNamed:@"search_icon"]
                                                     rightItemImage:[UIImage imageNamed:@"new_chat_icon"]];
    
    
    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
                                                      leftItemImage:[UIImage imageNamed:@"edit_icon"]
                                                     rightItemImage:nil];
    
    tabBarController.leftBarItems = @[item1, item2];
    
    //prepare rightBarItems
    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                      leftItemImage:[UIImage imageNamed:@"search_icon"]
                                                     rightItemImage:[UIImage imageNamed:@"new_chat_icon"]];
    
    
    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"settings_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    tabBarController.rightBarItems = @[item3, item4];
    
    tabBarController.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
    
    tabBarController.selectedIndex = 0;
    
    //customize tabBarView
    tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    tabBarController.tabBarView.backgroundColor = [UIColor colorWithRed:94.f/255.f green:91.f/255.f blue:149.f/255.f alpha:1.f];
    tabBarController.tabBarView.tabBarColor = [UIColor colorWithRed:72.f/255.f green:211.f/255.f blue:178.f/255.f alpha:1.f];
    tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
    tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
    tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    //[GIDSignIn sharedInstance] handleURL:<#(NSURL *)#> sourceApplication:<#(NSString *)#> annotation:<#(id)#>
    
        return [[GIDSignIn sharedInstance] handleURL:url
                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    NSLog(@"userId=%@, idToken=%@, fullName=%@, givenName=%@, familyName=%@, email=%@",userId, idToken, fullName, givenName, familyName, email);
    
    
    //NSData *postData = [NSJSONSerialization dataWithJSONObject:idToken options:0 error:&error];
    //NSString *signinEndpoint = @"https://aws3.i-tut.com/MyGoogleProject/verifytoken2";
    NSString *signinEndpoint = @"https://4vzao3s9w5.execute-api.ap-southeast-1.amazonaws.com/Stage/pets/Testing";
    //NSDictionary *params = @{@"idtoken": idToken};
    //NSURLRequest * urlReq = [NSURLRequest requestWithURL: [NSURL URLWithString: URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: signinEndpoint]];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPMethod:@"POST"];
    [request setHTTPMethod:@"GET"];
    
    
    NSData *requestData = [idToken dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestData];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
               queue:queue
   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if (response != nil){
           //if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode] ]){
               // The server responded with an HTTP status code that indicates success
               //if ([[self acceptableMIMETypes] containsObject:[[response MIMEType] lowerCaseString] ]){
                   // The server responded with a MIME type we can understand.
                   if ([data length] > 0){
                       NSError	*jsonError	= nil;
                       id		jsonObject	= nil;
                       // The server provided data in the response, which means we can attempt to parse it
                       
                       // Note that we are not specifying NSJSONReadingMutableContainers or NSJSONReadingMutableLeaves, as this would result in
                       // an object that is not safe to use across threads.
                       jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                       if (jsonObject != nil){
                           // The JSON parser successfully parsed the data, and returned an object. There is nothing to tell us what kind of object was returned.
                           // We need to make sure it responds to the selectors we will be using - ideally, we'd pass this object to a method that takes an
                           // id parameter, not NSDictionary, and inside that method it would check wether the id object responds to the specific selectors
                           // it is going to use on it.
                           
                           NSLog(@"EMAIL====>%@",[jsonObject valueForKey:@"email"]);
                           ViewController *viewController = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
                           
                           UIViewController *baseVC = [((UITabBarController *)self.window.rootViewController) selectedViewController];
                           
                          
                               
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               //[viewController updateSignedInUser:[jsonObject valueForKey:@"email"]];
                               if(baseVC != nil){
                                   if([baseVC isMemberOfClass:[ViewController class]]){
                                       [(ViewController *)baseVC updateSignedInUser:[jsonObject valueForKey:@"phoneNo"]];
                                   }else if([baseVC isMemberOfClass:[LoginViewController class]]){
                                       [(LoginViewController *)baseVC updateSignedInUserPhoneNo:[jsonObject valueForKey:@"phoneNo"]];
                                   }
                               }else{
                                   NSLog(@"viewController is NIL, cannot update phoneNo to label");
                               }
                            });
                           
                           
                           /**
                           if ([jsonObject respondsToSelector:@selector(dictionaryWithDictionary:)]){
                               [self doStuffWithDictionary:jsonObject];
                           }**/
                           
                       } else {
                           // The JSON parser was unable to understand the data we provided, and the error should indicate why.
                          // [self presentError:jsonError];
                       }
                       
                   } else {
                       // The server responded with data that was zero length. How you deal with this is up to your application's needs.
                       // You may create your own instance of NSError that describes the problem and pass it to your error handling, etc.
                   }
           
           /**
               } else {
                   // The server response was a MIME type we could not understand. How you handle this is up to you.
               }
       
                 } else {
               // The server response indicates something went wrong: a 401 Not Found, etc.
               // It's up to your application to decide what to do about HTTP statuses that indicate failure.
               // You may create your own instance of NSError that describes the problem and pass it to your error handling, etc.
           }**/
       } else {
           // Only inspect the error parameter if the response is nil.
           // The error indicates why the URL loading system could not connect to the server.
           // It is only valid to use this error if the server could not connect - which is indicated by a nil response
           //[self presentError:connectionError];
       }
      
       
       /**
       if (error) {
           NSLog(@"Error: %@", error.localizedDescription);
       } else {
           NSLog(@"Signed in as %@", data.bytes);
       }**/
   }];
    
    
    
    
// ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    NSLog(@"userId=%@",error.description);
}





-(void)sendLocalNotificationWithMessage:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    //IBeaconViewController *viewController = (IBeaconViewController*)self.window.rootViewController;
    IBeaconViewController *viewController = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
    
    viewController.beacons = beacons;
    [viewController.tableView reloadData];
    
    NSString *message = @"";
    
    if(beacons.count > 0) {
        for (CLBeacon *beacon in beacons) {
            int index = 0;
            if([beacon.major isEqual:@1] && [beacon.minor isEqual:@1]){
                index = [beacon.minor intValue];
            }else if([beacon.major isEqual:@1] && [beacon.minor isEqual:@2]){
                index = [beacon.minor intValue];
            }
            if(index == 1)
            {
                if(beacon.rssi != 0){
                    if(match==0 || match==2){
                        if(counter1<10){
                            lastTen1 += (double)[self calculateDistance:-59 andRssi:beacon.rssi];
                            counter1++;
                        }else{
                            approx1 = (lastTen1/counter1);
                            //NSLog(@"Distance1 = %.2f", approx1);
                            counter1 = 0;
                            lastTen1 = 0;
                            
                            if(match==0){
                                match=1;
                            }
                            if(match==2){
                                match=3;
                            }
                        }
                    }
                }
                //return;
            }else if(index == 2){
                if(beacon.rssi != 0){
                    if(match==0 || match==1){
                        if(counter2<10){
                            lastTen2 += (double)[self calculateDistance:-59 andRssi:beacon.rssi];
                            counter2++;
                        }else{
                            approx2 = (lastTen2/counter2);
                            //NSLog(@"Distance2 = %.2f", approx2);
                            counter2 = 0;
                            lastTen2 = 0;
                            
                            if(match==0){
                                match=2;
                            }
                            if(match==1){
                                match=3;
                            }
                        }
                    }

                }

            }
            
            if(match == 3){
                match = 0;
                
                NSLog(@"Distance1 = %.2f", approx1);
                NSLog(@"Distance2 = %.2f", approx2);

            }
                
        }
        
        
        
        /**
        
        
        self.lastProximity = nearestBeacon.proximity;
        switch(nearestBeacon.proximity) {
            case CLProximityFar:
                message = @"You are far away from the beacon";
                break;
            case CLProximityNear:
                message = @"You are near the beacon";
                break;
            case CLProximityImmediate:
                message = @"You are in the immediate proximity of the beacon";
                break;
            case CLProximityUnknown:
                return;
        }**/
    } else {
        message = @"No beacons are nearby";
    }
    
    NSLog(@"%@", message);
    [self sendLocalNotificationWithMessage:message];
}

/**
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    //IBeaconViewController *viewController = (IBeaconViewController*)self.window.rootViewController;
    IBeaconViewController *viewController = [[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0];
    
    viewController.beacons = beacons;
    [viewController.tableView reloadData];
    
    
    
    NSString *message = @"";
    
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        
        if(nearestBeacon.proximity == self.lastProximity ||
           nearestBeacon.proximity == CLProximityUnknown) {
            if(nearestBeacon.rssi != 0){
                if(counter<10){
                    last10 += (double)[self calculateDistance:-59 andRssi:nearestBeacon.rssi];
                    counter++;
                }else{
                    NSLog(@"approx distance=%.2f", (last10/counter));
                    counter = 0;
                    last10 = 0;
                }
            }
            return;
        }
        
        
        
        self.lastProximity = nearestBeacon.proximity;
        switch(nearestBeacon.proximity) {
            case CLProximityFar:
                message = @"You are far away from the beacon";
                break;
            case CLProximityNear:
                message = @"You are near the beacon";
                break;
            case CLProximityImmediate:
                message = @"You are in the immediate proximity of the beacon";
                break;
            case CLProximityUnknown:
                return;
        }
    } else {
        message = @"No beacons are nearby";
    }
    
    NSLog(@"%@", message);
    [self sendLocalNotificationWithMessage:message];
}

**/

-(double) calculateDistance: (int)txPower andRssi:(double)rssi{
    
    //return pow(10, ((double) txPower - rssi) / (10 * 2));
   
        if (rssi == 0) {
            return -1.0; // if we cannot determine accuracy, return -1.
        }
        
        double ratio = rssi*1.0/txPower;
        if (ratio < 1.0) {
            return pow(ratio, 10);
            //return Math.pow(ratio,10);
        }
        else {
            double accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
            return accuracy;
        }
    
}

/**
 
 protected static double calculateAccuracy(int txPower, double rssi) {
 if (rssi == 0) {
 return -1.0; // if we cannot determine accuracy, return -1.
 }
 
 double ratio = rssi*1.0/txPower;
 if (ratio < 1.0) {
 return Math.pow(ratio,10);
 }
 else {
 double accuracy =  (0.89976)*Math.pow(ratio,7.7095) + 0.111;
 return accuracy;
 }
 }
 **/

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"You entered the region.");
    [self sendLocalNotificationWithMessage:@"You entered the region."];
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"You exited the region.");
    [self sendLocalNotificationWithMessage:@"You exited the region."];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
