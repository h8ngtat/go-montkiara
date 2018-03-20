//
//  LoginViewController.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 11/01/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

#import "Person.h"

@interface LoginViewController : UIViewController <GIDSignInUIDelegate>

@property (weak, nonatomic) RLMNotificationToken *notificationToken;

-(void)updateSignedInUserPhoneNo:(NSString *)phoneNo;


@end
