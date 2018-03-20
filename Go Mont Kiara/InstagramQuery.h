//
//  InstagramQuery.h
//  weddingplanner
//
//  Created by Hoong Tat Hiew on 7/19/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramQuery : NSObject

@property (nonatomic,strong) NSString* accessToken;

-(NSMutableDictionary*) GetUser: (NSString*) userName;
-(NSMutableArray*) GetPhotoByUserID: (NSString*) UserID withPhotoCount:(int)count;
@end
