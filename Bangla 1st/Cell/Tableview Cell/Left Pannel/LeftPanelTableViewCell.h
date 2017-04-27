//
//  LeftPanelTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 25/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftPanelTableViewCell : UITableViewCell

////FIRST CELL
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwMenuIcon;

///SECOND CELL
@property (strong, nonatomic) IBOutlet UILabel *lblSecondCellName;


///USER PROFILE CELL
@property (strong, nonatomic) IBOutlet UIImageView *imgVwUserPic;

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@end
