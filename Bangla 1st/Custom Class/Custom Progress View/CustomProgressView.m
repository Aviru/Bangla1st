//
//  CustomProgressView.m
//  CustomProgressView
//
//  Created by Aviru bhattacharjee on 05/02/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import "CustomProgressView.h"

@implementation CustomProgressView

@synthesize current_value;
@synthesize delegate;

- (id)initWithContainerViewFrame:(CGRect)VwFrame
{
    /*
    CGRect frame;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
        frame = CGRectMake(0.0, ([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.height)/2, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.height);
    else
        frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-50 , [[UIScreen mainScreen] bounds].size.height/2-50, 100, 100);
       // frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.height)/2, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.height);
    */

    self = [super initWithFrame:VwFrame];
    if (self) {
        // Initialization code
        current_value = 0.0;
        new_to_value = 0.0;
        IsAnimationInProgress = NO;
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        self.alpha = 0.95;
        //self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;
        //self.backgroundColor = [UIColor colorWithRed:104.0/255.0 green:165.0/255.0 blue:194.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
       // ProgressLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-200)/2, self.frame.size.height/2-150, 200, 40.0)];
         ProgressLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, self.frame.size.height/2-20, 40, 40.0)];
        ProgressLbl.font = [UIFont boldSystemFontOfSize:10.0];
        ProgressLbl.text = @"0%";
        ProgressLbl.backgroundColor = [UIColor clearColor];
        ProgressLbl.textColor = [UIColor darkGrayColor];
        ProgressLbl.textAlignment = NSTextAlignmentCenter ;
        ProgressLbl.alpha = self.alpha;
        [self addSubview:ProgressLbl];
    }
    return self;
}

-(void)UpdateLabelsWithValue:(NSString*)value
{
    ProgressLbl.text = value;
}

-(void)setProgressValue:(float)to_value withAnimationTime:(float)animation_time
{
    float timer = 0;
    
    float step = 0.1;
    
    float value_step = (to_value-self.current_value)*step/animation_time;
    int final_value = self.current_value*100;
    
    while (timer<animation_time-step) {
        final_value += floor(value_step*100);
        [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%i%%", final_value] afterDelay:timer];
        timer += step;
    }
    
    [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%.0f%%", to_value*100] afterDelay:animation_time];
}

-(void)SetAnimationDone
{
    IsAnimationInProgress = NO;
    if (new_to_value>self.current_value)
        [self setProgress:[NSNumber numberWithFloat:new_to_value]];
}

- (void)setProgress:(NSNumber*)value{
    
    float to_value = [value floatValue];
    
    if (to_value<=self.current_value)
        return;
    else if (to_value>1.0)
        to_value = 1.0;
    
    if (IsAnimationInProgress)
    {
        new_to_value = to_value;
        return;
    }
    
    IsAnimationInProgress = YES;
    
    float animation_time = to_value-self.current_value;
    
    [self performSelector:@selector(SetAnimationDone) withObject:Nil afterDelay:animation_time];
    
    if (to_value == 1.0 && delegate && [delegate respondsToSelector:@selector(didFinishAnimation:)])
        [delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:animation_time];
    
    [self setProgressValue:to_value withAnimationTime:animation_time];
    
    float start_angle = 2*M_PI*self.current_value-M_PI_2;
    float end_angle = 2*M_PI*to_value-M_PI_2;
    
    float radius = 5.0; //75.0;
    
    CAShapeLayer *circle = [CAShapeLayer layer];

    // Make a circular shape
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                 radius:radius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor whiteColor].CGColor;
    circle.strokeColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor; //[UIColor whiteColor]
    circle.lineWidth = 3;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = animation_time;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    self.current_value = to_value;
}

@end
