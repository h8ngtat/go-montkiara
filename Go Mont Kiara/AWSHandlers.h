//
//  AWSHandlers.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/08/2017.
//  Copyright © 2017 Uncover Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWSHandlers : NSObject {
    NSString *someProperty;
}

- (void)setupAWS;
- (void)invalidateAWSCredentialsAndHandlers;

@end
