//
//  DownloadManager.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 15/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell_List.h"

typedef  void(^ _Nullable VideoDownloadCompletion)(_Nullable id result,BOOL isError, NSString * _Nullable strMsg);

@interface DownloadManager : NSObject

#pragma mark -
#pragma mark Shared Manager
+ (DownloadManager * _Nullable)sharedDownloadManager;

@property(nonatomic, copy) void (^ _Nullable VideoDownloadCompletion)(_Nullable id result,BOOL isError, NSString * _Nullable strMsg);

- (void)startBackgroundDownloadsForVideoURL:(NSURL * _Nullable)VideoURL withSelectedCell:(Cell_List * _Nullable) selectedCell IndexPath:(NSIndexPath * _Nullable)path  withCompletionHandler:(VideoDownloadCompletion)completionHandler;

@end
