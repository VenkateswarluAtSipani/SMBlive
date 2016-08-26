//
//  MagnifierView.m
//  StyleMyBody
//
//  Created by apple on 25/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "MagnifierView.h"

@implementation MagnifierView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) drawRect: (CGRect) rect {
    CGContextRef    context = UIGraphicsGetCurrentContext();
    CGRect          bounds = self.bounds;
    CGImageRef      mask = [UIImage imageNamed: @"loupeMask"].CGImage;
    UIImage         *glass = [UIImage imageNamed: @"loupeImage"];
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, bounds, mask);
    CGContextFillRect(context, bounds);
    CGContextScaleCTM(context, 2.0, 2.0);
    
    //draw your subject view here
    
    CGContextRestoreGState(context);
    
    [glass drawInRect: bounds];
}
@end
