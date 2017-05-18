//
//  ModelUserInfo.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelUserInfo : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strUserCategory;
@property(nonatomic,strong)NSString *strUserIsSubscribed;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strUserEmail;
@property(nonatomic,strong)NSString *strUserStatus;
@property(nonatomic,strong)NSString *strUserSex;
@property(nonatomic,strong)NSString *strUserDob;
@property(nonatomic,strong)NSString *strUserCountry;
@property(nonatomic,strong)NSString *strUserCountryCode;
@property(nonatomic,strong)NSString *strUserProfileImageUrl;

@end
