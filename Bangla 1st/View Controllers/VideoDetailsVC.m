//
//  VideoDetailsVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

@import AVFoundation;
@import GoogleInteractiveMediaAds;
#import <AVKit/AVKit.h>

#import "VideoDetailsVC.h"
#import "AVPlayerVC.h"

static NSString * const kBoundsProperty = @"bounds";
static void * kBoundsContext = &kBoundsContext;

@interface VideoDetailsVC ()<IMAAdsManagerDelegate,IMAAdsLoaderDelegate>
{
    
    IBOutlet UIView *VwNavBarContainer;
    
    IBOutlet UIView *videoPlayerContainerVw;
    
    IBOutlet UILabel *lblLikes;
    
    IBOutlet UILabel *lblViews;
    
    IBOutlet UILabel *lblComments;
    
    IBOutlet UILabel *lblVideoTitle;
    
    IBOutlet UILabel *lblVideoDescription;
    
    IBOutlet UILabel *lblVideoPostedTime;
    
    
    NSString *kTestAppAdTagUrl;
    
    AVPlayerVC *avPlayerViewcontroller;
    
}

// SDK
/// Entry point for the SDK. Used to make ad requests.
@property(nonatomic, strong) IMAAdsLoader *adsLoader;

/// Main point of interaction with the SDK. Created by the SDK as the result of an ad request.
@property(nonatomic, strong) IMAAdsManager *adsManager;

/// Playhead used by the SDK to track content video progress and insert mid-rolls.
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;

@end

@implementation VideoDetailsVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     kTestAppAdTagUrl = self.appDel.objModelAdId.strIMAadTagURL;
    
    [self initWithParentView:VwNavBarContainer isTranslateToAutoResizingMaskNeeded:NO leftButton:YES rightButton:NO navigationTitle:nil navigationTitleTextAlignment:NSTextAlignmentCenter navigationTitleFontType:nil leftImageName:@"back_arrow.png" leftLabelName:@" Back" rightImageName:nil rightLabelName:nil];
    
    [self.navBar.navBarLeftButtonOutlet addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    lblLikes.text = [NSString stringWithFormat:@"(%@ Likes)",_objModelList.strLikes];
    lblViews.text = [NSString stringWithFormat:@"(%@ Views)",_objModelList.strViews];
    lblComments.text = [NSString stringWithFormat:@"(%@ Comments)",_objModelList.strCommentCount];
    
    lblVideoTitle.text = [NSString stringWithFormat:@"%@",_objModelList.strVideoTitle];
    lblVideoDescription.text = [NSString stringWithFormat:@"%@",_objModelList.strVideoDescription];
    lblVideoPostedTime.text = [NSString stringWithFormat:@"%@",_objModelList.strPostedTime];
    
    [self setupAdsLoader];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    avPlayerViewcontroller = [[AVPlayerVC alloc] initWithNibName:@"AVPlayerVC" bundle:nil];
    [avPlayerViewcontroller.navigationController.navigationBar setHidden:YES];
    // self.avPlayerViewcontroller.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    if (_isFromListVC)
    {
         avPlayerViewcontroller.player = [AVPlayer playerWithURL:[NSURL URLWithString:_objModelList.strVideoFileUrl]];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
        
        NSLog(@"files array %@", filePathsArray);
        
        NSString *strVideoNamesavedInDb = [[_objModelList.strVideoLocalPath lastPathComponent] stringByRemovingPercentEncoding];
        
        NSString *fullpath;
        NSURL *videoURL;
        for ( NSString *apath in filePathsArray )
        {
            fullpath = [documentsDirectory stringByAppendingPathComponent:apath];
            
            if ([apath isEqualToString:strVideoNamesavedInDb])
            {
                videoURL = [NSURL fileURLWithPath:fullpath];
            }
        }
        
       // NSString *thePath=[[NSBundle mainBundle] pathForResource:@"small" ofType:@"mp4"];
        // NSURL *videoURL = [NSURL fileURLWithPath:thePath]; //_objModelList.strVideoLocalPath
       avPlayerViewcontroller.player = [AVPlayer playerWithURL:videoURL];
    }
    
   
    
    [videoPlayerContainerVw addSubview:avPlayerViewcontroller.view];
    [self addChildViewController:avPlayerViewcontroller];
    
    avPlayerViewcontroller.view.frame =  videoPlayerContainerVw.bounds; //CGRectMake(0,0,videoPlayerContainerVw.frame.size.width, videoPlayerContainerVw.frame.size.height);
    
    avPlayerViewcontroller.showsPlaybackControls = YES;
    
   // [avPlayerViewcontroller.contentOverlayView addObserver:self forKeyPath:kBoundsProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:kBoundsContext];
    
   // [avPlayerViewcontroller didMoveToParentViewController:self];

    
   // avPlayerViewcontroller.player.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspectFill;
    
    if (_adsManager)
    {
        _adsManager = nil;
        [self.adsLoader contentComplete];
        [self setupAdsLoader];
    }
    
    [self setUpContentPlayerWithUrl];
    
    [self requestAds];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [avPlayerViewcontroller.view removeFromSuperview];
    
    avPlayerViewcontroller = nil;
    
    self.adsLoader = nil;
    
    self.adsManager = nil;
    
    self.contentPlayhead = nil;
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == kBoundsContext) {
        CGRect oldBounds = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
        
        BOOL wasFullscreen = CGRectEqualToRect(oldBounds, [UIScreen mainScreen].bounds);
        BOOL isFullscreen  = CGRectEqualToRect(newBounds, [UIScreen mainScreen].bounds);
        if (isFullscreen && !wasFullscreen) {
            if (CGRectEqualToRect(oldBounds, CGRectMake(0.0, 0.0, newBounds.size.height, newBounds.size.width))) {
                NSLog(@"Rotated fullscreen");
            } else {
                NSLog(@"Entered fullscreen");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidEnterInFullscreen" object:nil];
                });
            }
        } else if (!isFullscreen && wasFullscreen) {
            NSLog(@"Exited fullscreen");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DidExitFromFullscreen" object:nil];
                
            });
        }
    }
}
*/


#pragma mark
#pragma mark - Button Action
#pragma mark

-(void)backBtnPress:(UIButton *)sender
{
    avPlayerViewcontroller = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)setUpContentPlayerWithUrl
{
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:avPlayerViewcontroller.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:avPlayerViewcontroller.player.currentItem];
    
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == avPlayerViewcontroller.player.currentItem) {
        
        //[self.avPlayerViewcontroller dismissViewControllerAnimated:YES completion:nil];
        
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
    [[IMAAdDisplayContainer alloc] initWithAdContainer:avPlayerViewcontroller.view companionSlots:nil];
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
    [avPlayerViewcontroller.player play];
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
    [avPlayerViewcontroller.player play];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [avPlayerViewcontroller.player pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    [avPlayerViewcontroller.player play];
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
