//
//  InstagramQuery.m
//  weddingplanner
//
//  Created by Hoong Tat Hiew on 7/19/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import "InstagramQuery.h"

@implementation InstagramQuery
@synthesize accessToken;



-(NSMutableDictionary*) GetUser: (NSString*) userName{
    NSString *fullURL =  [NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&access_token=%@&count=20", userName, accessToken] ;
    
    NSLog(@" GetUser url = [%@]", fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (!data) {
        NSLog(@"%s: sendSynchronousRequest error: %@", __FUNCTION__, error);
        return nil;
    } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSLog(@"%s: sendSynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
            return nil;
        }
    }
    
    
    
    NSError *parseError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (!dictionary) {
        NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        return nil;
    }
    
    NSArray* userList = [dictionary objectForKey:@"data"];
    
    //NSMutableArray* returnList = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableDictionary* returnDic = [[NSMutableDictionary alloc] initWithCapacity:10] ;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString* user_username = [obj valueForKey:@"username"];
        NSString* user_id = [obj valueForKey:@"id"];
        
        NSString* user_first_name = [obj valueForKey:@"first_name"];
        NSString* user_last_name = [obj valueForKey:@"last_name"];
        NSString* user_profile_picture = [obj valueForKey:@"profile_picture"];
        if(user_first_name==nil)
            user_first_name = @"";
        if(user_last_name==nil)
            user_last_name = @"";
        if(user_profile_picture==nil)
            user_profile_picture = @"";
        
        NSMutableDictionary* _dict =[[NSMutableDictionary alloc] initWithCapacity:4];
        [_dict setObject:user_first_name forKey:@"first_name"];
        [_dict setObject:user_last_name forKey:@"last_name"];
        [_dict setObject:user_id forKey:@"id"];
        [_dict setObject:user_profile_picture forKey:@"profile_picture"];
        
        [returnDic setObject:_dict forKey:user_username];
        
    }];
    
    return returnDic;
    
}





-(NSMutableArray*) GetPhotoByUserID: (NSString*) UserID withPhotoCount:(int)count{
    
    NSString *fullURL =  [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@&count=%d", UserID, accessToken, count] ;
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (!data) {
        NSLog(@"%s: sendSynchronousRequest error: %@", __FUNCTION__, error);
        return nil;
    } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSLog(@"%s: sendSynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
            return nil;
        }
    }
    
    
    
    NSError *parseError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (!dictionary) {
        NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        return nil;
    }
    
   // NSArray* userList = [dictionary objectForKey:@"data"];
    
    NSDictionary* photoDict = [dictionary dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"data", nil]];
    NSArray* imageArr = [photoDict objectForKey:@"data"];
    
    
    /**
    for (NSInteger p = 0; p < 12; p++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %ld", (long)p];
        [self.albums addObject:album];
    }
    **/
    NSMutableArray *returnArr = [[NSMutableArray alloc] initWithCapacity:count];
    //NSMutableDictionary *returnDict  = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    [imageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray* imageList = [obj valueForKey:@"images"];
        NSArray* lowList = [imageList valueForKey:@"low_resolution"];
        NSArray* standardList = [imageList valueForKey:@"standard_resolution"];
        NSArray* thumbnailList = [imageList valueForKey:@"thumbnail"];
        
        NSString* thumbnailURLStr = [thumbnailList valueForKey:@"url"];
        NSString* lowURLStr = [lowList valueForKey:@"url"];
        NSString* highURLStr = [standardList valueForKey:@"url"];
        
        NSURL *thumbnailURL = [[NSURL alloc]initWithString:thumbnailURLStr];
        NSURL *lowURL = [[NSURL alloc]initWithString:lowURLStr];
        NSURL *highURL = [[NSURL alloc]initWithString:highURLStr];
        
        NSMutableDictionary *itemDict  = [[NSMutableDictionary alloc] initWithCapacity:3];
        [itemDict setObject:thumbnailURL forKey:@"thumbnail"];
        [itemDict setObject:lowURL forKey:@"low_resolution"];
        [itemDict setObject:highURL forKey:@"standard_resolution"];
        
        [returnArr addObject:itemDict];
        
        
        if(idx==count-1){
            *stop=YES;
        }
    }];
    
    return returnArr;
    
}

@end
