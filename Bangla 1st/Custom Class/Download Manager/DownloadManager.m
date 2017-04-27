//
//  DownloadManager.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 15/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "DownloadManager.h"
#import "BackgroundTimeRemainingUtility.h"
#import "CustomProgressView.h"
#import "AppDelegate.h"

@interface DownloadManager ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>
{
    NSMutableArray *arrPicDetails;
    AppDelegate *appDel;
    BOOL isVideoSavedSuccessfully;
    NSString *savedVideoPath;
    NSString *strVideoURLtoDownload;
    Cell_List *listCell;
    CustomProgressView *customProgressView;
    NSIndexPath *indxPath;
}

@property(strong,nonatomic)NSString *_Nullable uniqueId;

@end

@implementation DownloadManager

#pragma mark -
#pragma mark Default Manager
+ (DownloadManager *)sharedDownloadManager {
    static DownloadManager *_sharedDownloadManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDownloadManager = [[self alloc] init];
    });
    
    return _sharedDownloadManager;
}

- (void)startBackgroundDownloadsForVideoURL:(NSURL *)VideoURL withSelectedCell:(Cell_List *)selectedCell IndexPath:(NSIndexPath *)path  withCompletionHandler:(VideoDownloadCompletion)completionHandler
{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    listCell = selectedCell;
    
    indxPath = path;
    
    self.VideoDownloadCompletion = nil;
    
    self.VideoDownloadCompletion = completionHandler;
    
    /*customProgressView = [[CustomProgressView alloc] initWithContainerViewFrame: listCell.VwProgressContainer.frame];
    customProgressView.delegate = self;
    listCell.VwProgressContainer.hidden = NO;
    [listCell.VwProgressContainer addSubview:customProgressView];
     */
    
    listCell.progressVw.hidden = NO;
    
    [listCell.progressVw setProgress:0.0];
    
    NSURLSession *session = [self backgroundSession];
    
    strVideoURLtoDownload = [VideoURL absoluteString];
    
    NSURLSessionDownloadTask * downloadTask =[session downloadTaskWithURL:VideoURL];
    
    NSLog(@"downloadTask identifier: %lu",(unsigned long)downloadTask.taskIdentifier);
    
    [downloadTask resume];
}

- (NSURLSession *)backgroundSession
{
    //static NSURLSession *session = nil;
    
    NSURLSession *session = nil;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
        // Generate a unique id for the session
        _uniqueId = [NSString stringWithFormat:@"Bangla1stBackgroundUpload:%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
   // _uniqueId = [NSString stringWithFormat:@"%ld",(long)indxPath.row];
    
    NSLog(@"uniqueId%@",_uniqueId);
    
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:_uniqueId];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
   // });
    return session;
}

#pragma mark - NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *fileName = [NSString stringWithFormat:@"video%d.mov",++appDel.videoCount];
    
    savedVideoPath = [documentsPath stringByAppendingPathComponent:fileName]; //[[[downloadTask originalRequest] URL] lastPathComponent]
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
        isVideoSavedSuccessfully = YES;
    }
    else
    {
        NSLog(@"failed to move: %@",[error userInfo]);
        --appDel.videoCount;
        isVideoSavedSuccessfully = NO;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    listCell.progressVw.hidden = YES;
    
    if (error)
    {
        NSLog(@"%s %@ failed: %@", __PRETTY_FUNCTION__, task.originalRequest.URL, error);
        
//        if (self.VideoDownloadCompletion)
//        {
            self.VideoDownloadCompletion(nil,YES,SOMETHING_WRONG);
            //self.VideoDownloadCompletion = nil;
       // }
    }
    else
    {
        NSLog(@"%s succeeded with response: %@",  __PRETTY_FUNCTION__, task.response);
        
        if (isVideoSavedSuccessfully)
        {
//            if (self.VideoDownloadCompletion)
//            {
            NSString *strTaskIdentifier = [NSString stringWithFormat:@"%lu",(unsigned long)task.taskIdentifier];
            
                NSDictionary *videoDownloadDict = @{@"remoteVideoURL":[task.response.URL absoluteString],@"documentsDirectoryPath":savedVideoPath,@"taskIdentifier":strTaskIdentifier};
                
                self.VideoDownloadCompletion(videoDownloadDict,NO,VIDEO_DOWNLOAD_SUCCESS);
                //self.VideoDownloadCompletion = nil;
           // }
        }
        else
        {
//            if (self.VideoDownloadCompletion)
//            {
                self.VideoDownloadCompletion(nil,YES,VIDEO_DOWNLOAD_FAILED);
                //self.VideoDownloadCompletion = nil;
           // }
        }
        
    }
    
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(),^ {
        
        [listCell.progressVw setProgress:progress animated:YES];
        // [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progress] afterDelay:0.0];
        
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
     NSLog(@"%s Download Task Resume response: %@",  __PRETTY_FUNCTION__, downloadTask.response);
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session

{
    if (appDel.backgroundSessionCompletionHandler)
    {
        void (^completionHandler)() = appDel.backgroundSessionCompletionHandler;
        appDel.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    
//    if (self.VideoDownloadCompletion)
//    {
        NSString *strMsg = [NSString stringWithFormat:@"Download finished for UID:%@",_uniqueId];
        self.VideoDownloadCompletion(nil,NO,strMsg);
        //self.VideoDownloadCompletion = nil;
   // }
    
    
    // If we are not in the "active" or foreground then log some background information to the console
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive)
    {
        [BackgroundTimeRemainingUtility NSLog];
    }
}

/*
#pragma mark
#pragma mark - Progress View Methods

-(void)setProgress:(NSNumber*)value
{
    [customProgressView performSelectorOnMainThread:@selector(setProgress:) withObject:value waitUntilDone:NO];
}

- (void)didFinishAnimation:(CustomProgressView*)progressView
{
    [progressView removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    listCell.VwProgressContainer.hidden = YES;
}
 */


@end
