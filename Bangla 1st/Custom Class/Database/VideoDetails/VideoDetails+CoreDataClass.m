//
//  VideoDetails+CoreDataClass.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "VideoDetails+CoreDataClass.h"

@implementation VideoDetails

+(VideoDetails *)createInManagedObjectContextWithVideoURL:(NSString *)strVideoURL videoAssetURL:(NSString *)strAssetUrl videoID:(NSString *)strVideoID videoDate:(NSDate *)videoDt title:(NSString *)strvideoTitle description:(NSString *)strVideoDescription duration:(NSString *)strVideoDuration postedTime:(NSString *)strVideoPostedTime views:(NSString *)strVideoViews likes:(NSString *)strVideoLikes commentCount:(NSString *)strVideoCommentCount thumbImageURL:(NSString *)strThumbImgUrl managedObjectContext:(NSManagedObjectContext*)moc
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VideoDetails" inManagedObjectContext:moc];
    VideoDetails *videoDetails = [[VideoDetails alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
    
    videoDetails.videoLocalPath = strAssetUrl;
    videoDetails.videoFile = strVideoURL;
    videoDetails.videoID = strVideoID;
    videoDetails.videoDownloadDate = videoDt;
    videoDetails.likes = strVideoLikes;
    videoDetails.views = strVideoViews;
    videoDetails.videoTitle = strvideoTitle;
    videoDetails.videoDescription = strVideoDescription;
    videoDetails.postedTime = strVideoPostedTime;
    videoDetails.videoDuration = strVideoDuration;
    videoDetails.commentCount = strVideoCommentCount;
    videoDetails.thumbImage = strThumbImgUrl;
    
    return videoDetails;
}



+(NSMutableArray *)fetchVideoDetailsWithEntityName:(NSString *)strEntityName predicateName:(NSString *)strPredicate predicateValue:(NSString *)strPredicateValue managedObjectContext:(NSManagedObjectContext*)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:strEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",strPredicate,strPredicateValue];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *arrVideoDetails = [[moc executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return arrVideoDetails;
}

+(NSMutableArray *)fetchVideoDetailsWithEntityName:(NSString *)strEntityName  managedObjectContext:(NSManagedObjectContext*)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:strEntityName];
    NSMutableArray *arrVideoDetails = [[moc executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return arrVideoDetails;
}

+(BOOL)deleteRecordWithEntityName:(NSString *)strEntityName predicateName:(NSString *)strPredicate recordToDelete:(NSString *)strVideoURL managedObjectContext:(NSManagedObjectContext*)moc
{
    BOOL isDeleted;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:strEntityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", strPredicate,strVideoURL];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [moc deleteObject:managedObject];
        }
        
        // Save the object to persistent store
        NSError *DBerror = nil;
        if (![moc save:&DBerror]) {
            
            isDeleted = NO;
            NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
            
        }
        else
        {
            isDeleted = YES;
            NSLog(@"Data Deleted Successfully.");
        }
    }
    else
    {
        isDeleted = NO;
        NSLog(@"Error:Data not deleted");
    }
    
    return isDeleted;

}


@end
