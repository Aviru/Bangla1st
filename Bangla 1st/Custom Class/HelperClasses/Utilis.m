//
//  Utilis.m
//  Bangla 1st
//
//  Created by YesAbhi Lab on 21/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "Utilis.h"

@implementation Utilis

+ (BOOL)containsKey: (NSString *)key :(NSDictionary *)dict {
    BOOL retVal = 0;
    NSArray *allKeys = [dict allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

@end
