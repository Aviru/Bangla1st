//
//  MemberSubscriptionWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface MemberSubscriptionWebService : WebServiceBaseClass

+(id)service;

-(void)callMemberSubscriptionWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
