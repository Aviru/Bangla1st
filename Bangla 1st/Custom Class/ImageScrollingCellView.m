//
//  ImageScrollingCellView.m
//  NewsPaperApp
//
//  Created by AMSTECH on 17/05/15.
//  Copyright (c) 2015 AMSTECH. All rights reserved.
//

#import "ImageScrollingCellView.h"
#import "AppDelegate.h"
#import "Utilis.h"

#import "ModelContentListing.h"

#import "UIImageView+WebCache.h"


@interface  ImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionViewFlowLayout *flowLayout ;
    AppDelegate *appDelegate;
    ModelContentListing *objContentList;
    CollectionCell_Video *collVwDotscell;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;

@property (nonatomic) int collectionCellType;

@end

@implementation ImageScrollingCellView

- (id)initWithCollectionView: (UICollectionView *)collectionView andFrame :(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView= collectionView;
        
        self.collectionView.frame = CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y,[UIScreen mainScreen].bounds.size.width , collectionView.frame.size.height);
        
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        float screenRatio = [UIScreen mainScreen].bounds.size.width / 320;
        
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        [flowLayout setItemSize:CGSizeMake(150, 146)]; //*screenRatio
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0*screenRatio, 5*screenRatio, 0, 5*screenRatio);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setCollectionViewLayout:flowLayout];
        
        [self addSubview:_collectionView];
    
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
    }
    
    
    return self;
    
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        /*
//        // Initialization code
//        appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//        
//        /* Set flowLayout for CollectionView*/
//        flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        flowLayout.itemSize = CGSizeMake(150, 150);
//        flowLayout.minimumLineSpacing = 5;
//        flowLayout.minimumInteritemSpacing = 5;
//        
//        
//        /* Init and Set CollectionView */
//        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
//        self.myCollectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
//        self.myCollectionView.delegate = self;
//        self.myCollectionView.dataSource = self;
//        self.myCollectionView.showsHorizontalScrollIndicator = NO;
//
//       
//        
//        
//        [self.myCollectionView registerClass:[CollectionCell_Video class] forCellWithReuseIdentifier:@"CollectionCell_Video"];
//        
//        [self.myCollectionView setCollectionViewLayout:flowLayout];
//        self.myCollectionView.backgroundColor=[UIColor greenColor];
//        
//         [self addSubview:_myCollectionView];
//        */
//    }
//    return self;
//}


#pragma mark - UICollectionViewDataSource methods




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   // NSLog(@"cat content count : %d",self.collectionContent.count);
    return self.collectionContent.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     {
     "videoID": "970",
     "videoTitle": "Demo",
     "videoDescription": "Simple Demo Video",
     "videoTags": "Development",
     "thumbImage": "http://173.214.180.212/betadev/uploads/video_thumb/148544607250b39-632x395-1.jpg",
     "videoFile": "http://173.214.180.212/betadev/uploads/video/small.mp4",
     "Views": "15",
     "commentCount": "5",
     "likes": "2",
     "videoDuration": "2:40",
     "videoType": "HD",
     "postedTime": "one month ago",
     "postedBy": "Admin",
     "authorImage": "http://173.214.180.212/betadev/uploads/userProfileImage/avatar.png",
     "category": "1"
     },
     {
     "adID": "11",
     "adTitle": "Home Page Right ",
     "adCode": "http://173.214.180.212/betadev/uploads/video_thumb/img2.jpg",
     "category": "1"
     },
     */
   CollectionCell_Video *cell = (CollectionCell_Video*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell_Video" forIndexPath:indexPath];
    
    if (![self isEmpty:[_collectionContent[indexPath.row] strVideoId]])
    {
        // its a video
        cell.ivAd.hidden=YES;
        cell.lblVidName.text = [_collectionContent[indexPath.row] strVideoTitle];
        [cell.ivThumb sd_setImageWithURL:[NSURL URLWithString:[_collectionContent[indexPath.row] strThumbImageUrl]]
                        placeholderImage:nil];
        
        [cell.btnThreedotsOutlet addTarget:self action:@selector(btnDotsTap:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.btnVideoPlayOutlet addTarget:self action:@selector(btnVideoPlayTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (![self isEmpty:[_collectionContent[indexPath.row] strAdId]]){
       // its a ad
        cell.ivAd.hidden=NO;
        
        cell.lblVidName.text = [_collectionContent[indexPath.row] strAdTitle];
        [cell.ivAd sd_setImageWithURL:[NSURL URLWithString:[_collectionContent[indexPath.row] strAdCodeUrl]]
                        placeholderImage:nil];
    }
    
    
        return cell;
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    //[self.delegate collectionView:self didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath];
    
}


#pragma mark
#pragma mark Button Action
#pragma mark

-(void)btnDotsTap:(UIButton *)sender
{
       
    NSIndexPath *indexPath = nil;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    collVwDotscell = (CollectionCell_Video *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    ModelContentListing *objModelContent;
    
    if (![self isEmpty:[_collectionContent[indexPath.row] strVideoId]])
    {
        objModelContent =  _collectionContent[indexPath.row];
    }
    
    else if (![self isEmpty:[_collectionContent[indexPath.row] strAdId]])
    {
        objModelContent = _collectionContent[indexPath.row];
    }
    
    [self.delegate collectionView:self.collectionView didTapOnDotsButtonAtIndexPath:indexPath withCollectionVwCell:collVwDotscell withSelectedContent:objModelContent];
    
}

-(void)btnVideoPlayTap:(UIButton *)sender
{
    NSIndexPath *indexPath = nil;
    indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:sender.center fromView:sender.superview]];
    
    ModelContentListing *objModelContent;
    
    if (![self isEmpty:[_collectionContent[indexPath.row] strVideoId]])
    {
        objModelContent =  _collectionContent[indexPath.row];
    }
    
    else if (![self isEmpty:[_collectionContent[indexPath.row] strAdId]])
    {
        objModelContent = _collectionContent[indexPath.row];
    }
    
    [self.delegate collectionView:self didSelectImageItemAtIndexPath:indexPath withSelectedContent:_collectionContent[indexPath.row]];
}

//- (void) setImageData:(NSArray*)collectionImageData
//{
//    
//}

#pragma mark
#pragma mark - Empty String check
#pragma mark

-(BOOL)isEmpty:(NSString *)str
{
    if (str == nil || str == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",str] length] == 0 || [[[NSString stringWithFormat:@"%@",str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return YES;
    }
    return NO;
}

@end
