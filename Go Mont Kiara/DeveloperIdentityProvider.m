//
//  DeveloperIdentityProvider.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//



#import <AWSCore/AWSCore.h>
#import "PingAPI.h"
#import "DeveloperIdentityProvider.h"
//#import "Session.h"
#import "AWSToken.h"
#import "Person.h"

@interface DeveloperIdentityProvider ()

@property (nonatomic, copy) NSString *awsToken;

@end

@implementation DeveloperIdentityProvider

- (AWSTask *)token
{
    return [[AWSTask taskWithResult:nil] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        return [self refresh];
    }];
}

// call to backend, called through entry point
- (AWSTask *)refresh
{
    //if (![[PingAPI sharedManager] session])
      //  return [AWSTask taskWithError:[NSError errorWithDomain:@"" code:404 userInfo:@{NSLocalizedDescriptionKey:@"unable to refresh AWS token, no valid PingAPI session."}]];
       /** return [AWSTask taskWithError:[NSError errorWithDomain:kPingErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"unable to refresh AWS token, no valid PingAPI session."}]];**/
    
    
    AWSTaskCompletionSource *task = [AWSTaskCompletionSource taskCompletionSource];
    [[PingAPI sharedManager] refreshAWSTokenWithCompletion:^(AWSToken *token, NSError *error) {
        if (error) {
            [task setError:error];
            return;
        }
        
        self.identityId = token.identityId;
        self.awsToken = token.token;
        [task setResult:self.awsToken];
        
    }];
    //return [AWSTask taskWithResult:response.token];
    return task.task;
}

// tells aws in its api call if your user is authenticated or not - this correlates with the authRoleArn and unAuthRoleArn parameters of your identity pool
- (BOOL)isAuthenticated
{
    if ([[PingAPI sharedManager] awsToken]) return YES;
    return NO;
}

// override of the clear method of the identity provider so you can clean up your custom identity provider
- (void)clear
{
    [super clear];
    self.awsToken = nil;
    self.identityId = nil;
}

@end
