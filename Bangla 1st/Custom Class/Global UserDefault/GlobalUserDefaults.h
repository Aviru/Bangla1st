//
//  GlobalUserDefaults.h
//  CruiSea
//
//  Created by webskitters on 17/03/16.
//  Copyright © 2016 webskitters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalUserDefaults : NSObject
+(id)getObjectWithKey:(NSString *)key;
+(BOOL)saveObject:(id)object withKey:(NSString *)key;
+(void)RemoveUserDefaultValueForKey:(NSString *)key;


@end
