//
//  Cell_List.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 19/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_List : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblVidName;
@property (weak, nonatomic) IBOutlet UILabel *lblVidDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblVidInfo;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage;
@property (strong, nonatomic) IBOutlet UIView *VwDropDowncontainer;

@property (strong, nonatomic) IBOutlet UIButton *btndotsOutlet;

@property (strong, nonatomic) IBOutlet UIView *VwProgressContainer;

@property (strong, nonatomic) IBOutlet UIProgressView *progressVw;

@property (strong, nonatomic) IBOutlet UIView *VwBgContainer;


@end
