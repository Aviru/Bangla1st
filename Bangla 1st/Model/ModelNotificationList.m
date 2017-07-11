//
//  ModelNotificationList.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelNotificationList.h"

@implementation ModelNotificationList

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"id"] && ![[dict objectForKey:@"id"] isKindOfClass:[NSNull class]])
        {
            self.strNotificationID=[dict objectForKey:@"id"];
        }
        else
        {
            self.strNotificationID=@"";
        }
        
        if ([dict objectForKey:@"description"] && ![[dict objectForKey:@"description"] isKindOfClass:[NSNull class]])
        {
            self.strNotificationDescription=[dict objectForKey:@"description"];
        }
        else
        {
            self.strNotificationDescription=@"";
        }
        
        if ([dict objectForKey:@"date"] && ![[dict objectForKey:@"date"] isKindOfClass:[NSNull class]])
        {
            self.strNotificationDate=[dict objectForKey:@"date"];
        }
        else
        {
            self.strNotificationDate=@"";
        }
    }
    return self;
}


@end
