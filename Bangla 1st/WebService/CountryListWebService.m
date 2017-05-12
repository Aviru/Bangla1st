//
//  CountryListWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 23/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "CountryListWebService.h"

@implementation CountryListWebService

+(id)service
{
    static CountryListWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[CountryListWebService alloc]initWithService:WEB_SERVICES_COUNTRY_LIST];
    });
    return service;
}

-(void)callCountryListWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
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
                    successHandler(responseDict[@"ResponseData"],SUCCESS);
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
        @catch(NSException *anException)
        {
            NSLog(@"Exception in Country Listing Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Country Listing Webservice because an Exception occured."};
            
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
