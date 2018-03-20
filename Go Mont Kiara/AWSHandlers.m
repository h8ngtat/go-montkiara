//
//  AWSHandlers.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "AWSHandlers.h"
#import "DeveloperIdentityProvider.h"
#import "AWSCore.h"

@interface AWSHandlers ()

@property (nonatomic, strong) AWSCognitoCredentialsProvider *awsCredentialsProvider;

@end

@implementation AWSHandlers

- (void)setupAWS
{
    // instantiate our custom identity provider
    DeveloperIdentityProvider *devIdentityProvider =
    [[DeveloperIdentityProvider alloc] initWithRegionType:AWSRegionAPSoutheast1
                                identityPoolId:@"ap-southeast-1:8c4e4704-2be2-45f8-bbe1-24841bb8bf93"
                                useEnhancedFlow:YES
                             identityProviderManager:nil];
    
    // instantiate the credentials provider with our custom identity provider
    self.awsCredentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionAPSoutheast1 identityProvider:devIdentityProvider];
    
    AWSServiceConfiguration *defaultAWSConfig = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSoutheast1 credentialsProvider:self.awsCredentialsProvider];
    
    [[AWSServiceManager defaultServiceManager] setDefaultServiceConfiguration:defaultAWSConfig];
    
    
    // setup a s3 transfer manager
    //self.s3TransferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    // change the verbosity level of the aws sdk if you choose
    //[AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
}

// call on app logout AND login! If not, cached credentials which may or may not be valid can be used during an app reinstall, or first loading of your app (not resuming from background)

- (void)invalidateAWSCredentialsAndHandlers
{
    //[self cancelAllCurrentS3Operations];
    [self.awsCredentialsProvider clearKeychain];
    self.awsCredentialsProvider = nil;
   // self.s3TransferManager = nil;
}

@end
