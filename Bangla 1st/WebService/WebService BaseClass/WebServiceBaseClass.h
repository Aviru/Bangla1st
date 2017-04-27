//
//  WebService BaseClass.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define SOMETHING_WRONG @"Something is wrong, please try again later!"
#define NO_NETWORK @"Please check the network connection."
#define SUCCESS    @"Response successful with status code 200"
#define UNSUCCESS  @"Response unsuccessful with status code 400/401/403/500"

@interface WebServiceBaseClass : NSObject
{
@protected
    NSString *urlForService;
    AppDelegate *appDel;
    AFHTTPSessionManager *manager;
}

typedef  void(^ _Nullable success)(id _Nullable response, NSString * _Nullable strMsg);
typedef  void(^ _Nullable failure)(NSError * _Nullable error, NSString * _Nullable strMsg);

typedef NS_ENUM(NSUInteger, WEB_SERVICES) {
    
    WEB_SERVICES_SIGNUP,
    WEB_SERVICES_LOGIN,
    WEB_SERVICES_COUNTRY_LIST,
    WEB_SERVICES_USER_TYPE_LIST,
    WEB_SERVICES_CONTENT_LISTING,
    WEB_SERVICES_CATEGORY_LISTING
};


-(_Nullable id)initWithService:(WEB_SERVICES)service;

- (void)requestPostUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id  _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure;

- (void)requestGetUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id  _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure;



@end
