//
//  ARView.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 19/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ARView : UIView

@property (nonatomic) IBInspectable float borderWidth;
@property (nonatomic) IBInspectable float cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable float shadowOpacity;
@property (nonatomic) IBInspectable float shadowRadius;

@end
