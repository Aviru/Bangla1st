//
//  BackgroundTimeRemainingUtility.m
//  Snofolio_Instructor
//
//  Created by Aviru bhattacharjee on 22/01/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import "BackgroundTimeRemainingUtility.h"

@implementation BackgroundTimeRemainingUtility:NSObject

+(void) NSLog
{
    NSLog(@"State: %@, BackgroundTimeRemaining: %@", self.UIApplicationStateString, self.backgroundTimeRemainingString);
}

+ (double) backgroundTimeRemainingDouble
{
    return [[UIApplication sharedApplication] backgroundTimeRemaining];
}

+ (NSString *) backgroundTimeRemainingString
{
    NSString *result;
    if ([[UIApplication sharedApplication] backgroundTimeRemaining]==DBL_MAX)
    {
        result = @"Infinite";
    }
    else
    {
        result = [NSString stringWithFormat:@"%f", [[UIApplication sharedApplication] backgroundTimeRemaining]];
    }
    
    return result;
}

+ (UIApplicationState)UIApplicationStateEnum
{
    return [[UIApplication sharedApplication] applicationState];
}

+ (NSString *)UIApplicationStateString
{
    NSString *result;
    
    if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateBackground)
    {
        result = (@"Background");
    }
    else if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateInactive)
    {
        result = (@"Inactive");
    }
    else if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive)
    {
        result = (@"Active");
    }
    else
    {
        result = (@"Unknown");
    }
    
    return result;
}

@end
