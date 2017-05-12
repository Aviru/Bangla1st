//
//  BaseVCViewController.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AviSpinner.h"
#import "NavigationBar.h"

@interface BaseVC : UIViewController

@property(strong,nonatomic) AppDelegate *appDel;

-(void)initWithParentView:(UIView *)parentView isTranslateToAutoResizingMaskNeeded:(BOOL)boolVal leftButton:(BOOL)isLeftButton rightButton:(BOOL)isRightButton navigationTitle:(NSString *)navigationTitle navigationTitleTextAlignment:(NSTextAlignment)navTitleTextAlignment navigationTitleFontType:(UIFont *)fontType  leftImageName:(NSString *)strLeftImageName leftLabelName:(NSString *)strLeftLabelName  rightImageName:(NSString *)strRightImageName rightLabelName:(NSString *)strRightLabelName;

@property (strong,nonatomic)NavigationBar *navBar;

-(void)getOfflineSavedVideoCount;

-(void)openLeftPanel;

-(AviSpinner *)initializeAndStartActivityIndicator:(UIView *)view;
-(AviSpinner *)StopActivityIndicator:(UIView *)view;

-(BOOL)isContainUpperCase:(NSString *)checkString;
-(BOOL)isContainLowerCase:(NSString *)checkString;
-(BOOL)isContainSpecialCase:(NSString *)checkString;
-(BOOL)isLengthMoreThan6:(NSString *)checkString;
-(BOOL)isContainDigit:(NSString *)checkString;

-(BOOL)isValidEmail:(NSString*)strEmailID;

-(void)displayErrorWithMessage:(NSString*)strMsg;

-(BOOL)isEmpty:(NSString *)str;

-(UIColor*)colorWithHexString:(NSString*)hex;

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2;

- (NSString *)timeDifference:(NSString *)commentTimeStamp;

-(void)callLogOut;

@end
