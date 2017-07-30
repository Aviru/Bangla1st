//
//  ModelGateway.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelGateway : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strMerchentKey;
@property(nonatomic,strong)NSString *strMerchentSecret;
@property(nonatomic,strong)NSString *strReturnURL;

@end
