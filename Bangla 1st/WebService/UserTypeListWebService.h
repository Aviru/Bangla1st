//
//  UserTypeListWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 23/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface UserTypeListWebService : WebServiceBaseClass

+(id)service;

-(void)callUserTypeListWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
