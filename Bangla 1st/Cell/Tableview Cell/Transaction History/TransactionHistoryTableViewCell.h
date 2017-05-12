//
//  TransactionHistoryTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) IBOutlet UILabel *lblPaymentGateWayName;

@property (strong, nonatomic) IBOutlet UILabel *lblTransactionID;

@property (strong, nonatomic) IBOutlet UILabel *lblTransactionStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblTransactionAmount;

@property (strong, nonatomic) IBOutlet UILabel *lblTransactionDetails;

@property (strong, nonatomic) IBOutlet UILabel *lblDuration;


@end
