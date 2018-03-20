//
//  ViewController.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 25/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "ViewController.h"

#import "CAAnimation+YALTabBarViewAnimations.h"

#import "HTAaMicroservicesAccountClient.h"


@import GooglePlaces;

@interface ViewController ()




// Instantiate a pair of UILabels in Interface Builder
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;



@property (weak, nonatomic) IBOutlet UIView *pokeball;

@end

@implementation ViewController {
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
    
    int state;
    //GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    state = 1;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    _locationManager =[[CLLocationManager alloc]init];
    
    // Use either one of these authorizations **The top one gets called first and the other gets ignored
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    
    _placesClient = [GMSPlacesClient sharedClient];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // TODO(developer) Configure the sign-in button look/feel
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTouchBall:)];
    [self.pokeball addGestureRecognizer:singleFingerTap];

}

-(void)updateSignedInUser:(NSString *)email{
    _emailLabel.text = email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}



- (IBAction)queryProtectedResource:(UIButton *)sender {
    HTAaMicroservicesAccountClient *serviceClient = [HTAaMicroservicesAccountClient defaultClient];
    
    NSDictionary *headerParameters = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       };
    NSDictionary *queryParameters = @{
                                      @"email": @"testing9@gmail.com",
                                      @"customerGuid": @"260543B5-A9B2-4FEC-B1D7-C6317FE7CE5F",
                                      };
    NSDictionary *pathParameters = @{
                                     
                                     };
    
    
    AWSAPIGatewayRequest *req = [[AWSAPIGatewayRequest alloc] initWithHTTPMethod:@"GET" URLString:@"/Internal/api/account/getuserprofile" queryParameters:queryParameters headerParameters:headerParameters HTTPBody:nil];
    
    
    AWSTask *awsTask = [serviceClient invoke:req];
    [awsTask continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error != nil){
            NSLog(@"Error: %@", task.error);
        } else {
            NSData* data = [((AWSAPIGatewayResponse *)task.result) responseData];
            
            NSLog(@"dataAsString: %@", [NSString stringWithUTF8String:[data bytes]]);
            NSError *error1;
            NSMutableDictionary * innerJson = [NSJSONSerialization
                                               JSONObjectWithData:data options:kNilOptions error:&error1
                                               ];
            
            NSMutableDictionary * dataObject = innerJson[@"data"];
            NSString *firstName = dataObject[@"firstName"];
            NSString *lastName = dataObject[@"lastName"];
            //write a class to model the response
            
            NSLog(@"First Name: %@, Last Name: %@", firstName, lastName);
            
            
        }
        return nil;
    }];
    
    
    
    
    
    

    ///Internal/api/account/getuserprofile
    
    
    
    /**
    AWSTask *awsTask =[serviceClient  getJsonModelGet];
    [awsTask continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if(task.error != nil){
            NSLog(@"Error: %@", task.error);
        } else {
            NSLog(@"Result: %@", task.result);
        }
        return nil;
    }];
    **/
    
    
    
    /**
     let serviceClient = CLIFamilyMomentsClient(forKey: "anonymousAccess")
     let awsTask = serviceClient.momentsGet()
     awsTask.continueWithBlock { (task:AWSTask!) -> AnyObject! in
     if task.error != nil {
     print(task.error)
     } else {
     print(task.result)
     }
     return nil
     }
     **/
    /**
     AWSKinesisRecorder *kinesisRecorder = [AWSKinesisRecorder defaultKinesisRecorder];
     
     NSData *testData = [@"test-data" dataUsingEncoding:NSUTF8StringEncoding];
     [[[kinesisRecorder saveRecord:testData
     streamName:@"test-stream-name"] continueWithSuccessBlock:^id(AWSTask *task) {
     return [kinesisRecorder submitAllRecords];
     }] continueWithBlock:^id(AWSTask *task) {
     if (task.error) {
     NSLog(@"Error: %@", task.error);
     }
     return nil;
     }];
     **/
    
    
}


// Add a UIButton in Interface Builder to call this function
- (IBAction)getCurrentPlace:(UIButton *)sender {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                NSLog(@"name = %@", place.name);
                NSLog(@"add = %@", place.formattedAddress);
                
                NSString *theLocation = [NSString stringWithFormat:@"%f, %f", place.coordinate.latitude, place.coordinate.longitude];
                
                NSLog(@"la lo = %@", theLocation);
                
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
    }];
}



// The code snippet below shows how to create a GMSPlacePicker
// centered on Sydney, and output details of a selected place.
- (IBAction)pickPlace:(UIButton *)sender {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
    
    //CLLocationCoordinate2D center = CLLocationCoordinate2DMake(51.5108396, -0.0922251);
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
            
            
            self.nameLabel.text = place.name;
            //self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
              //                        componentsJoinedByString:@"\n"];
            self.addressLabel.text = place.formattedAddress;
            
            
        } else {
            NSLog(@"No place selected");
        }
    }];
}

- (void)tabBarDidSelectExtraLeftItem:(YALFoldingTabBar *)tabBar{
    NSLog(@"First view, left icon is pressed");
}
- (void)tabBarDidSelectExtraRightItem:(YALFoldingTabBar *)tabBar{
    NSLog(@"First view, right icon is pressed");
}




- (void) handleTouchBall:(UITapGestureRecognizer *)recognizer {
    //CAAnimation *animation = [CAAnimation animationForExtraLeftBarItem];
    
    if(state == 1){
        state = 2;
        [self.pokeball.layer addAnimation:[CAAnimation animationForCenterButtonExpand] forKey:nil];
    }else{
        state = 1;
        [self.pokeball.layer addAnimation:[CAAnimation animationForCenterButtonCollapse] forKey:nil];
    }
    
}



- (IBAction)unwindToViewController:(UIStoryboardSegue *)unwindSegue
{
}


//The event handling method
//- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];

//Do stuff here...
//}




@end
