//
//  ModelIMAad.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 02/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelIMAad : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strIMAadId;
@property(nonatomic,strong)NSString *strIMAadTagURL;
@end
