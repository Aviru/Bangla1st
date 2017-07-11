//
//  PrivacyPolicyVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "PrivacyPolicyVC.h"
#import "ARView.h"
#import "AboutUsAndT&CWebService.h"

@interface PrivacyPolicyVC ()
{
    IBOutlet UIView *navBarContainerView;
    
    IBOutlet UITextView *txtViewPrivcyPolicy;
    
    IBOutlet ARView *ContainerView;
}

@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Privacy Policy" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(PrivacyPolicyBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    // drop shadow
    [ContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [ContainerView.layer setShadowOpacity:0.4];
    [ContainerView.layer setShadowRadius:1.0];
    [ContainerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [self getPrivacyPolicyDetails];
}


#pragma mark
#pragma mark TermsAndCondition webservice call
#pragma mark

-(void)getPrivacyPolicyDetails
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *aboutUsDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",@"pageID":@"3"};
    
    [[AboutUsAndT_CWebService service]callPrivacyPolicyWebServiceWithDictParams:aboutUsDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
            
            txtViewPrivcyPolicy.text = responseDict[@"pagecontent"];
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
        
    }
     
    failure:^(NSError * _Nullable error, NSString * _Nullable strMsg)
     {
         [self StopActivityIndicator:self.view];
         
         NSLog(@"Error:%@",error.localizedDescription);
         
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
#pragma mark Button Action
#pragma mark

-(void)PrivacyPolicyBackBtnTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark


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
