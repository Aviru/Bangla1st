//
//  ModelCountryList.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 23/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelCountryList.h"

@implementation ModelCountryList

-(id)initWithCoder:(NSCoder *)coder
{
    self=[[ModelCountryList alloc]init];
    if (self!=nil)
    {
        self.strCountryCode=[coder decodeObjectForKey:@"countryCode"];
        self.strCountryName=[coder decodeObjectForKey:@"countryName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.strCountryCode forKey:@"countryCode"];
    [coder encodeObject:self.strCountryName forKey:@"countryName"];
}

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"countryCode"] && ![[dict objectForKey:@"countryCode"] isKindOfClass:[NSNull class]])
        {
            self.strCountryCode=[dict objectForKey:@"countryCode"];
        }
        else
        {
            self.strCountryCode=@"";
        }
        
        if ([dict objectForKey:@"countryName"] && ![[dict objectForKey:@"countryName"] isKindOfClass:[NSNull class]])
        {
            self.strCountryName=[dict objectForKey:@"countryName"];
        }
        else
        {
            self.strCountryName=@"";
        }
    }
    return self;
}

@end
