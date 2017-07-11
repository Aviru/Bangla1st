//
//  NotificationWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface NotificationWebService : WebServiceBaseClass

+(id)service;

-(void)callNotificationListWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
