//
//  BackgroundTimeRemainingUtility.h
//  Snofolio_Instructor
//
//  Created by Aviru bhattacharjee on 22/01/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#ifndef BackgroundTimeRemainingUtility_h
#define BackgroundTimeRemainingUtility_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundTimeRemainingUtility:NSObject

+(void) NSLog;

@property (readonly) double backgroundTimeRemainingDouble;
@property (readonly) NSString *backgroundTimeRemainingString;
@property (readonly) UIApplicationState UIApplicationStateEnum;
@property (readonly) NSString *UIApplicationStateString;

@end
#endif /* BackgroundTimeRemainingUtility_h */