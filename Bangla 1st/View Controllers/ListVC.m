//
//  ListVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//


#import "AVPlayerVC.h"

#import "ListVC.h"
#import "Cell_List.h"
#import "Cell_ListAd.h"

#import "CustomDropMenu.h"
#import "DropDownTableViewCell.h"
#import "VideoDetailsVC.h"

#import "ListWebService.h"
#import "ModelList.h"
#import "MemberSubscriptionDetailsWebService.h"
#import "ModelMemberSubscriptionDetails.h"
#import "VideoDetails+CoreDataClass.h"
#import "Constants.h"
#import "FileDownloadInfo.h"

#import "Utilis.h"

@interface ListVC () <UITableViewDelegate,UITableViewDataSource,CustomDropMenuDelegate,NSURLSessionDelegate>
{
    NSMutableArray *arrList,*arrVideoThumbImg;
    ModelList *objModelList;
    Cell_ListAd  *listAdCell;
    CustomDropMenu *dropDownvc;
    Cell_List *btnDotscell;
    NSString *kTestAppAdTagUrl;
    NSIndexPath *selectedDotsBtnIndexPath;
    NSIndexPath *prevIndexPath;
    
    IBOutlet UIView *navBarVwContainer;
    
    AVPlayerVC *avPlayerViewcontroller;
    
    FileDownloadInfo *fdi;
    
    
}

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;

