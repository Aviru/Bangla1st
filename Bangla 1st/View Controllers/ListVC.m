//
//  ListVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//


#import "ListVC.h"
#import "Cell_List.h"
#import "Cell_ListAd.h"

#import "CustomDropMenu.h"
#import "DropDownTableViewCell.h"
#import "VideoDetailsVC.h"

#import "ListWebService.h"
#import "ModelList.h"
#import "DownloadManager.h"
#import "VideoDetails+CoreDataClass.h"
#import "Constants.h"

#import "Utilis.h"


#define degreeToRadian(x) (M_PI * x / 180.0)
#define radianToDegree(x) (180.0 * x / M_PI)



@interface ListVC () <UITableViewDelegate,UITableViewDataSource,CustomDropMenuDelegate>
{
    NSMutableArray *arrList,*arrVideoThumbImg;
    ModelList *objModelList;
    Cell_ListAd  *listAdCell;
    CustomDropMenu *dropDownvc;
    Cell_List *btnDotscell;
    NSString *kTestAppAdTagUrl;
    NSIndexPath *selectedDotsBtnIndexPath;
    
    IBOutlet UIView *navBarVwContainer;
    
    
}


@end


@implementation ListVC

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
    arrList=[NSMutableArray new];
    arrVideoThumbImg = [NSMutableArray new];
    kTestAppAdTagUrl = self.appDel.objModelAdId.strIMAadTagURL;

    
    [self initWithParentView:navBarVwContainer isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
    [self getCategoryDatas];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
        btnDotscell.VwDropDowncontainer.hidden = YES;
    }
}

- (void)getCategoryDatas{
    
     [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *dictParams= @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",
                                @"contentType":@"video",
                                @"category":@"0"
                                };
    
    [[ListWebService service] callListWebServiceWithDictParams:dictParams success:^(id _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            if ([response isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response;
                
                for (int i = 0; i<arr.count; i++)
                {
                    objModelList = [[ModelList alloc]initWithDictionary:arr[i]];
                    
                    [arrList addObject:objModelList];
                }
                
               // arrList = [response mutableCopy];
                
                NSString *strAdThumb = [arrList[0] strAdCodeUrl];  //content[@"adCode"];
                
                self.ivBannerAd.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:strAdThumb]];
                
                [_tblList reloadData];
            }
            else
            {
                NSLog(@"Response is not an array");
            }
        }
        else
        {
            NSLog(@"%@", strMsg);
        }
        
        [self StopActivityIndicator:self.view];
        
    } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        [self StopActivityIndicator:self.view];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - TableView Delegates and Datasource
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 /*
  message": "Content Listing",
  "ResponseData": [
  {
  "adID": "12",
  "adTitle": "Video Page Top Banner",
  "adCode": "http://www.shakeout.org/2008/downloads/ShakeOut_BannerAds_GetReady_728x90_v3.gif"
  },
  {
  "videoID": "971",
  "videoTitle": "Sample",
  "videoDescription": "Sample Mp4 Video Test",
  "videoTags": "Development",
  "thumbImage": "http://173.214.180.212/betadev/uploads/video_thumb/1485258163be915-632x395-11.jpg",
  "videoFile": "http://173.214.180.212/betadev/uploads/video/SampleVideo_1280x720_1mb.mp4",
  "Views": "26",
  "commentCount": "5",
  "likes": "2",
  "videoDuration": "2:40",
  "videoType": "HD",
  "postedTime": "one month ago",
  "postedBy": "Admin",
  "authorImage": "http://173.214.180.212/betadev/uploads/userProfileImage/avatar.png",
  "category": "0"
  },
  {
  "videoID": "970",
  "videoTitle": "Demo",
  "videoDescription": "Simple Demo Video",
  "videoTags": "Development",
  "thumbImage": "http://173.214.180.212/betadev/uploads/video_thumb/148544607250b39-632x395-1.jpg",
  "videoFile": "http://173.214.180.212/betadev/uploads/video/small.mp4",
  "Views": "15",
  "commentCount": "5",
  "likes": "2",
  "videoDuration": "2:40",
  "videoType": "HD",
  "postedTime": "one month ago",
  "postedBy": "Admin",
  "authorImage": "http://173.214.180.212/betadev/uploads/userProfileImage/avatar.png",
  "category": "0"
  },
  {
  "adID": "17",
  "adTitle": "video Side Banner",
  "adCode": "http://www.shakeout.org/2008/downloads/ShakeOut_BannerAds_GetReady_300x250_v3.gif"
  },
  {
  "videoID": "1",

  
  */
    
    objModelList = arrList[indexPath.row];
    
    if (![self isEmpty:objModelList.strVideoId])
    {
        //its a vid
        NSString *strVidThumb = objModelList.strThumbImageUrl;
        NSString *videoTitle  = objModelList.strVideoTitle;
        NSString *videoDesc   = objModelList.strVideoDescription;
        NSString *postedTime   = [NSString stringWithFormat:@"%@(%@ views)",objModelList.strPostedTime,objModelList.strViews];
        
        Cell_List  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_List" forIndexPath:indexPath];
        cell.lblVidName.text=videoTitle;
        cell.lblVidDesc.text=videoDesc;
        cell.lblVidInfo.text=postedTime;
        
        cell.VwDropDowncontainer.hidden = YES;
        
        cell.btndotsOutlet.tag = indexPath.row;
        
        cell.VwDropDowncontainer.tag = indexPath.row;
        
        cell.progressVw.tag = indexPath.row;
        
        [cell.btndotsOutlet addTarget:self action:@selector(btnDotsTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.ivImage sd_setImageWithURL:[NSURL URLWithString:strVidThumb]
                                placeholderImage:nil
                                         options:SDWebImageHighPriority
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                            
                                        }
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           
                                           [arrVideoThumbImg addObject:image];
                                           
                                       }];

        
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
   else if(![self isEmpty:objModelList.strAdId])
        // its a ad
   {
       listAdCell = (Cell_ListAd *)[tableView dequeueReusableCellWithIdentifier:@"Cell_ListAd" forIndexPath:indexPath];
       
       NSString *strAdThumb = objModelList.strAdCodeUrl; //content[@"adCode"];
       
       listAdCell.adImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:strAdThumb]];
       
       listAdCell.adImage.animationDuration = 1.0f;
       listAdCell.adImage.animationRepeatCount = 0;
       [listAdCell.adImage startAnimating];
       
       listAdCell.selectionStyle=UITableViewCellSelectionStyleNone;
       
       return listAdCell;
       
   }
   else
   {
       Cell_ListAd  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_ListAd" forIndexPath:indexPath];
       
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
       return cell;
   }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    objModelList = arrList[indexPath.row];
    
    if(indexPath.row==0){
        return  0;
    }else{
        
        return 111;
        /*
        if(![self isEmpty:objModelList.strVideoId]){
            
            return 111;
        }else{
            
            return 140;
        }
         */
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objModelList = arrList[indexPath.row];
    
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
        btnDotscell.VwDropDowncontainer.hidden = YES;
        
    }
    
    if(![self isEmpty:objModelList.strVideoId])
    {
        [self performSegueWithIdentifier:@"segueToViedoDetailsFromListVC" sender:nil];
        
    }
}



