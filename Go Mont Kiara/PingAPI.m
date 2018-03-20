//
//  PingAPI.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PingAPI.h"
#import "AWSToken.h"


@implementation PingAPI

@synthesize someProperty;
@synthesize awsToken;
@synthesize username;
@synthesize password;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static PingAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
       // NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserLoginIdSession"];
        self.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"];
        self.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerGuid"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void) refreshAWSTokenWithCompletion:(void (^)(AWSToken *, NSError *))block{
    
    //I hardcode username and password here to skip the client sign in/out process
    if(self.username == nil){
      [[NSUserDefaults standardUserDefaults] setObject:@"testing9@gmail.com" forKey:@"Email"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(self.password == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"260543b5-a9b2-4fec-b1d7-c6317fe7ce5f" forKey:@"CustomerGuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"];
    self.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerGuid"];
    
    
    
    self.username = @"testing19@gmail.com";
    self.password = @"2CA8FE53-D806-4F1E-A3DA-8B170F663E13";
    
    
    /**
    NSDictionary *dataToSend = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.username, @"email",
                                self.password, @"password",
                                @"login", @"operation", nil];
 
    **/
    NSDictionary *dataToSend = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.username, @"Email",
                                self.password, @"CustomerGuid", nil];
    
    
    
    
    
    [self placePostRequestWithURL:@"https://x21jdufsle.execute-api.ap-southeast-1.amazonaws.com/Stage/External/api/auth/gettoken"
                         withData:dataToSend
                      withHandler:^(NSURLResponse *response, NSData *rawData, NSError *error) {
                          
                          NSString *string = [[NSString alloc] initWithData:rawData
                                                                   encoding:NSUTF8StringEncoding];
                          
                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                          NSInteger code = [httpResponse statusCode];
                          NSLog(@"%ld", (long)code);
                          
                          if (!(code >= 200 && code < 300)) {
                              NSLog(@"ERROR (%ld): %@", (long)code, string);
                              [self performSelector:@selector(loginFailure:)  withObject:string];
                              
                              
                              
                          } else {
                              NSLog(@"OK");
                              
                              NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      string, @"rawjsonstr",
                                                      nil];
                              
                              
                              [self performSelector:@selector(loginDidEnd:withCallback:) withObject:result withObject:block];
                              
                          }
                      }];
    
    
}










-(void)placePostRequestWithURL:(NSString *)action withData:(NSDictionary *)dataToSend withHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error))ourBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@", action];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToSend options:0 error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSData *requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:ourBlock];
    }
}




- (void)loginDidEnd:(id)result withCallback:(void (^)(AWSToken *, NSError *))block{
    NSLog(@"loginDidEnd:");
    NSLog(@"Result: %@", result);
    
    NSString *_Str = [result objectForKey:@"rawjsonstr"];
    
    
    NSError *jsonError;
    NSData *objectData = [_Str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
   
    NSString *identityIdStr = [jsonDictionary objectForKey:@"identityId"];
    NSString *tokenStr = [jsonDictionary objectForKey:@"token"];
    
    if(awsToken == nil){
        awsToken = [[AWSToken alloc] init];
        awsToken.identityId = identityIdStr;
        awsToken.token = tokenStr;
    }
    block(awsToken, nil);
}





@end
