//
//  Player.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 30/08/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "Player.h"

@implementation Player


- (id)init
{
    self = [super init];
    if (self)
    {
        _name = @"Hiew Hoong Tat";
        _game = @"Pokemon Go";
        _rating = 3;
        // superclass successfully initialized, further
        // initialization happens here ...
    }
    return self;
}

- (id)initWithName:(NSString *)name withGame:(NSString *)game withRating:(int)rating
{
    self = [super init];
    if (self)
    {
        _name = name;
        _game = game;
        _rating = rating;
    }
    return self;
}

@end
