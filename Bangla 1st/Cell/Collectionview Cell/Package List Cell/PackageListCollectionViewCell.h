//
//  PackageListCollectionViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) IBOutlet UILabel *lblPackageName;

@property (strong, nonatomic) IBOutlet UILabel *lblPackagePrice;

@property (strong, nonatomic) IBOutlet UILabel *lblValidity;

@property (strong, nonatomic) IBOutlet UILabel *lblVideoWatchLimit;

@property (strong, nonatomic) IBOutlet UILabel *lblTotalLimit;

@property (strong, nonatomic) IBOutlet UILabel *lblPackageStatus;


@end
