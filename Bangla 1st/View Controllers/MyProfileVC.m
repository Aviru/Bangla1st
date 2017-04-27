//
//  MyProfileVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "MyProfileVC.h"
#import "ProfileTableViewCell.h"

#define PROFILECELL @"profilePicCell"
#define CURRENTCELL @"currentPlanCell"
#define RECOMENDCELL @"recomendedPlanCell"

@interface MyProfileVC ()
{
    IBOutlet UIView *navbarContainerVw;
    
    IBOutlet UITableView *tblVwMyProfile;
}

@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
   [self initWithParentView:navbarContainerVw isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(openmenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.navBarRightButtonOutlet addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark
#pragma mark - Open Left Pannel
#pragma mark

-(void)openmenu
{
}

#pragma mark
#pragma mark - Search Button
#pragma mark

-(void)searchButtonAction
{
}

#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
        return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vwHeader;
    UILabel *lblHeader;

    if (section == 1)
    {
        vwHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [vwHeader setBackgroundColor:[UIColor whiteColor]];
        vwHeader.tag = section;
        lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, vwHeader.frame.size.width-20, vwHeader.frame.size.height)];
        lblHeader.textColor = [UIColor darkGrayColor];
        lblHeader.font = [UIFont  systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        
        lblHeader.text = @"Current Plan";
        
        [vwHeader addSubview:lblHeader];
        return vwHeader;
    }
    else if (section == 2)
    {
        vwHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [vwHeader setBackgroundColor:[UIColor whiteColor]];
        vwHeader.tag = section;
        lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, vwHeader.frame.size.width-20, vwHeader.frame.size.height)];
        lblHeader.textColor = [UIColor darkGrayColor];
        lblHeader.font = [UIFont  systemFontOfSize:15.0 weight:UIFontWeightSemibold];
        
        lblHeader.text = @"Recomended Plan";
        
        [vwHeader addSubview:lblHeader];
        return vwHeader;
    }
    else
        return 0;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  180.0;
        }
        else
         return  160.0;
    }
    else if (indexPath.section == 1)
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  120.0;
        }
        else
         return  100.0;
    }
    else
    {
        if (IS_IPHONE_6_PLUS || IS_IPHONE_6)
        {
            return  200.0;
        }
        else
         return  170.0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *strIdentifier=@"ExperienceTableCell"; //lessonCell
    
    if (indexPath.section == 0)
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PROFILECELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        
        cell.imgVwProfilePic.image = [UIImage imageWithData:[GlobalUserDefaults getObjectWithKey:PROFILE_IMAGE]];
        
        cell.lblName.text = self.appDel.objModelUserInfo.strUserName;  //[indexPath.row] objectForKey:@"level"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CURRENTCELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:1];
        }
        
        cell.txtVwContent.text = @"Ad supported, low and medium quality streaming only." ;
        
      //  [cell.txtVwRecomendedContent setContentOffset:CGPointMake(0,-150) animated:NO];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else
    {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RECOMENDCELL];
        if (cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentLeft];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        UIColor *colorGray = [UIColor darkGrayColor];
        UIColor *colorRed = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
        
        UIFont *font1 = [UIFont systemFontOfSize:14.0];
        // UIFont *font2 = [UIFont systemFontOfSize:14.0];
        NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                NSFontAttributeName:font1,
                                NSForegroundColorAttributeName : colorGray,
                                NSParagraphStyleAttributeName:style};
        NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                NSFontAttributeName:font1,
                                NSForegroundColorAttributeName : colorRed,
                                NSParagraphStyleAttributeName:style};
        
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Download unlimited HD video and listen Music with premium membership. \n\n" attributes:dict1]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Premium Plus \n\n" attributes:dict2]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Just for Rs.120/month" attributes:dict1]];
        
        cell.txtVwRecomendedContent.attributedText = attString;
        
        [cell.txtVwRecomendedContent setContentOffset:CGPointMake(0,-150) animated:NO];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
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
