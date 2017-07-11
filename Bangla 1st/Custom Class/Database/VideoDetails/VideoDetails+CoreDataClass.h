//
//  VideoDetails+CoreDataClass.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 17/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetails : NSManagedObject

+(VideoDetails *)createInManagedObjectContextWithVideoURL:(NSString *)strVideoURL videoAssetURL:(NSString *)strAssetUrl videoID:(NSString *)strVideoID videoDate:(NSDate *)videoDt title:(NSString *)strvideoTitle description:(NSString *)strVideoDescription duration:(NSString *)strVideoDuration postedTime:(NSString *)strVideoPostedTime views:(NSString *)strVideoViews likes:(NSString *)strVideoLikes commentCount:(NSString *)strVideoCommentCount thumbImageURL:(NSString *)strThumbImgUrl managedObjectContext:(NSManagedObjectContext*)moc;

+(NSMutableArray *)fetchVideoDetailsWithEntityName:(NSString *)strEntityName predicateName:(NSString *)strPredicate predicateValue:(NSString *)strPredicateValue managedObjectContext:(NSManagedObjectContext*)moc;

+(NSMutableArray *)fetchVideoDetailsWithEntityName:(NSString *)strEntityName  managedObjectContext:(NSManagedObjectContext*)moc;

+(BOOL)deleteRecordWithEntityName:(NSString *)strEntityName predicateName:(NSString *)strPredicate recordToDelete:(NSString *)strVideoURL managedObjectContext:(NSManagedObjectContext*)moc;

+(BOOL)deleteAllRecordsWithEntityName:(NSString *)strEntityName
                 managedObjectContext:(NSManagedObjectContext*)moc persistentSoreCoOrdinator:(NSPersistentStoreCoordinator *)myPersistentStoreCoordinator;

@end

NS_ASSUME_NONNULL_END

#import "VideoDetails+CoreDataProperties.h"
