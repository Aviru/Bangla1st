//
//  ModelIMAad.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 02/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelIMAad.h"

@implementation ModelIMAad


-(id)initWithCoder:(NSCoder *)coder{
    self=[[ModelIMAad alloc]init];
    
    if (self!=nil) {
        self.strIMAadId=[coder decodeObjectForKey:@"adID"];
        self.strIMAadTagURL=[coder decodeObjectForKey:@"adTag"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.strIMAadId forKey:@"adID"];
    [coder encodeObject:self.strIMAadTagURL forKey:@"adTag"];
}


-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"adID"] && ![[dict objectForKey:@"adID"] isKindOfClass:[NSNull class]])
        {
            self.strIMAadId=[dict objectForKey:@"adID"];
        }
        else
        {
            self.strIMAadId=@"";
        }
        
        if ([dict objectForKey:@"adTag"] && ![[dict objectForKey:@"adTag"] isKindOfClass:[NSNull class]])
        {
            self.strIMAadTagURL=[dict objectForKey:@"adTag"];
        }
        else
        {
           self.strIMAadTagURL=@"";
        }
    }
    return self;
}


@end
