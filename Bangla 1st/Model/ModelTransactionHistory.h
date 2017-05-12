//
//  ModelTransactionHistory.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 06/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelTransactionHistory : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strTransactionID;
@property(nonatomic,strong)NSString *strTransactionGatewayName;
@property(nonatomic,strong)NSString *strTransactionAmount;
@property(nonatomic,strong)NSString *strTransactionStatus;
@property(nonatomic,strong)NSString *strTransactionGateWayStatus;
@property(nonatomic,strong)NSString *strTransactionDetails;
@property(nonatomic,strong)NSString *strTransactionDateAdded;

@end
