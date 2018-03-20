//
//  Pokeball.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 06/09/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "Pokeball.h"


@implementation Pokeball

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //NSLog(@"------->Initialization");
        //self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0] setFill];
    UIRectFill(rect);
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2)];
    
    UIColor *baseColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    
    //[baseColor setStroke];
    [baseColor setFill];
    //[path stroke];
    [path fill];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x+4, rect.origin.y+4, rect.size.width-8, rect.size.height-8)];
    
    
    [path fill];
    [path fill];
    
    
    
    
    CGContextSaveGState(context);
    
    UIBezierPath *clipPath = [[UIBezierPath alloc] init];
    [clipPath moveToPoint:CGPointMake(rect.origin.x, rect.size.height/2)];
    CGPoint nextPoint = CGPointMake(rect.origin.x + rect.size.width, rect.size.height/2 );
    [clipPath addLineToPoint:nextPoint];
    //[clipPath moveToPoint:nextPoint];
    
    nextPoint = CGPointMake(rect.origin.x + rect.size.width, rect.size.height);
    [clipPath addLineToPoint:nextPoint];
    //[clipPath moveToPoint:nextPoint];
    
    
    nextPoint = CGPointMake(rect.origin.x, rect.size.height);
    [clipPath addLineToPoint:nextPoint];
   // [clipPath moveToPoint:nextPoint];
    
    
    
    nextPoint = CGPointMake(rect.origin.x, rect.size.height/2);
    [clipPath addLineToPoint:nextPoint];
    
    [clipPath closePath];
    [clipPath addClip];
    
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2)];
    
    
    baseColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [baseColor setFill];
    [path fill];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x+4, rect.origin.y+4, rect.size.width-8, rect.size.height-8)];
    

    [UIColor.whiteColor setFill];
    //[UIColor.whiteColor setStroke];
    [path fill];
    
    
    
    CGContextRestoreGState(context);
    
    
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + rect.size.width/3,
                                                             rect.origin.y + rect.size.height/3,
                                                             rect.size.width/3,
                                                             rect.size.height/3)];
    
    [UIColor.whiteColor setFill];
    [path fill];

    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + rect.size.width/3+2,
                                                             rect.origin.y + rect.size.height/3+2,
                                                             rect.size.width/3-4,
                                                             rect.size.height/3-4)];
    
    [UIColor.lightGrayColor setFill];
    [path fill];
    
    
}


@end
