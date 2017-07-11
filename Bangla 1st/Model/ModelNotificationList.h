//
//  ModelNotificationList.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelNotificationList : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic,strong)NSString *strNotificationID;
@property(nonatomic,strong)NSString *strNotificationDescription;
@property(nonatomic,strong)NSString *strNotificationDate;

@end
