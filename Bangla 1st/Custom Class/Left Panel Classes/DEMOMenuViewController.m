//
//  DEMOMenuViewController.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 25/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "LeftPanelTableViewCell.h"
#import "DEMONavigationController.h"
#import "MyProfileVC.h"
#import "TransactionHistoryVC.h"
#import "LeftPanelProtocols.h"
#import "AboutUsVC.h"
#import "NotificationListVC.h"

@interface DEMOMenuViewController ()<UITableViewDelegate,UITableViewDataSource,LeftPanelProtocols>
{
    IBOutlet UITableView *tblMenu;
    
    NSMutableArray *arrMenuNames;
    NSMutableArray *arrGrayIconNames, *arrRedIconNames;
    UINavigationController *navigationController;
}

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrMenuNames = [[NSMutableArray alloc]initWithObjects:@"",@"Transaction History",@"Notification",@"About Us",@"Send Invitation",@"Share",@"LogOut", nil]; //,@"Settings"
    
    arrGrayIconNames = [[NSMutableArray alloc]initWithObjects:@"",@"history_gray_icon.png",@"notification_gray_icon.png",@"aboutUs_gray_icon.png",@"",@"share_gray_icon.png",@"logOut_gray_icon.png", nil]; //,@"settings_gray_icon.png"
    
    arrRedIconNames = [[NSMutableArray alloc]initWithObjects:@"",@"history_red_icon.png",@"notification_red_icon.png",@"aboutUs_red_icon.png",@"",@"share_red_icon.png",@"logOut_red_icon.png", nil]; //,@"settings_red_icon.png"
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.appDel.isLogOut)
    {
        self.appDel.isLogOut = NO;
        
        /*
        [tblMenu setBackgroundView:nil];
        [tblMenu setBackgroundColor:[UIColor clearColor]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.appDel.selectedRow inSection:0];
        LeftPanelTableViewCell *Cell = (LeftPanelTableViewCell *)[tblMenu cellForRowAtIndexPath:indexPath];
        
        Cell.lblMenuName.textColor = [UIColor darkGrayColor];
        Cell.imgVwMenuIcon.image = [UIImage imageNamed:arrGrayIconNames[indexPath.row]];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [tblMenu reloadData];
        */
        
        NSIndexPath *selectedRowidxPath = [NSIndexPath indexPathForRow:self.appDel.selectedRow inSection:0];
        NSArray *arrIndexPaths = [[NSArray alloc] initWithObjects:selectedRowidxPath, nil];
        [tblMenu beginUpdates];
        [tblMenu reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        [tblMenu endUpdates];
        
    }
    
    NSIndexPath *selectedRowidxPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *arrIndexPaths = [[NSArray alloc] initWithObjects:selectedRowidxPath, nil];
    [tblMenu beginUpdates];
    [tblMenu reloadRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [tblMenu endUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark - TableView Delegates and Datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenuNames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 120.0;
    }
    else
        return 50.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftPanelTableViewCell *cell;
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6) //||indexPath.row == 7
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.lblMenuName.text = arrMenuNames[indexPath.row];
        cell.imgVwMenuIcon.image = [UIImage imageNamed:arrGrayIconNames[indexPath.row]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if (indexPath.row == 4)
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:1];
        }
        
        cell.lblSecondCellName.text = arrMenuNames[indexPath.row];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row == 0)
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userProfileCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        
        cell.imgVwUserPic.layer.cornerRadius = tblMenu.frame.size.width/2 * 0.2 ;
        
        cell.imgVwUserPic.clipsToBounds = YES;
        
        cell.lblUserName.text = self.appDel.objModelUserInfo.strUserName;
        
        cell.imgVwUserPic.image = [UIImage imageWithData:[GlobalUserDefaults getObjectWithKey:PROFILE_IMAGE]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6 ) //|| indexPath.row == 7
    {
        LeftPanelTableViewCell *cell = (LeftPanelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.lblMenuName.textColor = [UIColor darkGrayColor];
        cell.imgVwMenuIcon.image = [UIImage imageNamed:arrGrayIconNames[indexPath.row]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.appDel.selectedRow = (int)indexPath.row;
    
    navigationController = [MainStoryBoard instantiateViewControllerWithIdentifier:[GlobalUserDefaults getObjectWithKey:ROOTCONTROL]]; //contentController
    
    NSLog(@"%@",navigationController.viewControllers);
    
    if ([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = [navigationController.viewControllers objectAtIndex:0];
        
        NSLog(@"%@",tbc.viewControllers);
    }
    
    
    
    if (indexPath.row == 0)
    {
        // self.frostedViewController.contentViewController = tbc;
        
        // [self.appDel setTabBarControllerInHome:3 tabBar:tbc];
        
        
        /*
         //@[ [tbc.viewControllers objectAtIndex:3]];   //@[profileVC];
         //profileVC.hidesBottomBarWhenPushed = NO;
         self.frostedViewController.contentViewController =  [tbc.viewControllers objectAtIndex:3]; //navigationController;
         self.frostedViewController.contentViewController.hidesBottomBarWhenPushed = NO;
         */
    }
    
    
    LeftPanelTableViewCell *cell = (LeftPanelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.lblMenuName.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
    cell.imgVwMenuIcon.image = [UIImage imageNamed:arrRedIconNames[indexPath.row]];
    
    switch (indexPath.row)
    {
        case 0:
            break;
            
        case 1:
        {
            TransactionHistoryVC *transactionVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"TransactionHistoryVC"];
            transactionVC.leftPanelDelegate = self;
            navigationController.viewControllers =  @[transactionVC];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            break;
        }
            
        case 2:
        {
            NotificationListVC *notificationVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"NotificationListVC"];
            notificationVC.leftPanelDelegate = self;
            navigationController.viewControllers =  @[notificationVC];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            break;
        }
            
            
        case 3:
        {
            AboutUsVC *aboutVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"AboutUsVC"];
            aboutVC.leftPanelDelegate = self;
            navigationController.viewControllers =  @[aboutVC];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            break;
        }
           
        case 4:
        

            
        case 6:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Do you want to logOut?"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                [alert addAction:cancelButton];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                
                                                [self callLogOut];
                                                
                                            }];
                [alert addAction:yesButton];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:YES completion:nil];
                });
                
                
            });
            
            break;
  
        }
            
        default:
            break;
    }
    
    
    /*
     if (indexPath.row == 1) {
     DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
     navigationController.viewControllers = @[homeViewController];
     } else {
     }
     */
    //  self.frostedViewController.contentViewController = navigationController;
    // [self.frostedViewController hideMenuViewController];
}

#pragma mark
#pragma mark - Left Panel Delegate
#pragma mark

-(void)showHomePage:(REFrostedViewController *)REFrostedObj
{
    REFrostedObj.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showTabBarController"];
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
