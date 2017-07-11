//
//  WebService BaseClass.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "WebServiceBaseClass.h"

NSString *const WebServiceErrorDomain = @"com.Aviru.WebService.ErrorDomain";

NSString *const strAPI[]={
    
    [WEB_SERVICES_SPLASH_SCREEN] =                 @"splashScreen.php",
    [WEB_SERVICES_SIGNUP] =                        @"userRegister.php",
    [WEB_SERVICES_LOGIN] =                         @"userLogin.php",
    [WEB_SERVICES_COUNTRY_LIST] =                  @"countryList.php",
    [WEB_SERVICES_USER_TYPE_LIST] =                @"userCategoryList.php",
    [WEB_SERVICES_CONTENT_LISTING] =               @"contentListing.php",
    [WEB_SERVICES_CATEGORY_LISTING] =              @"categoryListing.php",
    [WEB_SERVICES_ACCOUNT_DETAILS] =               @"myaccount.php",
    [WEB_SERVICES_EDIT_PROFILE] =                  @"updateProfile.php",
    [WEB_SERVICES_CHANGE_PASSWORD] =               @"updatePassword.php",
    [WEB_SERVICES_PACKAGE_LIST] =                  @"packageList.php",
    [WEB_SERVICES_MEMBER_SUBSCRIPTION] =           @"subscribe.php",
    [WEB_SERVICES_MEMBER_SUBSCRIPTION_DETAILS] =   @"userSubscriptionData.php",
    [WEB_SERVICES_TRANSACTION_HISTORY] =           @"transactions.php",
    [WEB_SERVICES_COUPON_CODE_POST] =              @"validateCoupon.php",
    [WEB_SERVICES_LOGOUT] =                        @"logout.php",
    [WEB_SERVICES_NOTIFICATIONLIST] =              @"notification.php"
};

@implementation WebServiceBaseClass

-(id)initWithService:(WEB_SERVICES)service
{
    if (self=[super init])
    {
        urlForService=[NSString stringWithFormat:@"%@%@",BASE_URL,strAPI[service]];
        appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)requestPostUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure
{
    manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    ///NOTE:
    /* If you don't want it to do the NSJSONSerialization conversion to NSArray/NSDictionary, but rather want the raw NSData, you should set the responseSerializer of the AFURLSessionManager to a AFHTTPResponseSerializer,which is done below.
     Otherwise use manager.responseSerializer = [AFJSONResponseSerializer serializer] if you want to do the NSJSONSerialization conversion to NSArray/NSDictionary
     */

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:strURL parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Raw Response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        if(success)
        {
            success(responseObject);
        }
        
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error.localizedDescription);
        
        if(failure) {
            failure(error);
        }
        
    }];
    
}

- (void)requestPostWithImageUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams image:(UIImage * _Nullable)img success:(void (^ _Nullable)(id _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure
{
    NSData *postPicData = [[NSData alloc]init];
    if (img != nil)
    {
        postPicData = UIImagePNGRepresentation(img);
    }
    
    
    AFURLSessionManager *uploadManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    uploadManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strURL parameters:dictParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
            [formData appendPartWithFileData: postPicData
                                        name:@"prof_image"
                                    fileName:@"profileImage.png" mimeType:@"image/*"];
        
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [uploadManager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          NSLog(@"Error: %@", error.localizedDescription);
                          
                          if(failure)
                          {
                              failure(error);
                          }
                      }
                      else
                      {
                          if(success)
                          {
                              success(responseObject);
                          }
                      }
                  }];
    
    [uploadTask resume];
    
    
    /*
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strURL parameters:dictParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData: postPicData
                                        name:@"prof_image"
                                    fileName:@"profileImage.png" mimeType:@"image/*"];
        
    } error:nil];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error)
                      {
                          NSLog(@"Error: %@", error.localizedDescription);
                          
                          if(failure)
                          {
                              failure(error);
                          }
                      }
                      else
                      {
                          // NSError *errorJsonConversion=nil;
                          // NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&errorJsonConversion];
     
                          
                          if(success)
                          {
                              success(responseObject);
                          }
                      }
                  }];
    
    [uploadTask resume];
     */
}

- (void)requestGetUrl:(NSString * _Nullable)strURL parameters:(NSDictionary * _Nullable)dictParams success:(void (^ _Nullable)(id _Nullable response))success failure:(void (^ _Nullable)(NSError * _Nullable error))failure
{
    manager = [AFHTTPSessionManager manager];
   
    /*manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    */
   
    [manager GET:strURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {

         if([responseObject isKindOfClass:[NSDictionary class]])
         {
             if(success)
             {
                 success(responseObject);
             }
         }
         else
         {
             NSError *errorJsonConversion=nil;
             NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&errorJsonConversion];
             if(success) {
                 success(response);
             }
         }
         
    }
    failure:^(NSURLSessionTask *operation, NSError *error) {
       
        NSLog(@"Error: %@", error.localizedDescription);
        
        if(failure) {
            failure(error);
        }
        
    }];
}





@end
