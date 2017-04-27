//
//  CollectionCell_Video.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell_Video : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblVidName;
@property (weak, nonatomic) IBOutlet UIImageView *ivAd;

@property (strong, nonatomic) IBOutlet UIButton *btnThreedotsOutlet;
@property (strong, nonatomic) IBOutlet UIButton *btnVideoPlayOutlet;

@end
