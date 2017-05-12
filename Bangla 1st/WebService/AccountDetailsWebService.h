//
//  AccountDetailsWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface AccountDetailsWebService : WebServiceBaseClass

+(id)service;
-(void)callgetAccountDetailsWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
