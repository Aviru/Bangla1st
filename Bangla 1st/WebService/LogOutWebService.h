//
//  LogOutWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface LogOutWebService : WebServiceBaseClass

+(id)service;

-(void)callLogOutWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
