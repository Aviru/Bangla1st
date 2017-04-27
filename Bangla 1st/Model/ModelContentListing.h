//
//  ModelContentListing.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ModelBaseClass.h"

@interface ModelContentListing : ModelBaseClass

-(id)initWithDictionary:(NSDictionary *)dict isTypeAd:(BOOL)boolVal;

@property(nonatomic,strong)NSString *strVideoId;
@property(nonatomic,strong)NSString *strVideoTitle;
@property(nonatomic,strong)NSString *strVideoDescription;
@property(nonatomic,strong)NSString *strVideoTags;
@property(nonatomic,strong)NSString *strThumbImageUrl;
@property(nonatomic,strong)NSString *strVideoFileUrl;
@property(nonatomic,strong)NSString *strViews;
@property(nonatomic,strong)NSString *strCommentCount;
@property(nonatomic,strong)NSString *strLikes;
@property(nonatomic,strong)NSString *strVideoDuration;
@property(nonatomic,strong)NSString *strVideoType;
@property(nonatomic,strong)NSString *strPostedTime;
@property(nonatomic,strong)NSString *strPostedBy;
@property(nonatomic,strong)NSString *strAuthorImageUrl;
@property(nonatomic,strong)NSString *strCategory;


@property(nonatomic,strong)NSString *strAdId;
@property(nonatomic,strong)NSString *strAdCodeUrl;
@property(nonatomic,strong)NSString *strAdTitle;
@property(nonatomic,strong)NSString *strAdCategory;


@end
