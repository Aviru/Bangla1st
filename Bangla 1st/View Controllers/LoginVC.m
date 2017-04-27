//
//  LoginVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 08/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "LoginVC.h"
#import "LoginWebService.h"
#import "EmailTextFieldDesignable.h"
#import "PasswordTextFieldDesignable.h"
#import "HomeVC.h"
#import "signUpVC.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface LoginVC ()<UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate>
{
    NSDictionary *globalLoginDict;
    NSString *strDeviceToken;
    BOOL isViewUp;
    
    IBOutlet UIButton *btnFcaeBookOutlet;
    
    IBOutlet UIButton *btnGoogleLoginOutlet;
    
    IBOutlet EmailTextFieldDesignable *txtEmail;
    
    IBOutlet PasswordTextFieldDesignable *txtPassword;
    
    UITextField *globalTextfield;
    NSString *strUserName;
    NSString *strPassword;
    
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    strUserName = @"";
    strPassword = @"";
    
    btnFcaeBookOutlet.layer.cornerRadius = 3.0;
    btnFcaeBookOutlet.layer.borderWidth = 0.5;
    btnFcaeBookOutlet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnFcaeBookOutlet.layer.shadowColor = [UIColor grayColor].CGColor;
    btnFcaeBookOutlet.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    btnFcaeBookOutlet.layer.shadowRadius = 1.0;
    btnFcaeBookOutlet.layer.shadowOpacity = 0.5;
    
    btnGoogleLoginOutlet.layer.cornerRadius = 3.0;
    btnGoogleLoginOutlet.layer.borderWidth = 0.5;
    btnGoogleLoginOutlet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnGoogleLoginOutlet.layer.shadowColor = [UIColor grayColor].CGColor;
    btnGoogleLoginOutlet.layer.shadowOffset = CGSizeMake(0.5, 1.0);
    btnGoogleLoginOutlet.layer.shadowRadius = 1.0;
    btnGoogleLoginOutlet.layer.shadowOpacity = 0.5;
    
    
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator
    strDeviceToken = @"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48";
#else
    //TODO: DEVICE TOKEN NEEDS TO BE CHANGED
    // iPhones
    //strDeviceToken =   [GlobalUserDefaults getObjectWithKey:DEVICETOKEN];
    strDeviceToken = @"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48";
#endif
    
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    if (isViewUp)
    {
        [self viewDown];
    }
}

#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark textfield delegates
#pragma mark

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    globalTextfield = textField;
    
    if (isViewUp) {
        
    }
    else
        [self viewUp];
}

- (IBAction)txtEditChanged:(id)sender {
    
    if (globalTextfield == txtEmail)
    {
        strUserName = [globalTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else
    {
       strPassword = [globalTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    globalTextfield = textField;
    
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [globalTextfield resignFirstResponder];
    return YES;
}

-(void)viewUp
{
    if (IS_IPHONE_4) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-220, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    }
    else
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-170, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    
}

-(void)viewDown
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        isViewUp=NO;
    }];
}


#pragma mark
#pragma mark - Button action
#pragma mark

- (IBAction)btnFaceBookLoginAction:(id)sender
{
    [GlobalUserDefaults saveObject:@"facebook" withKey:@"social_type"];
    
    [self initializeAndStartActivityIndicator:self.view];
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [self StopActivityIndicator:self.view];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
        
        NSArray *requiredPermissions = @[@"public_profile", @"email", @"user_friends"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                // Process error
                // [self RemoveUserDefaultValueForKey:USERID];
                [self StopActivityIndicator:self.view];
            }
            else if (result.isCancelled)
            {
                // Handle cancellations
                // [self RemoveUserDefaultValueForKey:USERID];
                [self StopActivityIndicator:self.view];
            }
            else
            {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:requiredPermissions])
                {
                    // Do work
                    
                }
            }
        }];
    }

}

