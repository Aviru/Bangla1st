//
//  ModelPackageSubscriptionData.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 26/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelPackageSubscriptionData : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strPackageID;
@property(nonatomic,strong)NSString *strPackageSubscriptionDays;
@property(nonatomic,strong)NSString *strPackageSubscriptionVideoLimit;
@property(nonatomic,strong)NSString *strPackageSubscriptionTotalLimit;
@property(nonatomic,strong)NSString *strPackageSubscriptionPrice;
@property(nonatomic,strong)NSString *strPackageSubscriptionStartDate;
@property(nonatomic,strong)NSString *strPackageSubscriptionEndDate;
@property(nonatomic,strong)NSString *strPackageSubscriptionWatchedVideoCount;

@end
