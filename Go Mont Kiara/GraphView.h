//
//  GraphView.h
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 03/09/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GraphView : UIView

//1 - the properties for the gradient
//@IBInspectable var startColor: UIColor = UIColor.redColor()
//@IBInspectable var endColor: UIColor = UIColor.greenColor()
@property (nonatomic)  IBInspectable UIColor *startColor;
@property (nonatomic)  IBInspectable UIColor *endColor;

@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable NSInteger borderHeight;
@property (nonatomic) NSMutableArray *graphPoints;

@end
