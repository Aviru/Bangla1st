//
//  HomeVC.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "HomeVC.h"

@import AVFoundation;
@import GoogleInteractiveMediaAds;
#import <AVKit/AVKit.h>

#import "Cell_Ad.h"
#import "Cell_Video.h"
#import "Cell_Header.h"
#import "Cell_contents.h"

#import "ImageScrollingCellView.h"
#import "CustomDropMenu.h"

#import "ContentListingWebService.h"
#import "MemberSubscriptionDetailsWebService.h"
#import "ModelContentListing.h"
#import "ModelMemberSubscriptionDetails.h"

#import "Utilis.h"

#import "UIImageView+WebCache.h"

#import "DEMORootVC.h"

#import "FileDownloadInfo.h"
#import "VideoDetails+CoreDataClass.h"
#import "CustomProgressView.h"


@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,AVPlayerViewControllerDelegate,IMAAdsLoaderDelegate, IMAAdsManagerDelegate,ImageScrollingViewDelegate,CustomDropMenuDelegate,CustomProgressViewDelegate,NSURLSessionDelegate>
{
    NSArray *arrContentTitles;
    
    NSMutableArray *arrContents ,*arrVideoThumbImg;
    
    ModelContentListing *objContentListing;
    //FWSwipePlayerViewController *playerController;
    BOOL shouldRotate, isVideoplaying,isPlayerFrameAlreadySet,isCollectionVwInitialized;
    Cell_Video *videoCell;
    NSString *kTestAppAdTagUrl;
    
    IBOutlet UIView *VwDropDownContainer;
    
    IBOutlet UIView *navBarVwContainer;
    
    CustomDropMenu *dropDownvc;
    CustomProgressView *customProgressView;
    NSIndexPath *selectedDotsBtnIndexPath;
    
    FileDownloadInfo *fdi;
    
}

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;

//@property (nonatomic, strong) FWDraggablePlayerManager *playerManager;

@property (nonatomic, strong) AVPlayerViewController *avPlayerViewcontroller;
@property(strong, nonatomic) ImageScrollingCellView *imageScrollingView;

// SDK
/// Entry point for the SDK. Used to make ad requests.
@property(nonatomic, strong) IMAAdsLoader *adsLoader;

/// Main point of interaction with the SDK. Created by the SDK as the result of an ad request.
@property(nonatomic, strong) IMAAdsManager *adsManager;

/// Playhead used by the SDK to track content video progress and insert mid-rolls.
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;

@end

