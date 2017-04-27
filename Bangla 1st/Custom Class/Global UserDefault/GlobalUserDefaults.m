//
//  GlobalUserDefaults.m
//  CruiSea
//
//  Created by webskitters on 17/03/16.
//  Copyright © 2016 webskitters. All rights reserved.
//

#import "GlobalUserDefaults.h"

@implementation GlobalUserDefaults
+(id)getObjectWithKey:(NSString *)key
{
    NSUserDefaults *defaults=[self getDefaults];
    id obj=[defaults objectForKey:key];
    if(obj)
        return obj;
    
    return nil;
}
+(BOOL)saveObject:(id)object withKey:(NSString *)key
{
  NSUserDefaults *defaults=[self getDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
    id obj=[defaults objectForKey:key];
    if(obj)
        return YES;
    
    return NO;
}

+(void)RemoveUserDefaultValueForKey:(NSString *)key
{
    NSUserDefaults *defaults=[self getDefaults];
    id obj=[defaults objectForKey:key];
    
    if(obj)
      [defaults removeObjectForKey:key];
}

+(NSUserDefaults *)getDefaults
{
    return [NSUserDefaults standardUserDefaults];
}
@end
