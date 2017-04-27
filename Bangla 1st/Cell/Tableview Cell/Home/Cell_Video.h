//
//  Cell_Video.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_Video : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *vwVideoContainer;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwVideoThumb;

@property (strong, nonatomic) IBOutlet UIButton *btnPlayPauseOutlet;

@property (strong, nonatomic) IBOutlet UIButton *btnMaximize;


@end
