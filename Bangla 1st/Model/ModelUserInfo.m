//
//  ModelUserInfo.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelUserInfo.h"

@implementation ModelUserInfo

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:USERID] && ![[dict objectForKey:USERID] isKindOfClass:[NSNull class]])
        {
            self.strUserId=[dict objectForKey:USERID];
        }
        else
        {
            self.strUserId=@"";
        }
        
        if ([dict objectForKey:@"UserCategory"] && ![[dict objectForKey:@"UserCategory"] isKindOfClass:[NSNull class]])
        {
            self.strUserCategory=[dict objectForKey:@"UserCategory"];
        }
        else
        {
            self.strUserCategory=@"";
        }
        
        if ([dict objectForKey:USERNAME] && ![[dict objectForKey:USERNAME] isKindOfClass:[NSNull class]])
        {
            self.strUserName=[dict objectForKey:USERNAME];
        }
        else
        {
            self.strUserName=@"";
        }
        
        if ([dict objectForKey:EMAIL] && ![[dict objectForKey:EMAIL] isKindOfClass:[NSNull class]])
        {
            self.strUserEmail=[dict objectForKey:EMAIL];
        }
        else
        {
            self.strUserEmail=@"";
        }
        
        if ([dict objectForKey:@"UserStatus"] && ![[dict objectForKey:@"UserStatus"] isKindOfClass:[NSNull class]])
        {
            self.strUserStatus=[dict objectForKey:@"UserStatus"];
        }
        else
        {
            self.strUserStatus=@"";
        }
        
        if ([dict objectForKey:@"Sex"] && ![[dict objectForKey:@"Sex"] isKindOfClass:[NSNull class]])
        {
            self.strUserSex=[dict objectForKey:@"Sex"];
        }
        else
        {
            self.strUserSex=@"";
        }
        
        if ([dict objectForKey:@"Dob"] && ![[dict objectForKey:@"Dob"] isKindOfClass:[NSNull class]])
        {
            self.strUserDob=[dict objectForKey:@"Dob"];
        }
        else
        {
            self.strUserSex=@"";
        }
        
        if ([dict objectForKey:@"Country"] && ![[dict objectForKey:@"Country"] isKindOfClass:[NSNull class]])
        {
            self.strUserCountry=[dict objectForKey:@"Country"];
        }
        else
        {
            self.strUserCountry=@"";
        }
        
        if ([dict objectForKey:PROFILE_IMAGE] && ![[dict objectForKey:PROFILE_IMAGE] isKindOfClass:[NSNull class]])
        {
            self.strUserProfileImageUrl=[dict objectForKey:PROFILE_IMAGE];
        }
        else
        {
            self.strUserProfileImageUrl=@"";
        }
        
    }
    return self;
}


@end
