//
//  ModelPackageListing.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelPackageListing.h"

@implementation ModelPackageListing

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
        
        if ([dict objectForKey:@"packageTitle"] && ![[dict objectForKey:@"packageTitle"] isKindOfClass:[NSNull class]])
        {
            self.strPackageTitle=[dict objectForKey:@"packageTitle"];
        }
        else
        {
            self.strPackageTitle=@"";
        }
        
        if ([dict objectForKey:@"packageType"] && ![[dict objectForKey:@"packageType"] isKindOfClass:[NSNull class]])
        {
            self.strPackageType=[dict objectForKey:@"packageType"];
        }
        else
        {
            self.strPackageType=@"";
        }
       
        if ([dict objectForKey:@"packageDays"] && ![[dict objectForKey:@"packageDays"] isKindOfClass:[NSNull class]])
        {
            self.strPackageDays=[dict objectForKey:@"packageDays"];
        }
        else
        {
            self.strPackageDays=@"";
        }
        
        if ([dict objectForKey:@"packageVideo"] && ![[dict objectForKey:@"packageVideo"] isKindOfClass:[NSNull class]])
        {
            self.strPackageVideoLimit=[dict objectForKey:@"packageVideo"];
        }
        else
        {
            self.strPackageVideoLimit=@"";
        }
        
        if ([dict objectForKey:@"packageTotal"] && ![[dict objectForKey:@"packageTotal"] isKindOfClass:[NSNull class]])
        {
            self.strPackageTotalLimit=[dict objectForKey:@"packageTotal"];
        }
        else
        {
            self.strPackageTotalLimit=@"";
        }
        
        if ([dict objectForKey:@"packagePrice"] && ![[dict objectForKey:@"packagePrice"] isKindOfClass:[NSNull class]])
        {
            self.strPackagePrice=[dict objectForKey:@"packagePrice"];
        }
        else
        {
            self.strPackagePrice=@"";
        }
        
            if ([dict objectForKey:@"is_default"] && ![[dict objectForKey:@"is_default"] isKindOfClass:[NSNull class]])
            {
                self.strPackageStatus=[dict objectForKey:@"is_default"];
            }
            else
            {
                self.strPackageStatus=@"";
            }
        
            if ([dict objectForKey:@"is_subsribed"] && ![[dict objectForKey:@"is_subsribed"] isKindOfClass:[NSNull class]])
            {
                self.strPackageIsSubscribed = [dict objectForKey:@"is_subsribed"];
            }
            else
            {
                self.strPackageIsSubscribed = @"";
            }
       
    }
    return self;
}

@end
