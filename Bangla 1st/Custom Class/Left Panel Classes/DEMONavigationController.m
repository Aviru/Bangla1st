//
//  DEMOBeforeLoginNavigationVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 25/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "DEMONavigationController.h"

@interface DEMONavigationController ()

@end

@implementation DEMONavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    
    if([[GlobalUserDefaults getObjectWithKey:ISLOGGEDIN] isEqualToString:@"YES"])
    {
        
       // UITabBarController *tbc = [MainStoryBoard instantiateViewControllerWithIdentifier:@"mainTabBarController"];
                
        self.frostedViewController.panGestureEnabled = YES;
        
        self.frostedViewController.limitMenuViewSize = YES;
        
        CGSize c= CGSizeMake([[UIScreen mainScreen] bounds].size.width - 100.0, [[UIScreen mainScreen] bounds].size.height);
        
        self.frostedViewController.menuViewSize = c;
        
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    }
    else
        self.frostedViewController.panGestureEnabled = NO;

   
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
