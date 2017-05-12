//
//  TransactionHistoryWebService.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

@interface TransactionHistoryWebService : WebServiceBaseClass

+(id)service;

-(void)callTransactionHistoryWebServiceWithDictParams:(NSDictionary *)dictParams success:(success)successHandler failure:(failure)failureHandler;

@end
