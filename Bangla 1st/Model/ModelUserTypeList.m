//
//  ModelUserTypeList.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 23/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelUserTypeList.h"

@implementation ModelUserTypeList

-(id)initWithCoder:(NSCoder *)coder
{
    self=[[ModelUserTypeList alloc]init];
    if (self!=nil)
    {
        self.strCategoryID=[coder decodeObjectForKey:@"categoryID"];
        self.strCategoryTitle=[coder decodeObjectForKey:@"categoryTitle"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.strCategoryID forKey:@"categoryID"];
    [coder encodeObject:self.strCategoryTitle forKey:@"categoryTitle"];
}

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"categoryID"] && ![[dict objectForKey:@"categoryID"] isKindOfClass:[NSNull class]])
        {
            self.strCategoryID=[dict objectForKey:@"categoryID"];
        }
        else
        {
            self.strCategoryID=@"";
        }
        
        if ([dict objectForKey:@"categoryTitle"] && ![[dict objectForKey:@"categoryTitle"] isKindOfClass:[NSNull class]])
        {
            self.strCategoryTitle=[dict objectForKey:@"categoryTitle"];
        }
        else
        {
            self.strCategoryTitle=@"";
        }
    }
    return self;
}

@end
