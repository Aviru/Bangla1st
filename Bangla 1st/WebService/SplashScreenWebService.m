//
//  SplashScreenWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 04/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "SplashScreenWebService.h"

@implementation SplashScreenWebService

+(id)service
{
    static SplashScreenWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[SplashScreenWebService alloc]initWithService:WEB_SERVICES_SPLASH_SCREEN];
    });
    return service;
}

-(void)callSplashScreenWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        NSLog(@"urlService=%@",urlForService);
        
        @try
        {
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
                    successHandler(nil,responseDict[@"message"]);
                }
                
            }
            failure:^(NSError * _Nullable error)
             {
                 failureHandler(error,SOMETHING_WRONG);
                 
             }];
        }
        @catch(NSException *anException)
        {
            NSLog(@"Exception in Splash Screen Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Splash Screen Webservice because an Exception occured."};
           
            NSError *error = [NSError errorWithDomain:WebServiceErrorDomain
                                         code:WebServiceExceptionError userInfo:userInfo];
            
            failureHandler(error,anException.reason);
        }
        
    }
    else
    {
        failureHandler(nil,NO_NETWORK);
    }
}

@end
