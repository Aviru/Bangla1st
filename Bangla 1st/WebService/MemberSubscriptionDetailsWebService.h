//
//  MemberSubscriptionDetailsWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 04/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface MemberSubscriptionDetailsWebService : WebServiceBaseClass

+(id)service;

-(void)callMemberSubscriptionDetailsWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
