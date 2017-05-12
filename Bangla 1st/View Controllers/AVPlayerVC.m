//
//  AVPlayerVC.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

@import AVFoundation;
@import GoogleInteractiveMediaAds;
#import <AVKit/AVKit.h>

#import "AVPlayerVC.h"

@interface AVPlayerVC ()<IMAAdsManagerDelegate,IMAAdsLoaderDelegate>
{
    NSString *kTestAppAdTagUrl;
}

// SDK
/// Entry point for the SDK. Used to make ad requests.
@property(nonatomic, strong) IMAAdsLoader *adsLoader;

/// Main point of interaction with the SDK. Created by the SDK as the result of an ad request.
@property(nonatomic, strong) IMAAdsManager *adsManager;

/// Playhead used by the SDK to track content video progress and insert mid-rolls.
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;

@end

@implementation AVPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self setupAdsLoader];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    kTestAppAdTagUrl = _strIMAAddURL;
    self.avPlayerVC = self;
        
    [self performSelectorOnMainThread:@selector(setUpIMAadAndPlayVideo) withObject:nil waitUntilDone:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.adsLoader = nil;
    
    self.adsManager = nil;
    
    self.contentPlayhead = nil;
}

-(void)setUpIMAadAndPlayVideo
{
    if (_isFromListVC)
    {
         self.player = [AVPlayer playerWithURL:[NSURL URLWithString:_strVideoURL]];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
        
        NSLog(@"files array %@", filePathsArray);
        
        NSString *strVideoNamesavedInDb = [[_strVideoURL lastPathComponent] stringByRemovingPercentEncoding];
        
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
        
         self.player = [AVPlayer playerWithURL:videoURL];
    }
    
    
    //self.showsPlaybackControls = YES;
    
    if (_adsManager)
    {
        _adsManager = nil;
        [self.adsLoader contentComplete];
        [self setupAdsLoader];
    }
    else
        [self setupAdsLoader];
    
    [self setUpContentPlayerWithUrl];
    
    [self.player play];
    
    [self requestAds];
    
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
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == self.player.currentItem) {
        
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
    [[IMAAdDisplayContainer alloc] initWithAdContainer:self.view companionSlots:nil];
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
    [self.player play];
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
    [self.player play];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [self.player pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    [self.player play];
}

#pragma mark


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
