//
//  EditProfileWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "EditProfileWebService.h"

@implementation EditProfileWebService

+(id)service
{
    static EditProfileWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[EditProfileWebService alloc]initWithService:WEB_SERVICES_EDIT_PROFILE];
    });
    return service;
}

-(void)callEditProfileWebServiceWithDictParams:(NSDictionary *)dictParams profileImage:(UIImage *)img success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        NSLog(@"urlService=%@",urlForService);
        
        @try
        {
            [self requestPostWithImageUrl:urlForService parameters:dictParams image:img success:^(id  _Nullable response) {
                
                /*
                 NSError *errorJsonConversion=nil;
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&errorJsonConversion];
                 */
                
                NSDictionary *responseDict = (NSDictionary *)response;
                
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
            NSLog(@"Exception in Edit Profile Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Edit Profile Webservice because an Exception occured."};
            
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
