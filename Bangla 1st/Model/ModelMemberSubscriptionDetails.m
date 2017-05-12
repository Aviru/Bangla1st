//
//  ModelMemberSubscriptionDetails.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 04/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelMemberSubscriptionDetails.h"

@implementation ModelMemberSubscriptionDetails


-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"userID"] && ![[dict objectForKey:@"userID"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionUserID=[dict objectForKey:@"userID"];
        }
        else
        {
            self.strSubscriptionUserID=@"";
        }
        
        if ([dict objectForKey:@"packageID"] && ![[dict objectForKey:@"packageID"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackageID=[dict objectForKey:@"packageID"];
        }
        else
        {
            self.strSubscriptionPackageID=@"";
        }
        
        if ([dict objectForKey:@"packageTitle"] && ![[dict objectForKey:@"packageTitle"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackageTitle=[dict objectForKey:@"packageTitle"];
        }
        else
        {
            self.strSubscriptionPackageTitle=@"";
        }
        
        if ([dict objectForKey:@"packageDays"] && ![[dict objectForKey:@"packageDays"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackageDays=[dict objectForKey:@"packageDays"];
        }
        else
        {
            self.strSubscriptionPackageDays=@"";
        }
        
        if ([dict objectForKey:@"packageVideoLimit"] && ![[dict objectForKey:@"packageVideoLimit"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackageVideoLimit=[dict objectForKey:@"packageVideoLimit"];
        }
        else
        {
            self.strSubscriptionPackageVideoLimit=@"";
        }
        
        if ([dict objectForKey:@"packageTotalLimit"] && ![[dict objectForKey:@"packageTotalLimit"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackageTotalLimit=[dict objectForKey:@"packageTotalLimit"];
        }
        else
        {
            self.strSubscriptionPackageTotalLimit=@"";
        }
        
        if ([dict objectForKey:@"packagePrice"] && ![[dict objectForKey:@"packagePrice"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionPackagePrice=[dict objectForKey:@"packagePrice"];
        }
        else
        {
            self.strSubscriptionPackagePrice=@"";
        }
        
        if ([dict objectForKey:@"subscriptionStart"] && ![[dict objectForKey:@"subscriptionStart"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionStartDate=[dict objectForKey:@"subscriptionStart"];
        }
        else
        {
            self.strSubscriptionStartDate=@"";
        }
        
        if ([dict objectForKey:@"subscriptionEnd"] && ![[dict objectForKey:@"subscriptionEnd"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionStartEnd=[dict objectForKey:@"subscriptionEnd"];
        }
        else
        {
            self.strSubscriptionStartEnd=@"";
        }
        
        if ([dict objectForKey:@"watchchedVideo"] && ![[dict objectForKey:@"watchchedVideo"] isKindOfClass:[NSNull class]])
        {
            self.strSubscriptionWatchedVideo=[dict objectForKey:@"watchchedVideo"];
        }
        else
        {
            self.strSubscriptionWatchedVideo=@"";
        }
    }
    return self;
}

@end
