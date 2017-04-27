//
//  ListWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 05/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface ListWebService : WebServiceBaseClass

+(id)service;

-(void)callListWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
