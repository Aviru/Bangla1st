//
//  ARButton.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 19/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ARButton.h"

@implementation ARButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.borderWidth=self.borderWidth;
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.cornerRadius = self.cornerRadius;
}
 

@end
