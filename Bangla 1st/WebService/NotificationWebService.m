//
//  NotificationWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "NotificationWebService.h"

@implementation NotificationWebService

+(id)service
{
    static NotificationWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[NotificationWebService alloc]initWithService:WEB_SERVICES_NOTIFICATIONLIST];
    });
    return service;
}

-(void)callNotificationListWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
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
            NSLog(@"Exception in Notification List Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Notification List Webservice because an Exception occured."};
            
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
