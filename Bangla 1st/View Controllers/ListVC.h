//
//  ListVC.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "BaseVC.h"
#import <UIKit/UIKit.h>

@interface ListVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIImageView *ivBannerAd;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