-(void)initializeFileDownloadDataArray:(NSDictionary *)dict;
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrList=[NSMutableArray new];
    arrVideoThumbImg = [NSMutableArray new];
    self.arrFileDownloadData = [NSMutableArray new];
    kTestAppAdTagUrl = self.appDel.objModelAdId.strIMAadTagURL;

    
    [self initWithParentView:navBarVwContainer isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
     [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(ListVCOpenMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self getCategoryDatas];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
    NSString * uniqueId = [NSString stringWithFormat:@"Bangla1stBackgroundUpload:%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:uniqueId];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
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
    
    avPlayerViewcontroller = nil;
    
    
}

- (void)getCategoryDatas
{
    
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
                    
                    NSDictionary *dict = @{@"VideoId":objModelList.strVideoId,@"VideoUrl":objModelList.strVideoFileUrl,@"VideoTitle":objModelList.strVideoTitle};
                    
                    [self initializeFileDownloadDataArray:dict];
                    
                    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark
#pragma mark - Open Left Pannel
#pragma mark

-(void)ListVCOpenMenu
{
    [self.view endEditing:YES];
    [self openLeftPanel];
}

#pragma mark
#pragma mark - initialize FileDownload DataArray
#pragma mark

-(void)initializeFileDownloadDataArray:(NSDictionary *)dict
{
    [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc]initWithFileTitle:dict[@"VideoTitle"] andDownloadSource:dict]];
}

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier
{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}

#pragma mark

#pragma mark
#pragma mark - TableView Delegates and Datasource
#pragma mark

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == _tblList)
    {
        if (dropDownvc !=nil)
        {
            [dropDownvc.view removeFromSuperview];
            // [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
            dropDownvc=nil;
            btnDotscell.VwDropDowncontainer.hidden = YES;
        }
        
        btnDotscell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_icon.png"];
    }
}

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
    
    fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
    
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
        
        if (![self isEmpty:fdi.downloadSource[@"VideoId"]])
        {
            if (!fdi.isDownloading)
            {
                cell.progressVw.hidden = YES;
            }
            else
            {
                cell.progressVw.hidden = NO;
                cell.progressVw.progress = fdi.downloadProgress;
            }
        }
                
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
       // [self performSegueWithIdentifier:@"segueToViedoDetailsFromListVC" sender:nil];
        
        
        [self initializeAndStartActivityIndicator:self.view];
        NSDictionary *videoDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId,@"contentType":@"video",@"contentID":objModelList.strVideoId};
        
        [[MemberSubscriptionDetailsWebService service]callMemberSubscriptionDetailsWebServiceWithDictParams:videoDict success:^(id  _Nullable response, NSString * _Nullable strMsg) {
            
            [self StopActivityIndicator:self.view];
            
            if (response != nil)
            {
                ModelMemberSubscriptionDetails *objModel = [[ModelMemberSubscriptionDetails alloc]initWithDictionary:response[@"ResponseData"]];
                
                int totalLimit = [objModel.strSubscriptionPackageTotalLimit intValue];
                int watchedCount = [objModel.strSubscriptionWatchedVideo intValue];
                
                if (watchedCount < totalLimit)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        avPlayerViewcontroller = [[AVPlayerVC alloc] initWithNibName:@"AVPlayerVC" bundle:nil];
                        [avPlayerViewcontroller.navigationController.navigationBar setHidden:YES];
                        
                        avPlayerViewcontroller.isFromListVC = YES;
                        avPlayerViewcontroller.strVideoURL = objModelList.strVideoFileUrl;
                        avPlayerViewcontroller.strIMAAddURL = kTestAppAdTagUrl;
                        
                        [self presentViewController:avPlayerViewcontroller animated:YES completion:NULL];
                        
                    });

                }
                
                else
                {
                    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"Sorry! You have reached your Video limit.To see more Videos please Subscribe to another Plan" preferredStyle:UIAlertControllerStyleAlert];
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
    
    Cell_List *prevSelectedDotsCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblList];
    selectedDotsBtnIndexPath = [_tblList indexPathForRowAtPoint:buttonPosition];
    btnDotscell = (Cell_List *)[_tblList cellForRowAtIndexPath:selectedDotsBtnIndexPath];
    
    if (prevIndexPath == nil)
    {
        btnDotscell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_red_icon.png"];
    }
    else
    {
        prevSelectedDotsCell = (Cell_List *)[_tblList cellForRowAtIndexPath:prevIndexPath];
        if (selectedDotsBtnIndexPath.row != prevIndexPath.row)
        {
            prevSelectedDotsCell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_icon.png"];
            btnDotscell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_red_icon.png"];
        }
        else
        {
            prevSelectedDotsCell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_red_icon.png"];
            btnDotscell.imageViewThreeDots.image = [UIImage imageNamed:@"dots_red_icon.png"];
        }
    }
    
    
    prevIndexPath = selectedDotsBtnIndexPath;
    
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
                if (self.appDel.isRechable)
                {
                    // Get the FileDownloadInfo object being at the cellIndex position of the array.
                   // fdi = nil;
                    FileDownloadInfo *Objfdi = [self.arrFileDownloadData objectAtIndex:selectedDotsBtnIndexPath.row];
                    
                    if (self.appDel.videoCount <= 2)
                    {
                        if (self.appDel.arrDownloadInfo.count > 0)
                        {
                            NSArray *filtered = [self.appDel.arrDownloadInfo filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.downloadSource.VideoId contains[cd] %@", Objfdi.downloadSource[@"VideoId"]]];
                            
                            if (filtered.count > 0)
                            {
                                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"This Video is already downloading" preferredStyle:UIAlertControllerStyleAlert];
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
                                [self.appDel.arrDownloadInfo addObject:Objfdi];
                                
                                // The isDownloading property of the fdi object defines whether a downloading should be started
                                // or be stopped.
                                if (!Objfdi.isDownloading)
                                {
                                    btnDotscell.btndotsOutlet.userInteractionEnabled = YES;
                                    
                                    // This is the case where a download task should be started.
                                    
                                    // Create a new task, but check whether it should be created using a URL or resume data.
                                    if (Objfdi.taskIdentifier == -1)
                                    {
                                        // If the taskIdentifier property of the fdi object has value -1, then create a new task
                                        // providing the appropriate URL as the download source.
                                        Objfdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:Objfdi.downloadSource[@"VideoUrl"]]];
                                        
                                        // Keep the new task identifier.
                                        Objfdi.taskIdentifier = Objfdi.downloadTask.taskIdentifier;
                                        
                                        NSLog(@"task identifier:%lu",Objfdi.taskIdentifier);
                                        
                                        // Start the task.
                                        [Objfdi.downloadTask resume];
                                    }
                                    else
                                    {
                                        // Create a new download task, which will use the stored resume data.
                                        Objfdi.downloadTask = [self.session downloadTaskWithResumeData:Objfdi.taskResumeData];
                                        [Objfdi.downloadTask resume];
                                        
                                        // Keep the new download task identifier.
                                        Objfdi.taskIdentifier = Objfdi.downloadTask.taskIdentifier;
                                    }
                                }
                                else
                                {
                                    btnDotscell.btndotsOutlet.userInteractionEnabled = NO;
                                    
                                    /*
                                     // Pause the task by canceling it and storing the resume data.
                                     [fdi.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                                     if (resumeData != nil) {
                                     fdi.taskResumeData = [[NSData alloc] initWithData:resumeData];
                                     }
                                     }];
                                     */
                                }
                                
                                // Change the isDownloading property value.
                                Objfdi.isDownloading = !Objfdi.isDownloading;
                                
                                // Reload the table view.
                                [_tblList reloadRowsAtIndexPaths:@[selectedDotsBtnIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }
                        }
                        else
                        {
                            [self.appDel.arrDownloadInfo addObject:Objfdi];
                            
                            // The isDownloading property of the fdi object defines whether a downloading should be started
                            // or be stopped.
                            if (!Objfdi.isDownloading)
                            {
                                btnDotscell.btndotsOutlet.userInteractionEnabled = YES;
                                
                                // This is the case where a download task should be started.
                                
                                // Create a new task, but check whether it should be created using a URL or resume data.
                                if (Objfdi.taskIdentifier == -1)
                                {
                                    // If the taskIdentifier property of the fdi object has value -1, then create a new task
                                    // providing the appropriate URL as the download source.
                                    Objfdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:Objfdi.downloadSource[@"VideoUrl"]]];
                                    
                                    // Keep the new task identifier.
                                    Objfdi.taskIdentifier = Objfdi.downloadTask.taskIdentifier;
                                    
                                    NSLog(@"task identifier:%lu",Objfdi.taskIdentifier);
                                    
                                    // Start the task.
                                    [Objfdi.downloadTask resume];
                                }
                                else{
                                    // Create a new download task, which will use the stored resume data.
                                    Objfdi.downloadTask = [self.session downloadTaskWithResumeData:Objfdi.taskResumeData];
                                    [Objfdi.downloadTask resume];
                                    
                                    // Keep the new download task identifier.
                                    Objfdi.taskIdentifier = Objfdi.downloadTask.taskIdentifier;
                                }
                            }
                            else
                            {
                                btnDotscell.btndotsOutlet.userInteractionEnabled = NO;
                                
                                /*
                                 // Pause the task by canceling it and storing the resume data.
                                 [fdi.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                                 if (resumeData != nil) {
                                 fdi.taskResumeData = [[NSData alloc] initWithData:resumeData];
                                 }
                                 }];
                                 */
                            }
                            
                            // Change the isDownloading property value.
                            Objfdi.isDownloading = !Objfdi.isDownloading;
                            
                            // Reload the table view.
                            [_tblList reloadRowsAtIndexPaths:@[selectedDotsBtnIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
            
                    }
                    else
                    {
                        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:@"Sorry! You can download only 3 videos for offline viewing" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alertController dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }];
                        [alertController addAction:actionOK];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                }
                                
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
            controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                if (completed)
                {
                    NSLog(@"The Activity: %@ was completed", activityType);
                }
                else
                {
                    NSLog(@"The Activity: %@ was NOT completed", activityType);
                };
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