- (IBAction)btnGmailLoginAction:(id)sender
{
    [self initializeAndStartActivityIndicator:self.view];
    
    [GlobalUserDefaults saveObject:@"google" withKey:@"social_type"];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    [GIDSignIn sharedInstance].delegate = self;
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)btnNormalLoginAction:(id)sender
{

    [self.view endEditing:YES];
    
    if (isViewUp)
    {
        [self viewDown];
    }
    
    if ([self alertChecking])
    {
        [self initializeAndStartActivityIndicator:self.view];
        
        globalLoginDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"username":strUserName,@"password":strPassword,@"deviceToken":strDeviceToken,@"loginType":@"normal"};
        
        [self callNormalLoginWebService];
    }
}

- (IBAction)btnRegisterAction:(id)sender
{    
    signUpVC *signUpVc = (signUpVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"signUpVC"];
    
    [self.navigationController pushViewController:signUpVc animated:YES];
    
}

#pragma mark
#pragma mark - Google SignIn Delegate
#pragma mark

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    [self StopActivityIndicator:self.view];
    
    NSLog(@"signInWillDispatch: %@",error);
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    
    [self StopActivityIndicator:self.view];
    
    NSLog(@"didDisconnectWithUser: %@",error);
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    
    if (error == nil)
    {
        //user signed in
        //get user data in "user" (GIDGoogleUser object)
        
        // Perform any operations on signed in user here.
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSString *strImageURL = @"";
        
        CGSize thumbSize=CGSizeMake(500, 500);
        if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
        {
            NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
            strImageURL = [[user.profile imageURLWithDimension:dimension] absoluteString];
        }
        
        NSLog(@"Google Sign in user details:\n userid: %@, idToken: %@, fullName: %@, givenName: %@, familyName: %@, email: %@, imageUrl: %@",userId,idToken,fullName,givenName,familyName,email,strImageURL);
        
        globalLoginDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"username":email,@"fullName":fullName,@"social_id":userId,@"img_url":strImageURL,@"deviceToken":strDeviceToken,@"loginType":@"social"};
        
        [self callSocialLoginWebService];
    }
    else
    {
        [self StopActivityIndicator:self.view];
        
        NSLog(@"%@", error.localizedDescription);
    }

}

#pragma mark
#pragma mark - Facebook Observations
#pragma mark

- (void)observeProfileChange:(NSNotification *)notfication {
    if ([FBSDKProfile currentProfile]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"fetched user:%@", result);
                
                 /*
                 
                  {
                  email = "avra_bhattacharjee@yahoo.com";
                  "first_name" = Aviru;
                  id = 1491194197565506;
                  "last_name" = Bhattacharjee;
                  picture =     {
                  data =         {
                  "is_silhouette" = 0;
                  url = "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/16938789_1446363985381861_3265426691281563760_n.jpg?oh=9bd8f14712b5a7744fc755e4f819a690&oe=59948700";
                  };
                  };
                  }
                  */
                 
                 NSString *strFullName = [NSString stringWithFormat:@"%@ %@",result[@"first_name"],result[@"last_name"]];
                 
                 globalLoginDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"username":result[@"email"],@"fullName":strFullName,@"social_id":result[@"id"],@"img_url":result[@"picture"][@"data"][@"url"],@"deviceToken":strDeviceToken,@"loginType":@"social"};
                 
                 [self callSocialLoginWebService];
             }
             else
             {
                 NSLog(@"FBError: %@",error);
                 //[self RemoveUserDefaultValueForKey:USERID];
                 [self StopActivityIndicator:self.view];
             }
             
         }];
    }
    
    
}

- (void)observeTokenChange:(NSNotification *)notfication
{
    if (![FBSDKAccessToken currentAccessToken]) {
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [self observeProfileChange:nil];
    }
}

#pragma mark
#pragma mark - Call Login Webservice
#pragma mark

