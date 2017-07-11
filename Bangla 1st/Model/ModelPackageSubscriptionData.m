//
//  ModelPackageSubscriptionData.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 26/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelPackageSubscriptionData.h"

@implementation ModelPackageSubscriptionData

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"packageID"] && ![[dict objectForKey:@"packageID"] isKindOfClass:[NSNull class]])
        {
            self.strPackageID=[dict objectForKey:@"packageID"];
        }
        else
        {
            self.strPackageID=@"";
        }
        
        if ([dict objectForKey:@"packageDays"] && ![[dict objectForKey:@"packageDays"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionDays=[dict objectForKey:@"packageDays"];
        }
        else
        {
            self.strPackageSubscriptionDays=@"";
        }
        
        if ([dict objectForKey:@"packageVideoLimit"] && ![[dict objectForKey:@"packageVideoLimit"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionVideoLimit=[dict objectForKey:@"packageVideoLimit"];
        }
        else
        {
            self.strPackageSubscriptionVideoLimit=@"";
        }
        
        if ([dict objectForKey:@"packageTotalLimit"] && ![[dict objectForKey:@"packageTotalLimit"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionTotalLimit=[dict objectForKey:@"packageTotalLimit"];
        }
        else
        {
            self.strPackageSubscriptionTotalLimit=@"";
        }
        
        if ([dict objectForKey:@"packagePrice"] && ![[dict objectForKey:@"packagePrice"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionPrice=[dict objectForKey:@"packagePrice"];
        }
        else
        {
            self.strPackageSubscriptionPrice=@"";
        }
        
        if ([dict objectForKey:@"subscriptionStart"] && ![[dict objectForKey:@"subscriptionStart"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionStartDate=[dict objectForKey:@"subscriptionStart"];
        }
        else
        {
            self.strPackageSubscriptionStartDate=@"";
        }
        
        if ([dict objectForKey:@"subscriptionEnd"] && ![[dict objectForKey:@"subscriptionEnd"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionEndDate=[dict objectForKey:@"subscriptionEnd"];
        }
        else
        {
            self.strPackageSubscriptionEndDate=@"";
        }
        
        if ([dict objectForKey:@"watchchedVideo"] && ![[dict objectForKey:@"watchchedVideo"] isKindOfClass:[NSNull class]])
        {
            self.strPackageSubscriptionWatchedVideoCount=[dict objectForKey:@"watchchedVideo"];
        }
        else
        {
            self.strPackageSubscriptionWatchedVideoCount=@"";
        }
        
    }
    return self;
}


@end
