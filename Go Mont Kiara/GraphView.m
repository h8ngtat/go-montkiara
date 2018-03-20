//
//  GraphView.m
//  Go Mont Kiara
//
//  Created by Lu Ping Tan on 03/09/2016.
//  Copyright © 2016 Uncover Technology. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    _startColor = UIColor.redColor;
    _endColor = UIColor.greenColor;
    _graphPoints = [[NSMutableArray alloc] initWithArray:@[@4, @2, @6, @4, @5, @8, @3, @7]];
}



-(void) drawRect:(CGRect)rect
{
   // if(_graphPoints == nil)
     //   _graphPoints = [[NSMutableArray alloc] initWithArray:@[@4,@2,@6, @4, @5, @8, @3]];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
    [path addClip];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(colorArray, _startColor.CGColor);
    CFArrayAppendValue(colorArray, _endColor.CGColor);

    
    CGFloat colorLocations[] = { 0.0f, 1.0f };
    
    CGGradientRef gradient = CGGradientCreateWithColors(space, colorArray, colorLocations);
    
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, self.bounds.size.height);
   
 
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
 
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat margin = 20.0;
    
    
  
    // Declare the block variable
    CGFloat (^columnXPoint)(int column);
    
    
    // Create and assign the block
    columnXPoint = ^CGFloat(int column) {
        CGFloat spacer = (width - margin*2 - 4) / (_graphPoints.count - 1);
        CGFloat x = column * spacer;
        x += margin + 2;
        return x;
    };
    
    CGFloat topBorder = 60;
    CGFloat bottomBorder = 50;
    
    CGFloat graphHeight = height - topBorder - bottomBorder;
    
    //NSNumber* max = [_graphPoints valueForKeyPath:"@max.self"];
    //CGFloat maxValue = [max floatValue];
    
    float xmax = -MAXFLOAT;
    float xmin = MAXFLOAT;
    for (NSNumber *num in _graphPoints) {
        float x = num.floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    
    CGFloat (^columnYPoint)(int column);
    // Create and assign the block
    columnYPoint = ^CGFloat(int graphPoint) {
        CGFloat y = ((CGFloat)graphPoint / xmax) * graphHeight;
        y = graphHeight + topBorder - y;
        return y;
    };
    
    [UIColor.whiteColor setFill];
    [UIColor.whiteColor setStroke];
    
    UIBezierPath *graphPath = [[UIBezierPath alloc] init];
    [graphPath moveToPoint:CGPointMake(columnXPoint(0), columnYPoint([_graphPoints[0] intValue]))];
  
    /**
    [graphPath moveToPoint:CGPointMake(20,20)];
    CGPoint nextPoint = CGPointMake(60,60);
    [graphPath addLineToPoint:nextPoint];
     **/
    for(NSUInteger i=1; i<_graphPoints.count; i++){
        CGPoint nextPoint = CGPointMake(columnXPoint((CGFloat)i),columnYPoint([_graphPoints[i] intValue]));
        [graphPath addLineToPoint:nextPoint];
    }
    [graphPath stroke];
    
    
    CGContextSaveGState(context);
    //2 - make a copy of the path
    UIBezierPath *clippingPath = [graphPath copy];
    
    [clippingPath addLineToPoint:CGPointMake(columnXPoint((CGFloat)_graphPoints.count - 1),height)];
    [clippingPath addLineToPoint:CGPointMake(columnXPoint((CGFloat)0),height)];
    [clippingPath closePath];
    [clippingPath addClip];
   
    
    //5 - check clipping path - temporary code
    //[UIColor.greenColor setFill];
 
    
    //UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
   // [rectPath fill];
    
    
    CGFloat highestYPoint = columnYPoint(xmax);
    startPoint = CGPointMake(margin, highestYPoint);
    endPoint = CGPointMake(margin, height);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    
    graphPath.lineWidth=2.0;
    [graphPath stroke];

    for(NSUInteger i=0; i<_graphPoints.count; i++){
        CGPoint point = CGPointMake(columnXPoint((CGFloat)i),columnYPoint([_graphPoints[i] intValue]));
        point.x -= 5.0/2;
        point.y -= 5.0/2;
        
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(point.x, point.y, 5.0, 5.0)];
        [circle fill];
    }
    
    
    
    UIBezierPath *linePath = [[UIBezierPath alloc]init];
    
    [linePath moveToPoint:CGPointMake(margin, topBorder)];
    [linePath addLineToPoint:CGPointMake(width-margin, topBorder)];
    
    [linePath moveToPoint:CGPointMake(margin, graphHeight/2 +topBorder)];
    [linePath addLineToPoint:CGPointMake(width-margin, graphHeight/2 +topBorder)];
    
    [linePath moveToPoint:CGPointMake(margin, height - bottomBorder)];
    [linePath addLineToPoint:CGPointMake(width-margin, height -  bottomBorder)];
    
    UIColor *lineColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [lineColor setStroke];
    
    linePath.lineWidth=1.0;
    [linePath stroke];
    
    
    NSString *labelText = [NSString stringWithFormat:@"%d", 6];
    UIFont *font = [UIFont boldSystemFontOfSize:36];
    [[UIColor whiteColor] set];
    //[labelText drawCenteredInRect:self.bounds withFont:font];
    //CGSize size = [labelText sizeWithFont:font];
    NSDictionary *textDict = [NSDictionary dictionaryWithObject:font forKey:@"font"];
    
    CGSize size = [labelText sizeWithAttributes:textDict];

    
    CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
                                   rect.origin.y + (rect.size.height - size.height) / 2,
                                   size.width, size.height);
   // [labelText drawInRect:textBounds withFont:font];
    [labelText drawInRect:textBounds withAttributes:textDict];

    
    
    
   // [clipPath addLineToPoint:CGPointMake(rect.origin.y + (rect.size.height/2), rect.size.width)];
    
    
    
    
}

@end
