//
//  ModelContentListing.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelContentListing.h"

@implementation ModelContentListing

-(id)initWithDictionary:(NSDictionary *)dict isTypeAd:(BOOL)boolVal
{
    if (self=[super init])
    {
        if ([dict objectForKey:@"adID"] && ![[dict objectForKey:@"adID"] isKindOfClass:[NSNull class]])
        {
            self.strAdId=[dict objectForKey:@"adID"];
        }
        else
        {
            self.strAdId=@"";
        }
        
        if ([dict objectForKey:@"adCode"] && ![[dict objectForKey:@"adCode"] isKindOfClass:[NSNull class]])
        {
            self.strAdCodeUrl=[dict objectForKey:@"adCode"];
        }
        else
        {
            self.strAdCodeUrl=@"";
        }
        
        if ([dict objectForKey:@"adTitle"] && ![[dict objectForKey:@"adTitle"] isKindOfClass:[NSNull class]])
        {
            self.strAdTitle=[dict objectForKey:@"adTitle"];
        }
        else
        {
            self.strAdTitle=@"";
        }
        
        if ([dict objectForKey:@"category"] && ![[dict objectForKey:@"category"] isKindOfClass:[NSNull class]])
        {
            self.strAdCategory=[dict objectForKey:@"category"];
        }
        else
        {
            self.strAdCategory=@"";
        }
        
        if ([dict objectForKey:@"videoID"] && ![[dict objectForKey:@"videoID"] isKindOfClass:[NSNull class]])
        {
            self.strVideoId=[dict objectForKey:@"videoID"];
        }
        else
        {
            self.strVideoId=@"";
        }
        
        if ([dict objectForKey:@"videoTitle"] && ![[dict objectForKey:@"videoTitle"] isKindOfClass:[NSNull class]])
        {
            self.strVideoTitle=[dict objectForKey:@"videoTitle"];
        }
        else
        {
            self.strVideoTitle=@"";
        }
        
        if ([dict objectForKey:@"videoDescription"] && ![[dict objectForKey:@"videoDescription"] isKindOfClass:[NSNull class]])
        {
            self.strVideoDescription=[dict objectForKey:@"videoDescription"];
        }
        else
        {
            self.strVideoDescription=@"";
        }
        
        if ([dict objectForKey:@"videoTags"] && ![[dict objectForKey:@"videoTags"] isKindOfClass:[NSNull class]])
        {
            self.strVideoTags=[dict objectForKey:@"videoTags"];
        }
        else
        {
            self.strVideoTags=@"";
        }
        
        if ([dict objectForKey:@"thumbImage"] && ![[dict objectForKey:@"thumbImage"] isKindOfClass:[NSNull class]])
        {
            self.strThumbImageUrl=[dict objectForKey:@"thumbImage"];
        }
        else
        {
            self.strThumbImageUrl=@"";
        }
        
        if ([dict objectForKey:@"videoFile"] && ![[dict objectForKey:@"videoFile"] isKindOfClass:[NSNull class]])
        {
            self.strVideoFileUrl=[dict objectForKey:@"videoFile"];
        }
        else
        {
            self.strVideoFileUrl=@"";
        }
        
        if ([dict objectForKey:@"views"] && ![[dict objectForKey:@"views"] isKindOfClass:[NSNull class]])
        {
            self.strViews=[dict objectForKey:@"views"];
        }
        else
        {
            self.strViews=@"";
        }
        
        if ([dict objectForKey:@"commentCount"] && ![[dict objectForKey:@"commentCount"] isKindOfClass:[NSNull class]])
        {
            self.strCommentCount=[dict objectForKey:@"commentCount"];
        }
        else
        {
            self.strCommentCount=@"";
        }
        
        if ([dict objectForKey:@"likes"] && ![[dict objectForKey:@"likes"] isKindOfClass:[NSNull class]])
        {
            self.strLikes=[dict objectForKey:@"likes"];
        }
        else
        {
            self.strLikes=@"";
        }
        
        if ([dict objectForKey:@"videoDuration"] && ![[dict objectForKey:@"videoDuration"] isKindOfClass:[NSNull class]])
        {
            self.strVideoDuration=[dict objectForKey:@"videoDuration"];
        }
        else
        {
            self.strVideoDuration=@"";
        }
        
        if ([dict objectForKey:@"videoType"] && ![[dict objectForKey:@"videoType"] isKindOfClass:[NSNull class]])
        {
            self.strVideoType=[dict objectForKey:@"videoType"];
        }
        else
        {
            self.strVideoType=@"";
        }
        
        if ([dict objectForKey:@"postedTime"] && ![[dict objectForKey:@"postedTime"] isKindOfClass:[NSNull class]])
        {
            self.strPostedTime=[dict objectForKey:@"postedTime"];
        }
        else
        {
            self.strPostedTime=@"";
        }
        
        if ([dict objectForKey:@"postedBy"] && ![[dict objectForKey:@"postedBy"] isKindOfClass:[NSNull class]])
        {
            self.strPostedBy=[dict objectForKey:@"postedBy"];
        }
        else
        {
            self.strPostedBy=@"";
        }
        
        if ([dict objectForKey:@"authorImage"] && ![[dict objectForKey:@"authorImage"] isKindOfClass:[NSNull class]])
        {
            self.strAuthorImageUrl=[dict objectForKey:@"authorImage"];
        }
        else
        {
            self.strAuthorImageUrl=@"";
        }
        
        if ([dict objectForKey:@"category"] && ![[dict objectForKey:@"category"] isKindOfClass:[NSNull class]])
        {
            self.strCategory=[dict objectForKey:@"category"];
        }
        else
        {
            self.strCategory=@"";
        }
        
    }
    return self;
}


@end
