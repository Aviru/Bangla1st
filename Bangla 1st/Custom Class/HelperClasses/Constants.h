//
//  Constants.h
//  Bangla 1st
//
//  Created by YesAbhi Lab on 21/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define MainStoryBoard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define KEY_WINDOW [[UIApplication sharedApplication] keyWindow]

#define hRatio [UIScreen mainScreen].bounds.size.height /667       //736     //568
#define wRatio [UIScreen mainScreen].bounds.size.width /375        //414     //320

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 || [[[UIDevice currentDevice] systemVersion] floatValue] <= 8.4)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define ___isIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)


#define device             @"iOS"
#define DEVICETOKEN        @"device_token"
#define ISLOGGEDIN         @"IsLoggedIn"
#define IS_FIRST_TIME      @"isFirstTime"
#define COUNTRY_LIST       @"countryList"
#define USER_TYPE          @"userTypeCategoryList"
#define ROOTCONTROL        @"rootnav"
#define IMA_DETAILS        @"ima_details"
#define USERID             @"UserID"
#define USERNAME           @"UserName"
#define EMAIL              @"Email"
#define PROFILE_IMAGE      @"profileimageUrl"
#define USER_INFO          @"user_info"

#define kClientID          @"963371718961-lk7d6i59bbhoilstris83ogtjcao3t0f.apps.googleusercontent.com"

#define API_ContentListing      @"contentListing.php"
#define API_CategoryListing     @"categoryListing.php"
#define API_PlayerAdvertisment  @"playerAd.php"

#define SOMETHING_WRONG @"Something is wrong, please try again later!"
#define VIDEO_DOWNLOAD_SUCCESS @"Video is successfully downloaded and saved"
#define VIDEO_DOWNLOAD_FAILED @"Video download and saving failed"

#endif /* Constants_h */


