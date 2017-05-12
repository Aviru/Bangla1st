//
//  ModelMemberSubscriptionDetails.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 04/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelMemberSubscriptionDetails : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strSubscriptionUserID;
@property(nonatomic,strong)NSString *strSubscriptionPackageID;
@property(nonatomic,strong)NSString *strSubscriptionPackageTitle;
@property(nonatomic,strong)NSString *strSubscriptionPackageDays;
@property(nonatomic,strong)NSString *strSubscriptionPackageVideoLimit;
@property(nonatomic,strong)NSString *strSubscriptionPackageTotalLimit;
@property(nonatomic,strong)NSString *strSubscriptionPackagePrice;
@property(nonatomic,strong)NSString *strSubscriptionStartDate;
@property(nonatomic,strong)NSString *strSubscriptionStartEnd;
@property(nonatomic,strong)NSString *strSubscriptionWatchedVideo;

@end
