//
//  DEMORootVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 25/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "DEMORootVC.h"
#import "DEMOMenuViewController.h"

@interface DEMORootVC ()

@end

@implementation DEMORootVC

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    if([[GlobalUserDefaults getObjectWithKey:ISLOGGEDIN] isEqualToString:@"YES"])
    {
       // self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showTabBarController"];
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showSplashScreenController"];
        
        [GlobalUserDefaults saveObject:@"showTabBarController" withKey:ROOTCONTROL];
        self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
        
      
    }
    else
    {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showSplashScreenController"];
        [GlobalUserDefaults saveObject:@"showLoginPageController" withKey:ROOTCONTROL];
        self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
