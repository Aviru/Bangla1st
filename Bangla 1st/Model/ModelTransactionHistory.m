//
//  ModelTransactionHistory.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelTransactionHistory.h"

@implementation ModelTransactionHistory

-(id)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"transID"] && ![[dict objectForKey:@"transID"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionID=[dict objectForKey:@"transID"];
        }
        else
        {
            self.strTransactionID=@"";
        }
        
        if ([dict objectForKey:@"gatewayName"] && ![[dict objectForKey:@"gatewayName"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionGatewayName=[dict objectForKey:@"gatewayName"];
        }
        else
        {
            self.strTransactionGatewayName=@"";
        }
        
        if ([dict objectForKey:@"amount"] && ![[dict objectForKey:@"amount"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionAmount=[dict objectForKey:@"amount"];
        }
        else
        {
            self.strTransactionAmount=@"";
        }
        
        if ([dict objectForKey:@"status"] && ![[dict objectForKey:@"status"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionStatus=[dict objectForKey:@"status"];
        }
        else
        {
            self.strTransactionStatus=@"";
        }
        
        if ([dict objectForKey:@"paymentGatwayStatus"] && ![[dict objectForKey:@"paymentGatwayStatus"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionGateWayStatus=[dict objectForKey:@"paymentGatwayStatus"];
        }
        else
        {
            self.strTransactionGateWayStatus=@"";
        }
        
        if ([dict objectForKey:@"details"] && ![[dict objectForKey:@"details"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionDetails=[dict objectForKey:@"details"];
        }
        else
        {
            self.strTransactionDetails=@"";
        }
        
        if ([dict objectForKey:@"dateAdded"] && ![[dict objectForKey:@"dateAdded"] isKindOfClass:[NSNull class]])
        {
            self.strTransactionDateAdded=[dict objectForKey:@"dateAdded"];
        }
        else
        {
            self.strTransactionDateAdded=@"";
        }
        
    }
    return self;
}

@end
