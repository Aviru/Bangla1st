//
//  WebService BaseClass.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"
NSString *const strAPI[]={
    
    [WEB_SERVICES_SIGNUP] = @"userRegister.php",
    [WEB_SERVICES_LOGIN] = @"userLogin.php",
    [WEB_SERVICES_COUNTRY_LIST] = @"countryList.php",
    [WEB_SERVICES_USER_TYPE_LIST] = @"userCategoryList.php",
    [WEB_SERVICES_CONTENT_LISTING] = @"contentListing.php",
    [WEB_SERVICES_CATEGORY_LISTING] = @"categoryListing.php",
};

@implementation WebServiceBaseClass

-(id)initWithService:(WEB_SERVICES)service
{
    if (self=[super init])
    {
        urlForService=[NSString stringWithFormat:@"%@%@",BASE_URL,strAPI[service]];
        appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)requestPostUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure
{
    manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    ///NOTE:
    /* If you don't want it to do the NSJSONSerialization conversion to NSArray/NSDictionary, but rather want the raw NSData, you should set the responseSerializer of the AFURLSessionManager to a AFHTTPResponseSerializer,which is done below.
     Otherwise use manager.responseSerializer = [AFJSONResponseSerializer serializer] if you want to do the NSJSONSerialization conversion to NSArray/NSDictionary
     */

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:strURL parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Raw Response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        if(success)
        {
            success(responseObject);
        }
        
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error.localizedDescription);
        
        if(failure) {
            failure(error);
        }
        
    }];
    
}

- (void)requestGetUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure
{
    manager = [AFHTTPSessionManager manager];
   
    /*manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    */
   
    [manager GET:strURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {

         if([responseObject isKindOfClass:[NSDictionary class]])
         {
             if(success)
             {
                 success(responseObject);
             }
         }
         else
         {
             NSError *errorJsonConversion=nil;
             NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&errorJsonConversion];
             if(success) {
                 success(response);
             }
         }
         
    }
    failure:^(NSURLSessionTask *operation, NSError *error) {
       
        NSLog(@"Error: %@", error.localizedDescription);
        
        if(failure) {
            failure(error);
        }
        
    }];
}


@end
