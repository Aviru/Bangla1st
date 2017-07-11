//
//  AboutUsAndT&CWebService.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 11/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "AboutUsAndT&CWebService.h"

@implementation AboutUsAndT_CWebService

+(id)service
{
    static AboutUsAndT_CWebService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service=[[AboutUsAndT_CWebService alloc]init];
    });
    return service;
}
#pragma mark -
#pragma mark Private Initialization
- (id)init
{
    self = [super init];
    
    if (self) {
        
        appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)callAboutUsWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        urlForService = [NSString stringWithFormat:@"%@%@",BASE_URL,@"cms.php"];
        
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
            NSLog(@"Exception in About Us Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute About Us Webservice because an Exception occured."};
            
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


-(void)callTermsAndConditionWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        urlForService = [NSString stringWithFormat:@"%@%@",BASE_URL,@"cms.php"];
        
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
            NSLog(@"Exception in Terms And Condition Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Terms And Condition Webservice because an Exception occured."};
            
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

-(void)callPrivacyPolicyWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler
{
    if (appDel.isRechable)
    {
        urlForService = [NSString stringWithFormat:@"%@%@",BASE_URL,@"cms.php"];
        
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
            NSLog(@"Exception in Privacy Policy Webservice:%@",anException);
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not execute Privacy Policy Webservice because an Exception occured."};
            
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
