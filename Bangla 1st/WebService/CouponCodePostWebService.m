//
//  CouponCodePostWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 13/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "CouponCodePostWebService.h"

@implementation CouponCodePostWebService

+(id)service
{
    static CouponCodePostWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[CouponCodePostWebService alloc]initWithService:WEB_SERVICES_COUPON_CODE_POST];
    });
    return service;
}

-(void)callCouponCodePostWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
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
            NSLog(@"Exception in Coupon Code Post Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute  Coupon Code Post Webservice because an Exception occured."};
            
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
