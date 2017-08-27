//
//  TransactionHistoryVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 04/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "TransactionHistoryVC.h"
#import "TransactionHistoryTableViewCell.h"
#import "TransactionHistoryWebService.h"
#import "ModelTransactionHistory.h"
#import "HomeVC.h"


@interface TransactionHistoryVC ()<UITableViewDelegate,UITableViewDataSource,LeftPanelProtocols>
{
    IBOutlet UITableView *tblTransactionHistory;
    IBOutlet UIView *navBarContainerView;
    IBOutlet UILabel *lblNoTransaction;
    
    NSMutableArray *arrtransactionHistory;
    ModelTransactionHistory *objModelTransactionHistory;
}

@end

@implementation TransactionHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Transaction History" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(transactionHistoryBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getTransactionHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Button Action
#pragma mark

-(void)transactionHistoryBackBtnTap:(UIButton *)sender
{
    tblTransactionHistory = nil;
    tblTransactionHistory.dataSource = nil;
    tblTransactionHistory.delegate = nil;
    
    if ([self.leftPanelDelegate conformsToProtocol:@protocol(LeftPanelProtocols)])
    {
        if ([self.leftPanelDelegate respondsToSelector:@selector(showHomePage:)])
        {
            [self.leftPanelDelegate showHomePage:self.frostedViewController];
        }
    }
        
    /*
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        NSLog(@"viewcontrollers:%@",self.frostedViewController.childViewControllers);
    
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[HomeVC class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
     */
    
    //[self.frostedViewController.view endEditing:YES];
    //[self.frostedViewController presentMenuViewController];
}

#pragma mark
#pragma mark Transaction History Web Service
#pragma mark

-(void)getTransactionHistory
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *dict = @{ @"ApiKey":API_KEY,USERID:self.appDel.objModelUserInfo.strUserId };
    
    [[TransactionHistoryWebService service]callTransactionHistoryWebServiceWithDictParams:dict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            if ([response[@"ResponseData"] isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response[@"ResponseData"];
                
                arrtransactionHistory = [NSMutableArray new];
                
                for (int i = 0; i<arr.count; i++)
                {
                    objModelTransactionHistory = [[ModelTransactionHistory alloc]initWithDictionary:arr[i]];
                    
                    [arrtransactionHistory addObject:objModelTransactionHistory];
                }
                
                if (arrtransactionHistory.count)
                {
                    lblNoTransaction.hidden = YES;
                    tblTransactionHistory.hidden = NO;
                    [tblTransactionHistory reloadData];
                }
                else
                {
                    lblNoTransaction.hidden = NO;
                    tblTransactionHistory.hidden = YES;
                }
                
            }
            else
            {
                NSLog(@"Response is not an array");
                
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:SOMETHING_WRONG preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }
        }
        else
        {
            NSLog(@"%@", strMsg);
            
            lblNoTransaction.hidden = NO;
            tblTransactionHistory.hidden = YES;
            
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            [alertController addAction:actionOK];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
        
    } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        lblNoTransaction.hidden = NO;
        tblTransactionHistory.hidden = YES;
        
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
#pragma mark Tableview delegates and Datasource
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrtransactionHistory.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionHistoryTableViewCell *cell = (TransactionHistoryTableViewCell *)[tblTransactionHistory dequeueReusableCellWithIdentifier:@"transactionCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"TransactionHistoryTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.lblPaymentGateWayName.text = [arrtransactionHistory[indexPath.row] strTransactionGatewayName];
    cell.lblTransactionID.text = [arrtransactionHistory[indexPath.row] strTransactionID];
    cell.lblTransactionStatus.text = [arrtransactionHistory[indexPath.row] strTransactionGateWayStatus];
    cell.lblTransactionAmount.text = [NSString stringWithFormat:@"\u20B9 %@/-",[arrtransactionHistory[indexPath.row] strTransactionAmount]];
    cell.lblTransactionDetails.text = [arrtransactionHistory[indexPath.row] strTransactionDetails];
    cell.lblDuration.text = [self timeDifference:[arrtransactionHistory[indexPath.row] strTransactionDateAdded]] ;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
