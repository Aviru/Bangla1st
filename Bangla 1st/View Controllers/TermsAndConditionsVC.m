//
//  TermsAndConditionsVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 11/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "TermsAndConditionsVC.h"
#import "ARView.h"
#import "AboutUsAndT&CWebService.h"

@interface TermsAndConditionsVC ()
{
    IBOutlet UIView *navBarContainerView;
    
    IBOutlet ARView *containerView;
    
    IBOutlet UITextView *txtviewTermsAndCondition;
}

@end

@implementation TermsAndConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"About Us" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(termsAndCondBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    // drop shadow
    [containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [containerView.layer setShadowOpacity:0.4];
    [containerView.layer setShadowRadius:1.0];
    [containerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [self getTermsAndConditionDetails];
}

#pragma mark
#pragma mark TermsAndCondition webservice call
#pragma mark

-(void)getTermsAndConditionDetails
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *aboutUsDict = @{@"ApiKey":API_KEY,@"pageID":@"2"};
    
    [[AboutUsAndT_CWebService service]callAboutUsWebServiceWithDictParams:aboutUsDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:response[@"ResponseData"]];
            
            txtviewTermsAndCondition.text = responseDict[@"pagecontent"];
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

-(void)termsAndCondBackBtnTap:(UIButton *)sender
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
