//
//  CustomDropMenu.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 09/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "BaseVC.h"
#import "ModelList.h"
#import "DropDownTableViewCell.h"

@protocol CustomDropMenuDelegate <NSObject>

@optional
- (void)didSelectDotsButtonAtIndexPath:(NSIndexPath*)indexPath dropDownSelctedCell:(DropDownTableViewCell *)dropDwnCell;

@end

@interface CustomDropMenu : BaseVC

@property (weak, nonatomic) id<CustomDropMenuDelegate> delegate;

@end
