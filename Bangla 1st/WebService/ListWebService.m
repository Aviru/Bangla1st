//
//  ListWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 05/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ListWebService.h"

@implementation ListWebService

+(id)service
{
    static ListWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[ListWebService alloc]initWithService:WEB_SERVICES_CATEGORY_LISTING];
    });
    return service;
}

-(void)callListWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
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
    else
    {
        failureHandler(nil,NO_NETWORK);
    }
}

@end
