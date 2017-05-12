//
//  PackageListCollectionViewCell.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "PackageListCollectionViewCell.h"

@implementation PackageListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_containerView.layer setCornerRadius:3.0f];
    
    // border
    [_containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_containerView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [_containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_containerView.layer setShadowOpacity:0.4];
    [_containerView.layer setShadowRadius:1.0];
    [_containerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];

}

@end
