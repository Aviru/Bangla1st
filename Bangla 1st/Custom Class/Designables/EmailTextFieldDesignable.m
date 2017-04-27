//
//  textFieldDesignable.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 07/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "EmailTextFieldDesignable.h"

@implementation EmailTextFieldDesignable


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.borderWidth=self.borderWidth;
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.cornerRadius = self.cornerRadius;
    
   // [[self placeholder] drawInRect:rect withAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:15.0] }];
   
    NSAttributedString * stremail = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:15.0] }];
    
    self.attributedPlaceholder = stremail;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
   self.inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                            bounds.size.width - 20, bounds.size.height - 16);
    
    return self.inset;
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
