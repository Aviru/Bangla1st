//
//  CouponCodePostWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 13/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface CouponCodePostWebService : WebServiceBaseClass

+(id)service;

-(void)callCouponCodePostWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
