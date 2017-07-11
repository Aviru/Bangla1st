//
//  TransactionHistoryTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) IBOutlet UILabel *lblNotificationDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblNotificationID;

@property (strong, nonatomic) IBOutlet UILabel *lblNotificationDate;

@end
