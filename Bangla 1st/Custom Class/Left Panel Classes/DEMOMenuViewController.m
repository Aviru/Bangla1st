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

@interface DEMOMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    arrMenuNames = [[NSMutableArray alloc]initWithObjects:@"",@"Transaction History",@"Settings",@"Notification",@"About Us",@"Send Invitation",@"Share",@"LogOut", nil];
    
    arrGrayIconNames = [[NSMutableArray alloc]initWithObjects:@"",@"history_gray_icon.png",@"settings_gray_icon.png",@"notification_gray_icon.png",@"aboutUs_gray_icon.png",@"",@"share_gray_icon.png",@"logOut_gray_icon.png", nil];
    
    arrRedIconNames = [[NSMutableArray alloc]initWithObjects:@"",@"history_red_icon.png",@"settings_red_icon.png",@"notification_red_icon.png",@"aboutUs_red_icon.png",@"",@"share_red_icon.png",@"logOut_red_icon.png", nil];
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
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7)
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.lblMenuName.text = arrMenuNames[indexPath.row];
        cell.imgVwMenuIcon.image = [UIImage imageNamed:arrGrayIconNames[indexPath.row]];
    }
    
    if (indexPath.row == 5)
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:1];
        }
        
        cell.lblSecondCellName.text = arrMenuNames[indexPath.row];
    }
    if (indexPath.row == 0)
    {
        cell = (LeftPanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userProfileCell"];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        
        cell.imgVwUserPic.layer.cornerRadius = cell.imgVwUserPic.frame.size.width/2;
        
        cell.imgVwUserPic.clipsToBounds = YES;
        
        cell.lblUserName.text = self.appDel.objModelUserInfo.strUserName;
        
        cell.imgVwUserPic.image = [UIImage imageWithData:[GlobalUserDefaults getObjectWithKey:PROFILE_IMAGE]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7)
    {
        LeftPanelTableViewCell *cell = (LeftPanelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.lblMenuName.textColor = [UIColor darkGrayColor];
        cell.imgVwMenuIcon.image = [UIImage imageNamed:arrGrayIconNames[indexPath.row]];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     navigationController = [MainStoryBoard instantiateViewControllerWithIdentifier:[GlobalUserDefaults getObjectWithKey:ROOTCONTROL]]; //contentController
    
    NSLog(@"%@",navigationController.viewControllers);
    
    UITabBarController *tbc = [navigationController.viewControllers objectAtIndex:0];
    
    NSLog(@"%@",tbc.viewControllers);
    
    if (indexPath.row == 0)
    {
        self.frostedViewController.contentViewController = tbc;
        
       // [self.appDel setTabBarControllerInHome:3 tabBar:tbc];
        
        /*
        MyProfileVC *profileVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
        navigationController.viewControllers =  @[profileVC]; //@[ [tbc.viewControllers objectAtIndex:3]];   //@[profileVC];
        //profileVC.hidesBottomBarWhenPushed = NO;
        self.frostedViewController.contentViewController =  [tbc.viewControllers objectAtIndex:3]; //navigationController;
        self.frostedViewController.contentViewController.hidesBottomBarWhenPushed = NO;
         */
        [self.frostedViewController hideMenuViewController];
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7)
    {
        LeftPanelTableViewCell *cell = (LeftPanelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.lblMenuName.textColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
        cell.imgVwMenuIcon.image = [UIImage imageNamed:arrRedIconNames[indexPath.row]];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
