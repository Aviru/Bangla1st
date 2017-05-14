//
//  JustForYouTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 16/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JustForYouTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblVideoTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblVideoDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblPostedTimeAndViews;

@property (strong, nonatomic) IBOutlet UIView *containerVw;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwThumbImage;

@property (strong, nonatomic) IBOutlet UIButton *btnDeleteOutlet;

@end
