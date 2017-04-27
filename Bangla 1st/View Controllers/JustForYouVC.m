//
//  JustForYouVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

@import AVFoundation;
@import GoogleInteractiveMediaAds;
#import <AVKit/AVKit.h>

#import "JustForYouVC.h"
#import "VideoDetails+CoreDataClass.h"
#import "JustForYouTableViewCell.h"
#import "VideoDetailsVC.h"
#import "ModelList.h"

@interface JustForYouVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *navBarContainerVw;
    
    IBOutlet UITableView *tblJustForYou;
    
    IBOutlet UILabel *lblNoVideo;
    
    NSMutableArray *arrJustForYouDetails;
    VideoDetails *videoDetails;
    NSString *kTestAppAdTagUrl;
}

@end

@implementation JustForYouVC

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithParentView:navBarContainerVw isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray *results = [VideoDetails fetchVideoDetailsWithEntityName:@"VideoDetails" managedObjectContext:[self managedObjectContext]];
    
    if (results.count > 0)
    {
        arrJustForYouDetails = results;
        tblJustForYou.hidden = NO;
        lblNoVideo.hidden = YES;
        kTestAppAdTagUrl = self.appDel.objModelAdId.strIMAadTagURL;
        [tblJustForYou reloadData];
    }
    else
    {
        tblJustForYou.hidden = YES;
        lblNoVideo.hidden = NO;
    }
}


#pragma mark
#pragma mark - TableView Delegates and Datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrJustForYouDetails.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JustForYouTableViewCell *cell = (JustForYouTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"justForYouCell"];
    if (cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"JustForYouTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    videoDetails = [arrJustForYouDetails objectAtIndex:indexPath.row];
    
    [cell.imgVwThumbImage sd_setImageWithURL:[NSURL URLWithString:videoDetails.thumbImage]
                    placeholderImage:nil
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            }
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                               
                           }];
    
    cell.lblVideoTitle.text = videoDetails.videoTitle;
    cell.lblVideoDescription.text = videoDetails.videoDescription;
    cell.lblPostedTimeAndViews.text = [NSString stringWithFormat:@"%@(%@ views)",videoDetails.postedTime,videoDetails.views];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        return 140.0;
    }
    else
     return 120.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    videoDetails = [arrJustForYouDetails objectAtIndex:indexPath.row];
    
    if(![self isEmpty:videoDetails.videoID])
    {
         [self performSegueWithIdentifier:@"segueToViedoDetailsFromJustForYouVC" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"segueToViedoDetailsFromJustForYouVC"])
    {
        VideoDetailsVC *videoVC = segue.destinationViewController;
        NSDictionary *dict = [NSDictionary dictionaryWithPropertiesOfObject:videoDetails];
        NSLog(@"%@", dict);
        videoVC.objModelList = [[ModelList alloc] initWithDictionary:dict];
        videoVC.isFromListVC = NO;
    }
}

@end