@implementation HomeVC

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
    
    arrContents = [[NSMutableArray alloc] init];
    arrVideoThumbImg = [NSMutableArray new];
    self.arrFileDownloadData = [NSMutableArray new];
    shouldRotate = NO;
    selectedDotsBtnIndexPath = 0;
    
    [self getOfflineSavedVideoCount];
    
    if (self.appDel.videoCount > 0)
    {
         [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",self.appDel.videoCount]];
    }
    
    
    kTestAppAdTagUrl = self.appDel.objModelAdId.strIMAadTagURL;
    
    [self initWithParentView:navBarVwContainer isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:YES navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"menu_white_icon.png" leftLabelName:@"  Bangla1st" rightImageName:@"Search_white_icon.png" rightLabelName:nil];
    
     [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(openmenu) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     0-Top Ad And Top VIdeo
     1-Editor Pick Video
     2-Featured Video
     3-Recent Video
     4-Featured Picture
     5-Featured Audio
     
     */

    
    [self getContentDatas];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    
    NSString * uniqueId = [NSString stringWithFormat:@"Bangla1stBackgroundUpload:%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:uniqueId];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];

    
     [self setupAdsLoader];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.appDel.isAdRequested = NO;
    
    isPlayerFrameAlreadySet = NO;
    
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
        
    }
    
    [self.avPlayerViewcontroller.view removeFromSuperview];
    
    self.avPlayerViewcontroller = nil;
    
    self.adsLoader = nil;
    
    self.adsManager = nil;
    
    self.contentPlayhead = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Open Left Pannel
#pragma mark

-(void)openmenu
{
    [self.view endEditing:YES];
    [self openLeftPanel];
    
}


#pragma mark
#pragma mark Content Listing Webservice
#pragma mark

- (void)getContentDatas{
   
    [self initializeAndStartActivityIndicator:self.view];
    
    NSDictionary *dictParams= @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",
                                };
    
    [[ContentListingWebService service]callContentListingWebServiceWithDictParams:dictParams success:^(id _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            for (int i = 0; i< [response[@"ResponseData"] count]; i++)
            {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                for (int  j =0; j<[response[@"ResponseData"][i] count]; j++)
                {
                    if (i == 0 && j == 1)
                    {
                        objContentListing = [[ModelContentListing alloc]initWithDictionary:response[@"ResponseData"][0][1] isTypeAd:YES];
                    }
                    
                    else if (i == 1 && j == 1)
                    {
                        objContentListing = [[ModelContentListing alloc]initWithDictionary:response[@"ResponseData"][1][1] isTypeAd:YES];
                    }
                    else
                    {
                     objContentListing = [[ModelContentListing alloc]initWithDictionary:response[@"ResponseData"][i][j] isTypeAd:NO];
                    }
                    
                    [arr addObject:objContentListing];
                    
                    NSDictionary *dict = @{@"VideoId":objContentListing.strVideoId,@"VideoUrl":objContentListing.strVideoFileUrl,@"VideoTitle":objContentListing.strVideoTitle};
                    
                    [self initializeFileDownloadDataArray:dict];
                }
                
                [arrContents addObject:arr];
            }
            
            NSLog(@"arrContents:%@",arrContents);
            
            
          //  arrContents = response[@"ResponseData"];
            arrContentTitles = @[@"Recent Films",@"Now Trending",@"Most Popular"/*,@"Featured Pictures",@"Featured Audios"*/];
            [_tblHome reloadData];
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
        
        [self StopActivityIndicator:self.view];
       // _activity.hidden=YES;
        
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

#pragma mark

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
#pragma mark SDK Setup
#pragma mark

- (void)setupAdsLoader {
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    self.adsLoader.delegate = self;
}
#pragma mark

#pragma mark
#pragma mark - Set up AVPlayerViewControler as ContentPlayer
#pragma mark

- (void)setUpContentPlayerWithUrl:(NSString *)videoUrl playerFrame:(CGRect)playerRect
{
    
    if (!isPlayerFrameAlreadySet)
    {
        isPlayerFrameAlreadySet = YES;
        
        self.avPlayerViewcontroller = [[AVPlayerViewController alloc] init];
        [self.avPlayerViewcontroller.navigationController.navigationBar setHidden:YES];
        
        
        //self.avPlayerViewcontroller.view.frame = CGRectMake(0,0, playerRect.size.width, playerRect.size.height);
        
        self.avPlayerViewcontroller.player =  [AVPlayer playerWithURL:[NSURL URLWithString:videoUrl]];
        
        //self.avPlayerViewcontroller.showsPlaybackControls = YES;
       // self.avPlayerViewcontroller.view.hidden = NO;
        
        
        // Set up our content playhead and contentComplete callback.
        self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.avPlayerViewcontroller.player];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.avPlayerViewcontroller.player.currentItem];
        
        // [self presentViewController:self.avPlayerViewcontroller animated:NO completion:NULL];
        
       // [videoCell.vwVideoContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
       // [self.avPlayerViewcontroller.view setTranslatesAutoresizingMaskIntoConstraints:YES];
//        [videoCell.vwVideoContainer addSubview: [self.avPlayerViewcontroller view]];
        
        
    }
    else
    {
        self.avPlayerViewcontroller.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoUrl]];
        
       // self.avPlayerViewcontroller.showsPlaybackControls = YES;
        self.avPlayerViewcontroller.view.hidden = NO;
        
        // Set up our content playhead and contentComplete callback.
        self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.avPlayerViewcontroller.player];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.avPlayerViewcontroller.player.currentItem];
        
        
    }
    
    
    [self addChildViewController:self.avPlayerViewcontroller];
    [videoCell.vwVideoContainer addSubview:self.avPlayerViewcontroller.view];
    self.avPlayerViewcontroller.view.frame = videoCell.vwVideoContainer.frame;
    
    [self.avPlayerViewcontroller.player play];

}


- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == self.avPlayerViewcontroller.player.currentItem) {
        
        isVideoplaying = NO;
        self.avPlayerViewcontroller.view.hidden = YES;
        [videoCell.imgVwVideoThumb sd_setImageWithURL:[NSURL URLWithString:objContentListing.strThumbImageUrl]
                                placeholderImage:nil];
        [self.adsLoader contentComplete];
    }
}

#pragma mark


#pragma mark
#pragma mark - Request Ad
#pragma mark

- (void)requestAds {
    // Create an ad display container for ad rendering.
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:self.avPlayerViewcontroller.view companionSlots:nil];
    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:kTestAppAdTagUrl
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:self.contentPlayhead
                                                         userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
}