#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [self.docDirectoryURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success)
    {
        // Change the flag values of the respective FileDownloadInfo object.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *ObjFileDwnldInfo = [self.arrFileDownloadData objectAtIndex:index];
        
        ObjFileDwnldInfo.isDownloading = NO;
        ObjFileDwnldInfo.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        ObjFileDwnldInfo.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        ObjFileDwnldInfo.taskResumeData = nil;
        
        self.appDel.videoCount++;
        
        NSString *encodedURL = [[downloadTask.originalRequest.URL absoluteString] stringByRemovingPercentEncoding];
        NSArray *filtered = [arrList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.strVideoFileUrl contains[cd] %@", encodedURL]];
        
        if (filtered.count > 0)
        {
            objModelList = [filtered objectAtIndex:0];
            
            // int idx = (int) [arrList indexOfObject:objModelList];
            
            // NSIndexPath *completedDwnloadIndxPath = [NSIndexPath indexPathForRow:idx inSection:0];
            
            //Cell_List *completedDwnloadListCell = (Cell_List *)[_tblList cellForRowAtIndexPath:completedDwnloadIndxPath];
            
            // completedDwnloadListCell.progressVw.hidden = YES;
            
            
            [VideoDetails createInManagedObjectContextWithVideoURL:objModelList.strVideoFileUrl  videoAssetURL:[destinationURL absoluteString] videoID:objModelList.strVideoId videoDate:[NSDate date] title:objModelList.strVideoTitle description:objModelList.strVideoDescription duration:objModelList.strVideoDuration postedTime:objModelList.strPostedTime views:objModelList.strViews likes:objModelList.strLikes commentCount:objModelList.strCommentCount thumbImageURL:objModelList.strThumbImageUrl managedObjectContext:[self managedObjectContext]];
            
            
            NSError *DBerror = nil;
            // Save the object to persistent store
            if (![[self managedObjectContext] save:&DBerror])
            {
                NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
            }
            else
            {
                NSLog(@"Data Saved Successfully.");
                
                NSArray *filtered = [self.appDel.arrDownloadInfo filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.downloadSource.VideoId contains[cd] %@", fdi.downloadSource[@"VideoId"]]];
                
                if (filtered.count > 0)
                {
                    [self.appDel.arrDownloadInfo removeObjectsInArray:filtered];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",self.appDel.videoCount]];
                
                // Reload the respective table view row using the main thread.
                [_tblList reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                withRowAnimation:UITableViewRowAnimationNone];
                
            });
            
        }
    }
    else
    {
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *ObjFileDwnldInfo = [self.arrFileDownloadData objectAtIndex:index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Calculate the progress.
            ObjFileDwnldInfo.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            
            // Get the progress view of the appropriate cell and update its progress.
            Cell_List *cell = [_tblList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            UIProgressView *progressView = cell.progressVw;
            progressView.progress = ObjFileDwnldInfo.downloadProgress;
        });
        
    }
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (self.appDel.backgroundSessionCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = self.appDel.backgroundSessionCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                self.appDel.backgroundSessionCompletionHandler = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                });
                
            }
        }
    }];
}


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
