//
//  ImageScrollingCellView.h
//  NewsPaperApp
//
//  Created by ABHIJIT RANA on 17/05/15.
//  Copyright (c) 2015 ABHIJIT RANA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelContentListing.h"
#import "CollectionCell_Video.h"

@class ImageScrollingCellView;


@protocol ImageScrollingViewDelegate <NSObject>

@optional
- (void)collectionView:(ImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath withSelectedContent:(ModelContentListing *)objSelectedContent;
- (void)collectionView:(UICollectionView *)collectionView didTapOnDotsButtonAtIndexPath:(NSIndexPath*)indexPath withCollectionVwCell:(CollectionCell_Video *)selectedCollectionVwCell;
@end



@interface ImageScrollingCellView : UIView
@property (weak, nonatomic) id<ImageScrollingViewDelegate> delegate;
@property (weak, nonatomic) NSArray *collectionContent;
@property (strong, nonatomic) CollectionCell_Video *collectionViewCell;
- (id)initWithCollectionView: (UICollectionView *)collectionView andFrame :(CGRect)frame;


- (void) setImageData:(NSArray*)collectionImageData;
- (void) setTypeImageScrollingCellView:(int)type;

@end
