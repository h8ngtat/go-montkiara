//
//  PingAPI.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <foundation/Foundation.h>
#import "AWSToken.h"

@interface PingAPI : NSObject {
    NSString *someProperty;
    AWSToken *awsToken;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) AWSToken *awsToken;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

+ (id)sharedManager;

- (void)refreshAWSTokenWithCompletion:(void(^)(AWSToken *token, NSError *error))block;

@end