#pragma mark

#pragma mark
#pragma mark AdsLoader Delegates
#pragma mark

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    self.adsManager = adsLoadedData.adsManager;
    self.adsManager.delegate = self;
    // Create ads rendering settings to tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.webOpenerPresentingController = self;
    // Initialize the ads manager.
    [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    [self.avPlayerViewcontroller.player play];
}

#pragma mark
#pragma mark AdsManager Delegates
#pragma mark

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    if (event.type == kIMAAdEvent_LOADED) {
        [adsManager start];
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    NSLog(@"AdsManager error: %@", error.message);
    [self.avPlayerViewcontroller.player play];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [self.avPlayerViewcontroller.player pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    [self.avPlayerViewcontroller.player play];
}

#pragma mark


#pragma mark
#pragma mark - TableView Delegates and Datasource
#pragma mark

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == _tblHome)
    {
        if (dropDownvc !=nil)
        {
            [dropDownvc.view removeFromSuperview];
            // [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
            dropDownvc=nil;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return arrContentTitles.count*2; // header is also a type of cell
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 55;
            break;
        case 1:
            return 230;
            break;
        case 2:
            if(indexPath.row%2==0){
                return 50;
            }else{
                return 150;
            }
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            Cell_Ad *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Ad" forIndexPath:indexPath];
            
            if (arrContents.count)
            {
                [cell.ivBanner sd_setImageWithURL:[NSURL URLWithString:[arrContents[0][1]strAdCodeUrl]]
                                 placeholderImage:nil];
            }
            
          
          /*
            NSDictionary *content = [arrContents firstObject][1];
              if ([Utilis containsKey:@"adID" :content]){
                // its a ad
                NSString *strAdThumb = content[@"adCode"];
 
                [cell.ivBanner sd_setImageWithURL:[NSURL URLWithString:strAdThumb]
                             placeholderImage:nil];
            }
           */
            
            return cell;
        }
            break;
        case 1:
        {
            Cell_Video *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Video" forIndexPath:indexPath];
            
            if (isVideoplaying)
            {
                // player is playing
            }
            else
            {
                if (arrContents.count)
                {
                    [cell.imgVwVideoThumb sd_setImageWithURL:[NSURL URLWithString:[arrContents[0][0]strThumbImageUrl]]
                                            placeholderImage:nil
                                                     options:SDWebImageHighPriority
                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                        
                                                    }
                                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                       
                                                       [arrVideoThumbImg addObject:image];
                                                       
                                                   }];
                }
                
                cell.btnPlayPauseOutlet.hidden = NO;
                
                [cell.btnPlayPauseOutlet addTarget:self action:@selector(btnPlayPause:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.btnMaximize addTarget:self action:@selector(btnMaximize:) forControlEvents:UIControlEventTouchUpInside];
            }
            
           
            
            return cell;
        }
            break;
        case 2:
        {
           
            if(indexPath.row%2==0)
            {
               Cell_Header *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Header" forIndexPath:indexPath];
                cell.lblHeadertitle.text =[arrContentTitles objectAtIndex:(indexPath.row/2)];
                
                if(indexPath.row==0){
                    cell.btnMore.hidden=YES;
                   // cell.lblHeadertitle.textColor= [UIColor colorWithRed:255/255.0 green:83/255.0 blue:31/255.0 alpha:1];
                }else{
                    cell.btnMore.hidden=NO;
                   // cell.lblHeadertitle.textColor= [UIColor blackColor];
                }
                 return cell;
            }
            else
            {
               Cell_contents *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_contents" forIndexPath:indexPath];
                
              //  _imageScrollingView.delegate = self;
                NSMutableArray *catContents= [arrContents mutableCopy];
                [catContents removeObjectAtIndex:0];
                
                cell.imageScrollingView.delegate = self;
                
                cell.imageScrollingView.collectionContent = catContents[indexPath.row/2];
                
                 return cell;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
        {
            
        }
            break;
        case 2:
            break;
            
        default:
            break;
    }
  
}

#pragma mark

#pragma mark
#pragma mark - ImageScrollingCellView Delegate
#pragma mark

