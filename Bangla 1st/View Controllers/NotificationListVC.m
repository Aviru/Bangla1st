//
//  NotificationListVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 28/05/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "NotificationListVC.h"
#import "ModelNotificationList.h"
#import "NotificationListTableViewCell.h"
#import "NotificationWebService.h"

@interface NotificationListVC ()<UITableViewDelegate,UITableViewDataSource,LeftPanelProtocols>
{
    IBOutlet UIView *navBarContainerView;
    
    IBOutlet UITableView *tblNotificationList;
    
    IBOutlet UILabel *lblNoNotificationList;
    
    NSMutableArray *arrNotificationList;
    ModelNotificationList *objModelNotificationlist;
}

@end

@implementation NotificationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIFont *customFont = [UIFont fontWithName:@"BerlinSansFB-Reg" size:20];
    
    [self initWithParentView:navBarContainerView isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:@"Notification List" navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:customFont leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(notificationListBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getNotificationList];
}

#pragma mark
#pragma mark Button Action
#pragma mark

-(void)notificationListBackBtnTap:(UIButton *)sender
{
    tblNotificationList = nil;
    tblNotificationList.dataSource = nil;
    tblNotificationList.delegate = nil;
    
    if ([self.leftPanelDelegate conformsToProtocol:@protocol(LeftPanelProtocols)])
    {
        if ([self.leftPanelDelegate respondsToSelector:@selector(showHomePage:)])
        {
            [self.leftPanelDelegate showHomePage:self.frostedViewController];
        }
    }
}

#pragma mark
#pragma mark Notification List Web Service
#pragma mark

-(void)getNotificationList
{
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *dict = @{ @"ApiKey":API_KEY};
    
    [[NotificationWebService service]callNotificationListWithDictParams:dict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
        if (response != nil)
        {
            if ([response[@"ResponseData"] isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response[@"ResponseData"];
                
                arrNotificationList = [NSMutableArray new];
                
                for (int i = 0; i<arr.count; i++)
                {
                    objModelNotificationlist = [[ModelNotificationList alloc]initWithDictionary:arr[i]];
                    
                    [arrNotificationList addObject:objModelNotificationlist];
                }
                
                if (arrNotificationList.count)
                {
                    lblNoNotificationList.hidden = YES;
                    tblNotificationList.hidden = NO;
                    [tblNotificationList reloadData];
                }
                else
                {
                    lblNoNotificationList.hidden = NO;
                    tblNotificationList.hidden = YES;
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
            
            lblNoNotificationList.hidden = NO;
            tblNotificationList.hidden = YES;
            
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
        
        lblNoNotificationList.hidden = NO;
        tblNotificationList.hidden = YES;
        
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
    return arrNotificationList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationListTableViewCell *cell = (NotificationListTableViewCell *)[tblNotificationList dequeueReusableCellWithIdentifier:@"notificationListCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"NotificationListTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.lblNotificationDescription.text = [arrNotificationList[indexPath.row] strNotificationDescription];
    cell.lblNotificationID.text = [arrNotificationList[indexPath.row] strNotificationID];
    cell.lblNotificationDate.text = [arrNotificationList[indexPath.row] strNotificationDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
