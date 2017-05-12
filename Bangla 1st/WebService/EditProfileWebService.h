//
//  EditProfileWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface EditProfileWebService : WebServiceBaseClass

+(id)service;
-(void)callEditProfileWebServiceWithDictParams:(NSDictionary *)dictParams profileImage:(UIImage *)img success:(success)successHandler failure:(failure)failureHandler;

@end
