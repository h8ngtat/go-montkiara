//
//  AWSToken.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

/**
	{
 "id": "us-east-1:xxxxx",
 "token": "xxxxx",
 "region": "us-east-1",
 "identityPoolId": "us-east-1:xxxxx",
 "loginProvider": "xxxxx"
	}
**/


@interface AWSToken : NSObject {
    NSString *identityId;
    NSString *token;
    NSString *region;
    NSString *identityPoolId;
    NSString *loginProvider;
}

@property (nonatomic, retain) NSString *identityId;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, retain) NSString *identityPoolId;
@property (nonatomic, retain) NSString *loginProvider;



@end