- (void)collectionView:(UICollectionView  *)collectionView didTapOnDotsButtonAtIndexPath:(NSIndexPath*)indexPath withCollectionVwCell:(CollectionCell_Video *)selectedCollectionVwCell withSelectedContent:(ModelContentListing *)objSelectedContent
{
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
    }
    
    objContentListing = objSelectedContent;
        
    selectedDotsBtnIndexPath = [collectionView indexPathForCell:selectedCollectionVwCell];
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellFrameInSuperview = [collectionView convertRect:attributes.frame toView:[[_tblHome superview] superview]];
    
    NSLog(@"Y of Cell is: %f", cellFrameInSuperview.origin.y);
    NSLog(@"X of Cell is: %f", cellFrameInSuperview.origin.x);
    
    float tabBarHeight = self.tabBarController.tabBar.frame.size.height;

    /*
    CGRect rectOfCellInTableView = [_tblHome rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [collectionView convertRect: rectOfCellInTableView toView:_tblHome.superview];
     NSLog(@"Y of Cell is: %f", rectOfCellInSuperview.origin.y);
     NSLog(@"X of Cell is: %f", rectOfCellInSuperview.origin.x);
     */
    
    Cell_contents *cell =  (Cell_contents *)[[[[selectedCollectionVwCell superview] superview] superview] superview];
    
    NSLog(@"%f",cell.frame.origin.y);
    NSLog(@"%f",cell.frame.size.height);
    NSLog(@"%f",selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x);
     NSLog(@"%f",selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height);
    
    dropDownvc = [[CustomDropMenu alloc] initWithNibName:@"CustomDropMenu" bundle:nil];
    
   // dropDownvc.view.frame = CGRectMake(cellFrameInSuperview.origin.x + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
    
  //  dropDownvc.view.frame = CGRectMake(selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x, (cell.frame.origin.y + cell.frame.size.height + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:dropDownvc.view];
    
    NSLog(@"cellFrameInSuperview.origin.y:%f",cellFrameInSuperview.origin.y);
     NSLog(@"([UIScreen mainScreen].bounds.size.height - tabBarHeight)-cell.frame.size.height-50:%f",([UIScreen mainScreen].bounds.size.height - tabBarHeight)-cell.frame.size.height-50);
    
    
     NSLog(@"selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x: %f",selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x);
     NSLog(@"[[UIApplication sharedApplication] keyWindow].frame.size.width/2: %f",[[UIApplication sharedApplication] keyWindow].frame.size.width/2);
    
    
    if (cellFrameInSuperview.origin.y > ([UIScreen mainScreen].bounds.size.height - tabBarHeight)-cell.frame.size.height-10)
    {
        
        if (selectedCollectionVwCell.frame.origin.x > [[UIApplication sharedApplication] keyWindow].frame.size.width/2)
        {
            dropDownvc.view.frame = CGRectMake([[UIApplication sharedApplication] keyWindow].frame.size.width - 201, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y-72), 201,72);
        }
        else
        {
            dropDownvc.view.frame = CGRectMake(selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y-72), 201,72);
        }
    }
    else
    {
        if (selectedCollectionVwCell.frame.origin.x > [[UIApplication sharedApplication] keyWindow].frame.size.width/2)
        {
             dropDownvc.view.frame = CGRectMake([[UIApplication sharedApplication] keyWindow].frame.size.width - 201, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
        }
        else
        {
             dropDownvc.view.frame = CGRectMake(selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
        }
      
    }
   
    /*
    if (!CGRectEqualToRect(CGRectIntersection([[UIApplication sharedApplication] keyWindow].screen.bounds, dropDownvc.view.frame), dropDownvc.view.frame))
    {
        //view is partially out of bounds
        NSLog(@"view is partially out of bounds");
        
        dropDownvc.view.frame = CGRectMake([[UIApplication sharedApplication] keyWindow].frame.size.width - 201, (cellFrameInSuperview.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
    }
     */
    

    
    dropDownvc.delegate=self;
}

- (void)collectionView:(ImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath withSelectedContent:(ModelContentListing *)objSelectedContent
{
   NSIndexPath *VideoPlayerIndx = [NSIndexPath indexPathForRow:0 inSection:1];
    
    videoCell = (Cell_Video *)[_tblHome cellForRowAtIndexPath:VideoPlayerIndx];
    
    CGRect rectOfCellInTableView = [_tblHome rectForRowAtIndexPath: VideoPlayerIndx];
    CGRect rectOfCellInSuperview = [_tblHome convertRect: rectOfCellInTableView toView: _tblHome.superview];
    
    objContentListing = objSelectedContent;
    
    if (![self isEmpty:objSelectedContent.strVideoId])
    {
    
        [self initializeAndStartActivityIndicator:self.view];
        NSDictionary *videoDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId,@"contentType":@"video",@"contentID":objContentListing.strVideoId};
        
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
                        
                        isVideoplaying = YES;
                        
                        
                        // [_tblHome reloadRowsAtIndexPaths:@[VideoPlayerIndx] withRowAnimation:UITableViewRowAnimationTop];
                        
                        [_tblHome scrollToRowAtIndexPath:VideoPlayerIndx
                                        atScrollPosition:UITableViewScrollPositionTop
                                                animated:YES];
                        
                        if (_adsManager)
                        {
                            _adsManager = nil;
                            [self.adsLoader contentComplete];
                            [self setupAdsLoader];
                            
                            self.avPlayerViewcontroller.player.rate = 0;
                        }
                        
                        [self setUpContentPlayerWithUrl:objContentListing.strVideoFileUrl playerFrame:rectOfCellInSuperview];
                        
                        
                        [self requestAds];
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
    
    else if (![self isEmpty:objSelectedContent.strAdId])
    {
    }
    
   
}

-(void)removeDropDown
{
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
    }
}

#pragma mark
#pragma mark - Custom Drop Down Delegate
#pragma mark

- (void)didSelectDotsButtonAtIndexPath:(NSIndexPath*)indexPath dropDownSelctedCell:(DropDownTableViewCell *)dropDwnCell 
{
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
        [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
        
    }
    
    ///DOWNLOAD
    if (indexPath.row == 0)
    {
         NSMutableArray *results = [VideoDetails fetchVideoDetailsWithEntityName:@"VideoDetails" predicateName:@"videoID" predicateValue:objContentListing.strVideoId managedObjectContext:[self managedObjectContext]];
        
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
                fdi = [self.arrFileDownloadData objectAtIndex:selectedDotsBtnIndexPath.row];
                
                if (self.appDel.videoCount <= 2)
                {
                    
                    if (self.appDel.arrDownloadInfo.count > 0)
                    {
                        NSArray *filtered = [self.appDel.arrDownloadInfo filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.downloadSource.VideoId contains[cd] %@", fdi.downloadSource[@"VideoId"]]];
                        
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
                            // The isDownloading property of the fdi object defines whether a downloading should be started
                            // or be stopped.
                            if (!fdi.isDownloading)
                            {
                                // This is the case where a download task should be started.
                                
                                customProgressView = [[CustomProgressView alloc] init];
                                customProgressView.delegate = self;
                                [[[UIApplication sharedApplication] keyWindow] addSubview:customProgressView];
                                
                                // Create a new task, but check whether it should be created using a URL or resume data.
                                if (fdi.taskIdentifier == -1) {
                                    // If the taskIdentifier property of the fdi object has value -1, then create a new task
                                    // providing the appropriate URL as the download source.
                                    fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource[@"VideoUrl"]]];
                                    
                                    // Keep the new task identifier.
                                    fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                                    
                                    NSLog(@"task identifier:%lu",fdi.taskIdentifier);
                                    
                                    // Start the task.
                                    [fdi.downloadTask resume];
                                }
                                else
                                {
                                    // Create a new download task, which will use the stored resume data.
                                    fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
                                    [fdi.downloadTask resume];
                                    
                                    // Keep the new download task identifier.
                                    fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                                }
                            }
                            else
                            {
                                
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
                            fdi.isDownloading = !fdi.isDownloading;
                        }
                        
                    }
                    else
                    {
                        // The isDownloading property of the fdi object defines whether a downloading should be started
                        // or be stopped.
                        if (!fdi.isDownloading)
                        {
                            // This is the case where a download task should be started.
                            
                            customProgressView = [[CustomProgressView alloc] init];
                            customProgressView.delegate = self;
                            [[[UIApplication sharedApplication] keyWindow] addSubview:customProgressView];
                            
                            // Create a new task, but check whether it should be created using a URL or resume data.
                            if (fdi.taskIdentifier == -1) {
                                // If the taskIdentifier property of the fdi object has value -1, then create a new task
                                // providing the appropriate URL as the download source.
                                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource[@"VideoUrl"]]];
                                
                                // Keep the new task identifier.
                                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                                
                                NSLog(@"task identifier:%lu",fdi.taskIdentifier);
                                
                                // Start the task.
                                [fdi.downloadTask resume];
                            }
                            else
                            {
                                // Create a new download task, which will use the stored resume data.
                                fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
                                [fdi.downloadTask resume];
                                
                                // Keep the new download task identifier.
                                fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                            }
                        }
                        else
                        {
                            
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
                        fdi.isDownloading = !fdi.isDownloading;  
                    }
                }
            }
        }
    }
    
    ///SHARE
    else
    {
        NSString *text = objContentListing.strVideoTitle;
        NSURL *url = [NSURL URLWithString:objContentListing.strVideoFileUrl];
       // UIImage *image = arrVideoThumbImg[selectedDotsBtnIndexPath.row-1];
        
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[text, url]
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


#pragma mark
#pragma mark Button Action
#pragma mark

-(void)btnPlayPause:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblHome];
    NSIndexPath *indexPath = [_tblHome indexPathForRowAtPoint:buttonPosition];
    videoCell = (Cell_Video *)[_tblHome cellForRowAtIndexPath:indexPath];
    
    CGRect rectOfCellInTableView = [_tblHome rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [_tblHome convertRect: rectOfCellInTableView toView: _tblHome.superview];
    
    objContentListing = arrContents[0][0];
    
    /*
    if (_adsManager)
    {
        _adsManager = nil;
        [self.adsLoader contentComplete];
        [self setupAdsLoader];
        
        self.avPlayerViewcontroller.view.hidden = NO;
    }
    
    [self setUpContentPlayerWithUrl:[arrContents[0][0] strVideoFileUrl] playerFrame:rectOfCellInSuperview];
    
    [self requestAds];
    */

    [self initializeAndStartActivityIndicator:self.view];
    NSDictionary *videoDict = @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a",USERID:self.appDel.objModelUserInfo.strUserId,@"contentType":@"video",@"contentID":objContentListing.strVideoId};
    
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
                    
                    if (_adsManager)
                    {
                        _adsManager = nil;
                        [self.adsLoader contentComplete];
                        [self setupAdsLoader];
                        
                        self.avPlayerViewcontroller.view.hidden = NO;
                    }
                    
                    [self setUpContentPlayerWithUrl:[arrContents[0][0] strVideoFileUrl] playerFrame:rectOfCellInSuperview];
                    
                    [self requestAds];
                    
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
    
   
  
    //[self.avPlayerViewcontroller.player play];
    

}

