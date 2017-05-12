//
//  ModelCouponData.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 12/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelCouponData.h"

@implementation ModelCouponData

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"couponCode"] && ![[dict objectForKey:@"couponCode"] isKindOfClass:[NSNull class]])
        {
            self.strCouponCode=[dict objectForKey:@"couponCode"];
        }
        else
        {
            self.strCouponCode=@"";
        }
        
        if ([dict objectForKey:@"packageDays"] && ![[dict objectForKey:@"packageDays"] isKindOfClass:[NSNull class]])
        {
            self.strCouponPackageDays=[dict objectForKey:@"packageDays"];
        }
        else
        {
            self.strCouponPackageDays=@"";
        }
        
        if ([dict objectForKey:@"packageVideoLimit"] && ![[dict objectForKey:@"packageVideoLimit"] isKindOfClass:[NSNull class]])
        {
            self.strCouponPackageVideoLimit=[dict objectForKey:@"packageVideoLimit"];
        }
        else
        {
            self.strCouponPackageVideoLimit=@"";
        }
        
        if ([dict objectForKey:@"packageTotalLimit"] && ![[dict objectForKey:@"packageTotalLimit"] isKindOfClass:[NSNull class]])
        {
            self.strCouponPackageTotalLimit=[dict objectForKey:@"packageTotalLimit"];
        }
        else
        {
            self.strCouponPackageTotalLimit=@"";
        }
        
        if ([dict objectForKey:@"packagePrice"] && ![[dict objectForKey:@"packagePrice"] isKindOfClass:[NSNull class]])
        {
            self.strCouponPackagePrice=[dict objectForKey:@"packagePrice"];
        }
        else
        {
            self.strCouponPackagePrice=@"";
        }
        
        if ([dict objectForKey:@"subscriptionStart"] && ![[dict objectForKey:@"subscriptionStart"] isKindOfClass:[NSNull class]])
        {
            self.strCouponSubscriptionStartDate=[dict objectForKey:@"subscriptionStart"];
        }
        else
        {
            self.strCouponSubscriptionStartDate=@"";
        }
        
        if ([dict objectForKey:@"subscriptionEnd"] && ![[dict objectForKey:@"subscriptionEnd"] isKindOfClass:[NSNull class]])
        {
            self.strCouponSubscriptionEndDate=[dict objectForKey:@"subscriptionEnd"];
        }
        else
        {
            self.strCouponSubscriptionEndDate=@"";
        }
        
        if ([dict objectForKey:@"watchchedVideo"] && ![[dict objectForKey:@"watchchedVideo"] isKindOfClass:[NSNull class]])
        {
            self.strCouponWatchedVideoCount=[dict objectForKey:@"watchchedVideo"];
        }
        else
        {
            self.strCouponWatchedVideoCount=@"";
        }
        
    }
    return self;
}

@end
