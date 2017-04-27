//
//  VideoDetails+CoreDataProperties.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "VideoDetails+CoreDataProperties.h"

@implementation VideoDetails (CoreDataProperties)

+ (NSFetchRequest<VideoDetails *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VideoDetails"];
}

@dynamic commentCount;
@dynamic videoDescription;
@dynamic videoDownloadDate;
@dynamic videoID;
@dynamic likes;
@dynamic videoLocalPath;
@dynamic postedTime;
@dynamic videoFile;
@dynamic thumbImage;
@dynamic videoTitle;
@dynamic views;
@dynamic videoDuration;

@end
