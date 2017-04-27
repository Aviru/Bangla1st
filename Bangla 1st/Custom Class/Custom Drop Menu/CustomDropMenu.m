//
//  CustomDropMenu.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 09/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "CustomDropMenu.h"


@interface CustomDropMenu ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblVwdropDown;
}

@end

@implementation CustomDropMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark
#pragma mark Tableview delegates and Datasource
#pragma mark


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  30.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownTableViewCell *cell = (DropDownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"dropDownCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DropDownTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    if (indexPath.row == 0)
    {
        cell.imgVwIcon.image = [UIImage imageNamed:@"download_icon.png"];
        cell.lblMenuName.text = @"Save";
        cell.vwunderLine.hidden = NO;
    }
    else
    {
        cell.imgVwIcon.image = [UIImage imageNamed:@"share_icon.png"];
        cell.lblMenuName.text = @"Share";
        cell.vwunderLine.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownTableViewCell *cell = (DropDownTableViewCell *) [tblVwdropDown cellForRowAtIndexPath:indexPath];
    
    [self.delegate didSelectDotsButtonAtIndexPath:indexPath dropDownSelctedCell:cell];
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
