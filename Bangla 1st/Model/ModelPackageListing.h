//
//  ModelPackageListing.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelPackageListing : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strPackageID;
@property(nonatomic,strong)NSString *strPackageTitle;
@property(nonatomic,strong)NSString *strPackageType;
@property(nonatomic,strong)NSString *strPackageDays;
@property(nonatomic,strong)NSString *strPackageVideoLimit;
@property(nonatomic,strong)NSString *strPackageTotalLimit;
@property(nonatomic,strong)NSString *strPackagePrice;
@property(nonatomic,strong)NSString *strPackageStatus;
@property(nonatomic,strong)NSString *strPackageIsSubscribed;


@end
