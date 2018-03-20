//
//  PhotoCollectionViewController.h
//  TabbedApplication
//
//  Created by Hoong Tat Hiew on 7/4/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramQuery.h"
@interface PhotoCollectionViewController : UICollectionViewController <UICollectionViewDataSource,
UICollectionViewDelegate, UIWebViewDelegate, UITextFieldDelegate>


@property (nonatomic, strong) InstagramQuery *instagramQuery;
-(void) loadNewPhoto: (NSMutableArray*) newPhotoArr;

@end
