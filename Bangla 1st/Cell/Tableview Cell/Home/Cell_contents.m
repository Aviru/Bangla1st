//
//  Cell_contents.m
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "Cell_contents.h"

#import "AppDelegate.h"

@interface Cell_contents() <ImageScrollingViewDelegate>
{
    AppDelegate *appDelegate;
 
}




@end

@implementation Cell_contents

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self initialize];
 
}

- (void)initialize
{
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _imageScrollingView = [[ImageScrollingCellView alloc] initWithCollectionView:self.collectonViewVideos andFrame:self.frame];
    _imageScrollingView.delegate = self;
    
    [self.contentView addSubview:_imageScrollingView];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

 

@end
