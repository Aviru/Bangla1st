//
//  AboutUsAndT&CWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 11/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface AboutUsAndT_CWebService : WebServiceBaseClass

+(id)service;

-(void)callAboutUsWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

-(void)callTermsAndConditionWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

-(void)callPrivacyPolicyWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