-(void)btnMaximize:(id)sender
{
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tblHome];
    //NSIndexPath *indexPath = [_tblHome indexPathForRowAtPoint:buttonPosition];
   // videoCell = (Cell_Video *)[_tblHome cellForRowAtIndexPath:indexPath];
    
   // [self changePlayerFrameToFullScreen];
}


//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

-(BOOL)shouldAutorotate {
    return NO;
}


#pragma mark

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
        fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;
        
        self.appDel.videoCount++;
        
//        NSString *encodedURL = [[downloadTask.originalRequest.URL absoluteString] stringByRemovingPercentEncoding];
//        NSArray *filtered = [arrContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.strVideoFileUrl contains[cd] %@", encodedURL]];
//        
//        if (filtered.count > 0)
//        {
           // objContentListing = [filtered objectAtIndex:0];
            
            [VideoDetails createInManagedObjectContextWithVideoURL:objContentListing.strVideoFileUrl  videoAssetURL:[destinationURL absoluteString] videoID:objContentListing.strVideoId videoDate:[NSDate date] title:objContentListing.strVideoTitle description:objContentListing.strVideoDescription duration:objContentListing.strVideoDuration postedTime:objContentListing.strPostedTime views:objContentListing.strViews likes:objContentListing.strLikes commentCount:objContentListing.strCommentCount thumbImageURL:objContentListing.strThumbImageUrl managedObjectContext:[self managedObjectContext]];
            
            
            NSError *DBerror = nil;
            // Save the object to persistent store
            if (![[self managedObjectContext] save:&DBerror])
            {
                NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
            }
            else
            {
                NSLog(@"Data Saved Successfully.");
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",self.appDel.videoCount]];
                
            });
            
       // }
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
        fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
             // Calculate the progress.
            float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
            NSDate *stopTime = [NSDate date];
            NSTimeInterval executionTime = [stopTime timeIntervalSinceDate:[NSDate date]];
            NSLog(@"Progress =%f",progress);
            NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes. time (s): %.1f \n",
                  bytesWritten, totalBytesWritten, totalBytesExpectedToWrite,executionTime);
            [customProgressView performSelectorOnMainThread:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:NO];
            
            
        });
        
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    
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

#pragma mark

#pragma mark -
#pragma mark Custom Progress View Delegate
#pragma mark

- (void)didFinishAnimation:(CustomProgressView*)progressView
{
    [progressView removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
