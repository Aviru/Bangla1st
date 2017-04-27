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
#import "ModelContentListing.h"

#import "Utilis.h"

#import "UIImageView+WebCache.h"

#import "DEMORootVC.h"


@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,AVPlayerViewControllerDelegate,IMAAdsLoaderDelegate, IMAAdsManagerDelegate,ImageScrollingViewDelegate,CustomDropMenuDelegate>
{
    NSArray *arrContentTitles;
    
    NSMutableArray *arrContents;
    
    ModelContentListing *objContentListing;
    //FWSwipePlayerViewController *playerController;
    BOOL shouldRotate, isVideoplaying,isPlayerFrameAlreadySet,isCollectionVwInitialized;
    Cell_Video *videoCell;
    NSString *kTestAppAdTagUrl;
    
    IBOutlet UIView *VwDropDownContainer;
    
    IBOutlet UIView *navBarVwContainer;
    
    CustomDropMenu *dropDownvc;
    
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrContents = [[NSMutableArray alloc] init];
    shouldRotate = NO;
    
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
    
     [self setupAdsLoader];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.appDel.isAdRequested = NO;
    
    isPlayerFrameAlreadySet = NO;
    
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
    

    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
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
        
        self.avPlayerViewcontroller.showsPlaybackControls = YES;
       // self.avPlayerViewcontroller.view.hidden = NO;
        
        
        // Set up our content playhead and contentComplete callback.
        self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.avPlayerViewcontroller.player];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.avPlayerViewcontroller.player.currentItem];
        
        // [self presentViewController:self.avPlayerViewcontroller animated:NO completion:NULL];
        
//        [videoCell.vwVideoContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.avPlayerViewcontroller.view setTranslatesAutoresizingMaskIntoConstraints:YES];
//        [videoCell.vwVideoContainer addSubview: [self.avPlayerViewcontroller view]];
        
        
    }
    else
    {
        self.avPlayerViewcontroller.player = [AVPlayer playerWithURL:[NSURL URLWithString:videoUrl]];
        
        self.avPlayerViewcontroller.showsPlaybackControls = YES;
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
                                            placeholderImage:nil];
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

- (void)collectionView:(UICollectionView  *)collectionView didTapOnDotsButtonAtIndexPath:(NSIndexPath*)indexPath withCollectionVwCell:(CollectionCell_Video *)selectedCollectionVwCell
{
    if (dropDownvc !=nil)
    {
        [dropDownvc.view removeFromSuperview];
       // [[[[UIApplication sharedApplication] delegate]window] setNeedsLayout];
        dropDownvc=nil;
    }
    
    Cell_contents *cell =  (Cell_contents *)[[[[selectedCollectionVwCell superview] superview] superview] superview];
    
    NSLog(@"%f",cell.frame.origin.y);
    NSLog(@"%f",cell.frame.size.height);
    NSLog(@"%f",selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.y);
     NSLog(@"%f",selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height);
    
    dropDownvc = [[CustomDropMenu alloc] initWithNibName:@"CustomDropMenu" bundle:nil];
    dropDownvc.view.frame = CGRectMake(selectedCollectionVwCell.btnThreedotsOutlet.frame.origin.x, (cell.frame.origin.y + cell.frame.size.height + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height + selectedCollectionVwCell.btnThreedotsOutlet.frame.size.height), 201,72);
    [[[UIApplication sharedApplication] keyWindow] addSubview:dropDownvc.view];
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
        
         [self setUpContentPlayerWithUrl:objSelectedContent.strVideoFileUrl playerFrame:rectOfCellInSuperview];
        
        
        [self requestAds];
        
       
        
        /*
        if (!self.appDel.isAdRequested)
        {
            self.appDel.isAdRequested = YES;
            
            [self requestAds];

        }
         */
        
       // [self.avPlayerViewcontroller.player play];
        
    }
    
    else if (![self isEmpty:objSelectedContent.strAdId])
    {
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
    
   
    
    if (_adsManager)
    {
        _adsManager = nil;
        [self.adsLoader contentComplete];
         [self setupAdsLoader];
        
        self.avPlayerViewcontroller.view.hidden = NO;
    }
    
     [self setUpContentPlayerWithUrl:[arrContents[0][0] strVideoFileUrl] playerFrame:rectOfCellInSuperview];
    
    [self requestAds];
  
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
