//
//  PasswordTextFieldDesignable.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PasswordTextFieldDesignable : UITextField

@property (nonatomic) IBInspectable float cornerRadius;
@property (nonatomic) IBInspectable float borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGRect inset;

@end
