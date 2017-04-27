//
//  NavigationBar.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBar : UIView

@property (weak, nonatomic) IBOutlet UILabel *navBarLabelHeadingTitle;
@property (weak, nonatomic) IBOutlet UILabel *navBarRightLabel;
@property (strong, nonatomic) IBOutlet UILabel *navBarLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *navBarLeftButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *navBarRightButtonOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *navBarRightImage;
@property (weak, nonatomic) IBOutlet UIImageView *navBarLeftImage;

@end
