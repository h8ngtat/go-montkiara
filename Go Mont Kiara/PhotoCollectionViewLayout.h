//
//  PhotoCollectionViewLayout.h
//  TabbedApplication
//
//  Created by Hoong Tat Hiew on 7/4/14.
//  Copyright (c) 2014 Hoong Tat Hiew. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface PhotoCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic,strong) NSMutableDictionary *layoutInfo;

@property (nonatomic,strong) NSMutableArray *lastPhoto;

@end
