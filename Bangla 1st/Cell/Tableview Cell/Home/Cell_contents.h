//
//  Cell_contents.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollingCellView.h"

@class Cell_contents;

@protocol ImageScrollingTblCellDelegate <NSObject>

// Notifies the delegate when user click image
- (void)scrollingTblCell:(Cell_contents *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex;

@end

@protocol CellDelegate <NSObject>
-(void)cellTapped:(NSString*)CategoryTypeId andName:(NSString *)categoryName;
@end


@interface Cell_contents : UITableViewCell


@property (weak, nonatomic) id<ImageScrollingTblCellDelegate> delegate;
@property (weak, nonatomic) id<CellDelegate> cellDelegate;

@property(strong, nonatomic) ImageScrollingCellView *imageScrollingView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectonViewVideos;

@end
