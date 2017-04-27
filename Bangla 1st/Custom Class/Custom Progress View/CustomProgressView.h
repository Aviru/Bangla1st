//
//  CustomProgressView.h
//  CustomProgressView
//
//  Created by Aviru bhattacharjee on 05/02/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomProgressView : UIView
{
    float current_value;
    float new_to_value;
    
    UILabel *ProgressLbl;

    id delegate;
    
    BOOL IsAnimationInProgress;
}

@property id delegate;
@property float current_value;

- (id)initWithContainerViewFrame:(CGRect)VwFrame;
- (void)setProgress:(NSNumber*)value;

@end

@protocol CustomProgressViewDelegate
- (void)didFinishAnimation:(CustomProgressView*)progressView;
@end
