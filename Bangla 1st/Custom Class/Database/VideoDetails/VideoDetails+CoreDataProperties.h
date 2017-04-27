//
//  VideoDetails+CoreDataProperties.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "VideoDetails+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VideoDetails (CoreDataProperties)

+ (NSFetchRequest<VideoDetails *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *commentCount;
@property (nullable, nonatomic, copy) NSString *videoDescription;
@property (nullable, nonatomic, copy) NSDate *videoDownloadDate;
@property (nullable, nonatomic, copy) NSString *videoID;
@property (nullable, nonatomic, copy) NSString *likes;
@property (nullable, nonatomic, copy) NSString *videoLocalPath;
@property (nullable, nonatomic, copy) NSString *postedTime;
@property (nullable, nonatomic, copy) NSString *videoFile;
@property (nullable, nonatomic, copy) NSString *thumbImage;
@property (nullable, nonatomic, copy) NSString *videoTitle;
@property (nullable, nonatomic, copy) NSString *views;
@property (nullable, nonatomic, copy) NSString *videoDuration;

@end

NS_ASSUME_NONNULL_END