-(void)callNormalLoginWebService
{
   [[LoginWebService service] callNormalLoginWebServiceWithDictParams:globalLoginDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
    
       [self StopActivityIndicator:self.view];
       
       if (response != nil)
       {
           NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
           
           self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
           
           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
           
           [GlobalUserDefaults saveObject:data withKey:USER_INFO];
           
           NSString *imgURL = self.appDel.objModelUserInfo.strUserProfileImageUrl;
           
           if (![self isEmpty:imgURL])
           {
               __block UIImage *image;
               NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                   [self StopActivityIndicator:self.view];
                   
                   if (!error)
                   {
                       if (data)
                       {
                           image = [UIImage imageWithData:data scale:0.5];
                           if (image)
                           {
                               
                               NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                               
                               [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
                               
                           }
                       }
                   }
                   else
                   {
                       NSLog(@"error in profile pic download:%@",error.localizedDescription);
                   }
                   
                   
               }];
               
               [task resume];
           }
           else
           {
               UIImage *img = [UIImage imageNamed:@"avatar.png"];
               NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
               [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
           }

           
           [GlobalUserDefaults saveObject:@"YES" withKey:ISLOGGEDIN];
           
           // TODO: Move this to where you establish a user session
           [self logUser];

           
           [self performSegueWithIdentifier:@"segueToHome" sender:self];
       }
       else
       {
           NSLog(@"%@", strMsg);
       }
       
   } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
       
       [self StopActivityIndicator:self.view];
       
       UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [alertController dismissViewControllerAnimated:YES completion:^{
               
           }];
       }];
       [alertController addAction:actionOK];
       [self presentViewController:alertController animated:YES completion:^{
           
       }];
       
   }];
}

-(void)callSocialLoginWebService
{
  [[LoginWebService service] callSocialLoginWebServiceWithDictParams:globalLoginDict success:^(id  _Nullable response, NSString * _Nullable strMsg)
   {
       [self StopActivityIndicator:self.view];
       
       if (response != nil)
       {
           NSDictionary *loginDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
           
           self.appDel.objModelUserInfo = [[ModelUserInfo alloc]initWithDictionary:loginDict];
           
           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginDict];
           
           [GlobalUserDefaults saveObject:data withKey:USER_INFO];
           
           NSString *imgURL = self.appDel.objModelUserInfo.strUserProfileImageUrl;
           
           __block UIImage *image;
           NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         [self StopActivityIndicator:self.view];
                                         
                                         if (!error)
                                         {
                                             if (data)
                                             {
                                                 image = [UIImage imageWithData:data scale:0.5];
                                                 if (image)
                                                 {
                                                     
                                                     NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                                                     
                                                     [GlobalUserDefaults saveObject:imgData withKey:PROFILE_IMAGE];
                                                     
                                                 }
                                             }
                                         }
                                         else
                                         {
                                             NSLog(@"error in profile pic download:%@",error.localizedDescription);
                                         }
                                         
                                         
                                     }];
           
           [task resume];
           
           [GlobalUserDefaults saveObject:@"YES" withKey:ISLOGGEDIN];
           
           [self logUser];
           
           [self performSegueWithIdentifier:@"segueToHome" sender:self];
           
//           HomeVC *lessonCalenderVC=(HomeVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
//           [self.navigationController pushViewController:lessonCalenderVC animated:YES];
       }
       else
       {
           NSLog(@"%@", strMsg);
       }
   }
  failure:^(NSError * _Nullable error, NSString * _Nullable strMsg)
   {
       [self StopActivityIndicator:self.view];
       
       UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [alertController dismissViewControllerAnimated:YES completion:^{
               
           }];
       }];
       [alertController addAction:actionOK];
       [self presentViewController:alertController animated:YES completion:^{
           
       }];
   }];
}

#pragma mark
#pragma mark - Crashlytics
#pragma mark


- (void) logUser
{
    //Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:self.appDel.objModelUserInfo.strUserId];
    [CrashlyticsKit setUserEmail:self.appDel.objModelUserInfo.strUserEmail];
    [CrashlyticsKit setUserName:self.appDel.objModelUserInfo.strUserName];
}



#pragma mark
#pragma mark Alert Checking
#pragma mark

-(BOOL)alertChecking
{
    if (strUserName.length==0)
    {
        [self displayErrorWithMessage:@"Please enter your email address"];
        return NO;
    }
    if (![self isValidEmail:strUserName])
    {
        [self displayErrorWithMessage:@"Please enter a valid email id!"];
        return NO;
    }
    
    if (strPassword.length==0)
    {
        [self displayErrorWithMessage:@"Please enter password"];
        return NO;
    }
    
    return YES;
}

#pragma mark


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
