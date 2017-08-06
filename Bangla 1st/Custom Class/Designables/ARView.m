//
//  ARView.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 19/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ARView.h"

@implementation ARView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.borderWidth=self.borderWidth;
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.cornerRadius = self.cornerRadius;
    
   // float shadowSize = 10.0f;
   /* UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.origin.x - shadowSize / 2,
                                                                           self.frame.origin.y - shadowSize / 2,
                                                                           self.frame.size.width + shadowSize,
                                                                           self.frame.size.height + shadowSize)];
    */
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [self.shadowColor CGColor];
    self.layer.shadowOffset = self.shadowOffset; //CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = self.shadowOpacity; //0.8f;
    self.layer.shadowRadius = self.shadowRadius;
    //self.layer.shadowPath = shadowPath.CGPath;
    
}
 

@end