#pragma mark
#pragma mark Button Action
#pragma mark

-(void)btnDotsTap:(id)sender
{
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
        btnDotscell.VwDropDowncontainer.hidden = YES;
        
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblList];
    selectedDotsBtnIndexPath = [_tblList indexPathForRowAtPoint:buttonPosition];
    btnDotscell = (Cell_List *)[_tblList cellForRowAtIndexPath:selectedDotsBtnIndexPath];
    
    btnDotscell.VwDropDowncontainer.hidden = NO;
    
    [btnDotscell.VwDropDowncontainer.layer setCornerRadius:2.0f];
    
    // border
    [btnDotscell.VwDropDowncontainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btnDotscell.VwDropDowncontainer.layer setBorderWidth:0.5f];
    
    // drop shadow
    [btnDotscell.VwDropDowncontainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [btnDotscell.VwDropDowncontainer.layer setShadowOpacity:0.4];
    [btnDotscell.VwDropDowncontainer.layer setShadowRadius:1.0];
    [btnDotscell.VwDropDowncontainer.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    dropDownvc = [[CustomDropMenu alloc] initWithNibName:@"CustomDropMenu" bundle:nil];
    dropDownvc.view.frame = CGRectMake(0, 0, btnDotscell.VwDropDowncontainer.frame.size.width,  btnDotscell.VwDropDowncontainer.frame.size.height);
    [self addChildViewController:dropDownvc];
    [btnDotscell.VwDropDowncontainer addSubview:dropDownvc.view];
    [dropDownvc didMoveToParentViewController:self];
    dropDownvc.delegate=self;
}


#pragma mark
#pragma mark - Custom Drop Down Delegate
#pragma mark

- (void)didSelectDotsButtonAtIndexPath:(NSIndexPath*)indexPath dropDownSelctedCell:(DropDownTableViewCell *)dropDwnCell
{
    btnDotscell.VwDropDowncontainer.hidden = YES;
    
    objModelList = arrList[selectedDotsBtnIndexPath.row];
    
    if (indexPath.row == 0)
    {
       ///fIRST check whether the video is already downloaded or not. if not then only download
        
        if(![self isEmpty:objModelList.strVideoId])
        {
             NSMutableArray *results = [VideoDetails fetchVideoDetailsWithEntityName:@"VideoDetails" predicateName:@"videoID" predicateValue:objModelList.strVideoId managedObjectContext:[self managedObjectContext]];
            
            if (results.count > 0)
            {
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"Video already saved" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                [alertController addAction:actionOK];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }
            else
            {
                
                //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                
                NSString * uniqueId = [NSString stringWithFormat:@"Bangla1stBackgroundUpload:%f",[[NSDate date] timeIntervalSince1970] * 1000];
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:uniqueId];
                
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                NSURL *URL = [NSURL URLWithString:objModelList.strVideoFileUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                
                btnDotscell.progressVw.hidden = NO;
                
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update the progress view
                        [btnDotscell.progressVw setProgress:downloadProgress.fractionCompleted];
                        
                    });
                    
                }
                                                          
                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                    
                    /*
                    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    
                    NSString *fileName = [NSString stringWithFormat:@"video%d.mov",++self.appDel.videoCount];
                    
                    NSString  *savedVideoPath = [documentsPath stringByAppendingPathComponent:fileName];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    NSError *error;
                    if ([fileManager fileExistsAtPath:savedVideoPath]) {
                        
                        if ([fileManager removeItemAtPath:savedVideoPath error:&error])
                        {
                            NSLog(@"removeItemAtPath successful");
                        }
                        else
                            NSLog(@"failed to removeItemAtPath: %@",[error userInfo]);
                        
                    }
                    
                    if ([fileManager moveItemAtURL:location
                                             toURL:[NSURL fileURLWithPath:savedVideoPath]
                                             error: &error])
                    {
                        NSLog(@"File is saved to =%@",savedVideoPath);
                    }
                    else
                    {
                        NSLog(@"failed to move: %@",[error userInfo]);
                        --self.appDel.videoCount;
                    }
                     */

                }
                
                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    // Do operation after download is complete
                    
                    if (error)
                    {
                        NSLog(@"error video download: %@",error.userInfo);
                    }
                    else
                    {
                        self.appDel.videoCount++;
                        
                        NSString *encodedURL = [[response.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                        NSArray *filtered = [arrList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.strVideoFileUrl contains[cd] %@", encodedURL]];
                        
                        if (filtered.count > 0)
                        {
                            objModelList = [filtered objectAtIndex:0];
                            
                           int idx = (int) [arrList indexOfObject:objModelList];
                            
                            NSIndexPath *completedDwnloadIndxPath = [NSIndexPath indexPathForRow:idx inSection:0];
                            
                            Cell_List *completedDwnloadListCell = (Cell_List *)[_tblList cellForRowAtIndexPath:completedDwnloadIndxPath];
                            
                            completedDwnloadListCell.progressVw.hidden = YES;
                            
                            [VideoDetails createInManagedObjectContextWithVideoURL:objModelList.strVideoFileUrl  videoAssetURL:[filePath absoluteString] videoID:objModelList.strVideoId videoDate:[NSDate date] title:objModelList.strVideoTitle description:objModelList.strVideoDescription duration:objModelList.strVideoDuration postedTime:objModelList.strPostedTime views:objModelList.strViews likes:objModelList.strLikes commentCount:objModelList.strCommentCount thumbImageURL:objModelList.strThumbImageUrl managedObjectContext:[self managedObjectContext]];
                            
                            
                            NSError *DBerror = nil;
                            // Save the object to persistent store
                            if (![[self managedObjectContext] save:&DBerror])
                            {
                                NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
                            }
                            else
                            {
                                NSLog(@"Data Saved Successfully.");
                                
                                [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",self.appDel.videoCount]];
                            }
                            
                        }
                    }

                }];
                
                NSLog(@"download taskm identifier:%lu",(unsigned long)downloadTask.taskIdentifier);
                
                [downloadTask resume];
                
            }
            
        }
    }
    else
    {
        NSString *text = objModelList.strVideoTitle;
        NSURL *url = [NSURL URLWithString:objModelList.strVideoFileUrl];
        UIImage *image = arrVideoThumbImg[selectedDotsBtnIndexPath.row-1];
        
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[text, url, image]
         applicationActivities:nil];
        
        // check if new API supported
        if ([controller respondsToSelector:@selector(completionWithItemsHandler)])
        {
            controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                // When completed flag is YES, user performed specific activity
                
                 NSLog(@"completed dialog - activity: %@ - finished flag: %d returned items: %@", activityType, completed,returnedItems);
            };
        }
        else
        {
            controller.completionHandler = ^(NSString *activityType, BOOL completed) {
                // When completed flag is YES, user performed specific activity
                
                 NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
                
            };
        }
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}


/*
- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return NSLocalizedString(@"Like this!");
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        return NSLocalizedString(@"Retweet this!");
    } else {
        return nil;
    }
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"segueToViedoDetailsFromListVC"])
    {
        VideoDetailsVC *videoVC = segue.destinationViewController;
        videoVC.objModelList = objModelList;
        videoVC.isFromListVC = YES;
    }
}

@end
