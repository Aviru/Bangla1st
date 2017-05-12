//
//  ModelCouponData.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 12/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelCouponData : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strCouponCode;
@property(nonatomic,strong)NSString *strCouponPackageDays;
@property(nonatomic,strong)NSString *strCouponPackageVideoLimit;
@property(nonatomic,strong)NSString *strCouponPackageTotalLimit;
@property(nonatomic,strong)NSString *strCouponPackagePrice;
@property(nonatomic,strong)NSString *strCouponSubscriptionStartDate;
@property(nonatomic,strong)NSString *strCouponSubscriptionEndDate;
@property(nonatomic,strong)NSString *strCouponWatchedVideoCount;

@end
