//
//  LoginWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "LoginWebService.h"

@implementation LoginWebService

+(id)service
{
    static LoginWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[LoginWebService alloc]initWithService:WEB_SERVICES_LOGIN];
    });
    return service;
}

-(void)callNormalLoginWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;
{
    if (appDel.isRechable)
    {
        NSLog(@"urlService=%@",urlForService);
        
        [self requestPostUrl:urlForService parameters:dictParams success:^(id _Nullable response) {
            
            NSError *errorJsonConversion=nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&errorJsonConversion];
            
            NSLog(@"Response dictionary: %@",responseDict);
            
            if ([responseDict[@"ResponseCode"] integerValue] == 200)
            {
                successHandler(responseDict,SUCCESS);
            }
            else
            {
                successHandler(nil,UNSUCCESS);
            }
            
        }
        failure:^(NSError * _Nullable error)
         {
             failureHandler(error,SOMETHING_WRONG);
             
         }];
    }
    else
    {
        failureHandler(nil,NO_NETWORK);
    }
}


-(void)callSocialLoginWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        NSLog(@"urlService=%@",urlForService);
        
        [self requestPostUrl:urlForService parameters:dictParams success:^(id _Nullable response) {
            
            NSError *errorJsonConversion=nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&errorJsonConversion];
            
            NSLog(@"Response dictionary: %@",responseDict);
            
            if ([responseDict[@"ResponseCode"] integerValue] == 200)
            {
                successHandler(responseDict,SUCCESS);
            }
            else
            {
                successHandler(nil,UNSUCCESS);
            }
            
        }
        failure:^(NSError * _Nullable error)
         {
             failureHandler(error,SOMETHING_WRONG);
             
         }];
    }
    else
    {
        failureHandler(nil,NO_NETWORK);
    }  
}


@end
