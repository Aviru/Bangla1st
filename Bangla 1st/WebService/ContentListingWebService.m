//
//  ContentListingWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ContentListingWebService.h"

@implementation ContentListingWebService

+(id)service
{
    static ContentListingWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[ContentListingWebService alloc]initWithService:WEB_SERVICES_CONTENT_LISTING];
    });
    return service;
}

-(void)callContentListingWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
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
            NSLog(@"Exception in Content Listing Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Content Listing Webservice because an Exception occured."};
            
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

-(void)callIMAadWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        NSString *strIMAadURL = [NSString stringWithFormat:@"%@%@",BASE_URL,API_PlayerAdvertisment];
        
        NSLog(@"urlService=%@",strIMAadURL);
        
        [self requestPostUrl:strIMAadURL parameters:dictParams success:^(id _Nullable response) {
            
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
