//
//  ModelGateway.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelGateway.h"

@implementation ModelGateway

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:MERCHENT_KEY] && ![[dict objectForKey:MERCHENT_KEY] isKindOfClass:[NSNull class]])
        {
            self.strMerchentKey=[dict objectForKey:MERCHENT_KEY];
        }
        else
        {
            self.strMerchentKey=@"";
        }
        
        if ([dict objectForKey:MERCHENT_SECRET] && ![[dict objectForKey:MERCHENT_SECRET] isKindOfClass:[NSNull class]])
        {
            self.strMerchentSecret=[dict objectForKey:MERCHENT_SECRET];
        }
        else
        {
            self.strMerchentSecret=@"";
        }
        
        if ([dict objectForKey:@"returnUrl"] && ![[dict objectForKey:@"returnUrl"] isKindOfClass:[NSNull class]])
        {
            self.strReturnURL=[dict objectForKey:@"returnUrl"];
        }
        else
        {
            self.strReturnURL=@"";
        }
    }
    return self;
}


@end
