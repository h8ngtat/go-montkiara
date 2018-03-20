//
//  Player.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 30/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject


@property NSString *name;
@property NSString *game;
@property int rating;

- (id)initWithName: (NSString*)name withGame: (NSString*)game withRating: (int)rating;

@end
