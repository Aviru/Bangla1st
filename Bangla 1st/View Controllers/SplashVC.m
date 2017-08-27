//
//  SplashVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "SplashVC.h"
#import "ContentListingWebService.h"
#import "HomeVC.h"
#import "LoginVC.h"
#import "SplashScreenWebService.h"

@interface SplashVC ()
{
    IBOutlet UIImageView *imgViewSplash;
    
}

@end

@implementation SplashVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   NSDictionary *dict =@{@"ApiKey":API_KEY};
    
    [[SplashScreenWebService service]callSplashScreenWebServiceWithDictParams:dict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            NSString *strHexCode = response[@"ResponseData"][@"splash_bg_color"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 imgViewSplash.backgroundColor = [self colorWithHexString:strHexCode];
            });
        }
        else
        {
            NSLog(@"%@", strMsg);
            
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            [alertController addAction:actionOK];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
        
        [self navigateToNextscreen];
        
    } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            [self navigateToNextscreen];

        }];
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }];
    
   
}

-(void)navigateToNextscreen
{
    self.frostedViewController.panGestureEnabled = YES;
    
    self.frostedViewController.limitMenuViewSize = YES;
    
    CGSize menuSize= CGSizeMake([[UIScreen mainScreen] bounds].size.width - 100.0, [[UIScreen mainScreen] bounds].size.height);
    
    self.frostedViewController.menuViewSize = menuSize;
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    if([[GlobalUserDefaults getObjectWithKey:ISLOGGEDIN] isEqualToString:@"YES"])
    {
        if (![[GlobalUserDefaults getObjectWithKey:IS_FIRST_TIME] isEqualToString:@"YES"])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                // [self performSegueWithIdentifier:@"segueToTabBarFromSplash" sender:self];
                
               // UITabBarController *tabC=(UITabBarController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
                //[self.navigationController pushViewController:tabC animated:YES];
                
                self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showTabBarController"];
                
            });
        }
        else
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //[self performSegueWithIdentifier:@"segueToTabBarFromSplash" sender:self];
                
               // HomeVC *homeVC=(HomeVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
                                //    [self.navigationController pushViewController:homeVC animated:YES];
                
                self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showTabBarController"];
                
               // UITabBarController *tabC=(UITabBarController *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
               // [self.navigationController pushViewController:tabC animated:YES];
            });
        
    }
    else
    {
        if (![[GlobalUserDefaults getObjectWithKey:IS_FIRST_TIME] isEqualToString:@"YES"])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self performSegueWithIdentifier:@"segueToLogin" sender:self];
               // self.frostedViewController.panGestureEnabled = NO;
                
                LoginVC *loginVC=(LoginVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        }
        else
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // [self performSegueWithIdentifier:@"segueToLogin" sender:self];
                
               // self.frostedViewController.panGestureEnabled = NO;
                
                LoginVC *loginVC=(LoginVC *)[MainStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        
    }
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
