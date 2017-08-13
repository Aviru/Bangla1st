//
//  CustomNotificationViewManager.m
//
//  Created by Aviru Bhattacharjee on 14/08/17.
//  Copyright (c) 2017 Aviru Bhattacharjee. All rights reserved.
//

#import "CustomNotificationViewManager.h"

// Quartz
#import <QuartzCore/QuartzCore.h>

// Numerics (CustomNotificationViewStyleSheet)
CGFloat const kCustomNotificationViewStyleSheetMessageBarAlpha = 0.96f;

// Numerics (CustomNotificationView)
CGFloat const kCustomNotificationViewPadding = 10.0f;
CGFloat const kCustomNotificationViewIconSize = 36.0f;
CGFloat const kCustomNotificationViewTextOffset = 2.0f;
NSUInteger const kCustomNotificationViewiOS7Identifier = 7;

// Numerics (CustomNotificationViewManager)
CGFloat const kCustomNotificationViewManagerDisplayDelay = 3.0f;
CGFloat const kCustomNotificationViewManagerDismissAnimationDuration = 0.3f;
CGFloat const kCustomNotificationViewManagerPanVelocity = 0.2f;
CGFloat const kCustomNotificationViewManagerPanAnimationDuration = 0.0002f;

// Strings (CustomNotificationViewStyleSheet)
NSString * const kCustomNotificationViewStyleSheetImageIcon = @"icon36.png";

// Fonts (CustomNotificationView)
static UIFont *kCustomNotificationViewTitleFont = nil;
static UIFont *kCustomNotificationViewDescriptionFont = nil;

// Colors (CustomNotificationView)
static UIColor *kCustomNotificationViewTitleColor = nil;
static UIColor *kCustomNotificationViewDescriptionColor = nil;

// Colors (CustomNotificationViewDefaultMessageBarStyleSheet)
static UIColor *kCustomNotificationViewDefaultMessageBarStyleSheetBackgroundColor = nil;
static UIColor *kCustomNotificationViewDefaultMessageBarStyleSheetStrokeColor = nil;

@protocol CustomNotificationViewDelegate;

@interface CustomNotificationView : UIView

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *descriptionString;

@property (nonatomic, assign) CustomNotificationViewMessageType messageType;

@property (nonatomic, assign) BOOL hasCallback;
@property (nonatomic, strong) NSArray *callbacks;

@property (nonatomic, assign, getter = isHit) BOOL hit;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, weak) id <CustomNotificationViewDelegate> delegate;

// Initializers
- (id)initWithTitle:(NSString *)title description:(NSString *)description type:(CustomNotificationViewMessageType)type;

// Getters
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)statusBarOffset;
- (CGFloat)availableWidth;
- (CGSize)titleSize;
- (CGSize)descriptionSize;
- (CGRect)statusBarFrame;
- (UIFont *)titleFont;
- (UIFont *)descriptionFont;
- (UIColor *)titleColor;
- (UIColor *)descriptionColor;

// Helpers
- (CGRect)orientFrame:(CGRect)frame;

// Notifications
- (void)didChangeDeviceOrientation:(NSNotification *)notification;

@end

@protocol CustomNotificationViewDelegate <NSObject>

- (NSObject<CustomNotificationViewStyleSheet> *)styleSheetForMessageView:(CustomNotificationView *)messageView;

@end

@interface CustomNotificationViewDefaultMessageBarStyleSheet : NSObject <CustomNotificationViewStyleSheet>

+ (CustomNotificationViewDefaultMessageBarStyleSheet *)styleSheet;

@end

@interface CustomNotificationViewWindow : UIWindow

@end

@interface CustomNotificationViewViewController : UIViewController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;

@end

@interface CustomNotificationViewManager () <CustomNotificationViewDelegate>

@property (nonatomic, strong) NSMutableArray *messageBarQueue;
@property (nonatomic, assign, getter = isMessageVisible) BOOL messageVisible;
@property (nonatomic, strong) CustomNotificationViewWindow *messageWindow;
@property (nonatomic, readwrite) NSArray *accessibleElements; // accessibility

// Static
+ (CGFloat)durationForMessageType:(CustomNotificationViewMessageType)messageType;

// Helpers
- (void)showNextMessage;
- (void)generateAccessibleElementWithTitle:(NSString *)title description:(NSString *)description;

// Gestures
- (void)itemSelected:(UITapGestureRecognizer *)recognizer;

// Getters
- (UIView *)messageWindowView;
- (CustomNotificationViewViewController *)messageBarViewController;

// Master presetation
- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(CustomNotificationViewMessageType)type duration:(CGFloat)duration statusBarHidden:(BOOL)statusBarHidden statusBarStyle:(UIStatusBarStyle)statusBarStyle callback:(void (^)())callback;

@end

@implementation CustomNotificationViewManager

#pragma mark - Singleton

+ (nonnull CustomNotificationViewManager *)sharedInstance
{
    static dispatch_once_t pred;
    static CustomNotificationViewManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
	return instance;
}

#pragma mark - Static

+ (CGFloat)defaultDuration
{
    return kCustomNotificationViewManagerDisplayDelay;
}

+ (CGFloat)durationForMessageType:(CustomNotificationViewMessageType)messageType
{
    return kCustomNotificationViewManagerDisplayDelay;
}

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _messageBarQueue = [[NSMutableArray alloc] init];
        _messageVisible = NO;
        _styleSheet = [CustomNotificationViewDefaultMessageBarStyleSheet styleSheet];
        _managerSupportedOrientationsMask = UIInterfaceOrientationMaskAll;
    }
    return self;
}

#pragma mark - Public


- (void)showMessageWithTitle:(nullable NSString *)title description:(nullable NSString *)description type:(CustomNotificationViewMessageType)type statusBarStyle:(UIStatusBarStyle)statusBarStyle callback:(nullable void (^)())callback
{
    [self showMessageWithTitle:title description:description type:type duration:kCustomNotificationViewManagerDisplayDelay statusBarStyle:statusBarStyle callback:callback];
}

- (void)showMessageWithTitle:(nullable NSString *)title description:(nullable NSString *)description type:(CustomNotificationViewMessageType)type duration:(CGFloat)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle callback:(nullable void (^)())callback
{
  // [self showMessageWithTitle:title description:description type:type duration:duration statusBarHidden:NO statusBarStyle:statusBarStyle callback:callback];
    
   [self showMessageWithTitle:title description:description type:type duration:duration statusBarHidden:YES statusBarStyle:statusBarStyle callback:callback];
}



#pragma mark - Master Presentation

- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(CustomNotificationViewMessageType)type duration:(CGFloat)duration statusBarHidden:(BOOL)statusBarHidden statusBarStyle:(UIStatusBarStyle)statusBarStyle callback:(void (^)())callback
{
    CustomNotificationView *messageView = [[CustomNotificationView alloc] initWithTitle:title description:description type:type];
    messageView.delegate = self;
    
    messageView.callbacks = callback ? [NSArray arrayWithObject:callback] : [NSArray array];
    messageView.hasCallback = callback ? YES : NO;
    
    messageView.duration = duration;
    messageView.hidden = YES;
    
    messageView.statusBarStyle = statusBarStyle;
    messageView.statusBarHidden = statusBarHidden;
    
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
       // [self messageWindowView].backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
       //  blurEffectView.alpha =1.0;
        blurEffectView.frame = messageView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Vibrancy effect
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:messageView.bounds];
        
        // Add the vibrancy view to the blur view
        [[blurEffectView contentView] addSubview:vibrancyEffectView];
        
        [[self messageWindowView] addSubview:blurEffectView];
        
    }
    else
    {
         [self messageWindowView].backgroundColor = [UIColor blackColor];
    }
   
    [[self messageWindowView] addSubview:messageView];
    [[self messageWindowView] bringSubviewToFront:messageView];
    
    [self.messageBarQueue addObject:messageView];
    
    if (!self.messageVisible)
    {
        [self showNextMessage];
    }
}

- (void)hideAllAnimated:(BOOL)animated
{
    for (UIView *subview in [[self messageWindowView] subviews])
    {
        if ([subview isKindOfClass:[CustomNotificationView class]])
        {
            CustomNotificationView *currentMessageView = (CustomNotificationView *)subview;
            if (animated)
            {
                [UIView animateWithDuration:kCustomNotificationViewManagerDismissAnimationDuration animations:^{
                    currentMessageView.frame = CGRectMake(currentMessageView.frame.origin.x, -currentMessageView.frame.size.height, currentMessageView.frame.size.width, currentMessageView.frame.size.height);
                } completion:^(BOOL finished) {
                    [currentMessageView removeFromSuperview];
                }];
            }
            else
            {
                [currentMessageView removeFromSuperview];
            }
        }
    }
    
    self.messageVisible = NO;
    [self.messageBarQueue removeAllObjects];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.messageWindow.hidden = YES;
	self.messageWindow = nil;
}

- (void)hideAll
{
    [self hideAllAnimated:NO];
}

#pragma mark - Helpers

- (void)showNextMessage
{
    if ([self.messageBarQueue count] > 0)
    {
        self.messageVisible = YES;
        
        CustomNotificationView *messageView = [self.messageBarQueue objectAtIndex:0];
        [self messageBarViewController].statusBarHidden = messageView.statusBarHidden; // important to do this prior to hiding
       // messageView.frame = CGRectMake(0, -[messageView height], [messageView width], [messageView height]);
        
        messageView.frame = CGRectMake(0, -[messageView height], [messageView width], self.messageWindow.frame.size.height);
       
        messageView.hidden = NO;
        [messageView setNeedsDisplay];
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelected:)];
        [messageView addGestureRecognizer:gest];
        
        if (messageView)
        {
            [self.messageBarQueue removeObject:messageView];
            
            [self messageBarViewController].statusBarStyle = messageView.statusBarStyle;

            [UIView animateWithDuration:kCustomNotificationViewManagerDismissAnimationDuration animations:^{
                [messageView setFrame:CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y + [messageView height], [messageView width], self.messageWindow.frame.size.height)]; // slide down
                
                UIBezierPath *maskPath = [UIBezierPath
                                          bezierPathWithRoundedRect:messageView.bounds
                                          byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                          cornerRadii:CGSizeMake(8, 8)
                                          ];
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                
                maskLayer.frame = messageView.bounds;
                maskLayer.path = maskPath.CGPath;
                
                messageView.layer.mask = maskLayer;
                
            }];
            
            
            [self performSelector:@selector(itemSelected:) withObject:messageView afterDelay:messageView.duration];
            
            
            [self generateAccessibleElementWithTitle:messageView.titleString description:messageView.descriptionString];
        }
    }
}

- (void)generateAccessibleElementWithTitle:(NSString *)title description:(NSString *)description
{
    UIAccessibilityElement *textElement = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
    textElement.accessibilityLabel = [NSString stringWithFormat:@"%@\n%@", title, description];
    textElement.accessibilityTraits = UIAccessibilityTraitStaticText;
    self.accessibleElements = @[textElement];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self); // notify the accessibility framework to read the message
}

#pragma mark - Gestures

- (void)itemSelected:(id)sender
{
    CustomNotificationView *messageView = nil;
    BOOL itemHit = NO;
    if ([sender isKindOfClass:[UIGestureRecognizer class]])
    {
        messageView = (CustomNotificationView *)((UIGestureRecognizer *)sender).view;
        itemHit = YES;
        messageView.hit = YES;
    }
    else if ([sender isKindOfClass:[CustomNotificationView class]])
    {
        messageView = (CustomNotificationView *)sender;
        messageView.hit = NO;
    }
    
    if (messageView)  //&& ![messageView isHit]
    {
        if (messageView.hit == NO) {
            
            [UIView animateWithDuration:kCustomNotificationViewManagerDismissAnimationDuration animations:^{
                [messageView setFrame:CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y - [messageView height], [messageView width], [messageView height])]; // slide back up
                
            } completion:^(BOOL finished) {
                
                
                if (itemHit)
                {
                    if ([messageView.callbacks count] > 0)
                    {
                        id obj = [messageView.callbacks objectAtIndex:0];
                        if (![obj isEqual:[NSNull null]])
                        {
                            ((void (^)())obj)();
                        }
                    }
                }
                
                self.messageVisible = NO;
                [messageView removeFromSuperview];
                
                if([self.messageBarQueue count] > 0)
                {
                    [self showNextMessage];
                }
                else
                {
                    self.messageWindow.hidden = YES;
                    self.messageWindow = nil;
                }

            }];
        }
        else {
            
            [UIView animateWithDuration:kCustomNotificationViewManagerDismissAnimationDuration animations:^{
                [messageView setFrame:CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y - [messageView height], [messageView width], [messageView height])]; // slide back up
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNotificationListPageFromFCMPush" object:nil];
                
            } completion:^(BOOL finished) {
                if (itemHit)
                {
                    if ([messageView.callbacks count] > 0)
                    {
                        id obj = [messageView.callbacks objectAtIndex:0];
                        if (![obj isEqual:[NSNull null]])
                        {
                            ((void (^)())obj)();
                        }
                    }
                }
                
                self.messageVisible = NO;
                [messageView removeFromSuperview];
                
                if([self.messageBarQueue count] > 0)
                {
                    [self showNextMessage];
                }
                else
                {
                    self.messageWindow.hidden = YES;
                    self.messageWindow = nil;
                }
            }];
        }
        
        
    }
}

#pragma mark - Getters

- (UIView *)messageWindowView
{
    return [self messageBarViewController].view;
}

- (CustomNotificationViewViewController *)messageBarViewController
{
    if (!self.messageWindow)
    {
        self.messageWindow = [[CustomNotificationViewWindow alloc] init];
        
        int size = 80;
        float screenWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
        
        self.messageWindow.frame = CGRectMake(kCustomNotificationViewPadding, 10, screenWidth - kCustomNotificationViewPadding * 2, size);
        
        UIBezierPath *maskPath = [UIBezierPath
                                  bezierPathWithRoundedRect:self.messageWindow.bounds
                                  byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                  cornerRadii:CGSizeMake(8, 8)
                                  ];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = self.messageWindow.bounds;
        maskLayer.path = maskPath.CGPath;
        
        self.messageWindow.layer.mask = maskLayer;
        self.messageWindow.hidden = NO;
        self.messageWindow.windowLevel = UIWindowLevelNormal;
        self.messageWindow.backgroundColor = [UIColor clearColor];
        self.messageWindow.rootViewController = [[CustomNotificationViewViewController alloc] init];
    }
    return (CustomNotificationViewViewController *)self.messageWindow.rootViewController;
}

- (NSArray *)accessibleElements
{
    if (_accessibleElements != nil)
    {
        return _accessibleElements;
    }
    _accessibleElements = [NSArray array];
    return _accessibleElements;
}

#pragma mark - Setters

- (void)setStyleSheet:(NSObject<CustomNotificationViewStyleSheet> *)styleSheet
{
    if (styleSheet != nil)
    {
        _styleSheet = styleSheet;
    }
}

#pragma mark - TWMessageViewDelegate

- (NSObject<CustomNotificationViewStyleSheet> *)styleSheetForMessageView:(CustomNotificationView *)messageView
{
    return self.styleSheet;
}

#pragma mark - UIAccessibilityContainer

- (NSInteger)accessibilityElementCount
{
    return (NSInteger)[self.accessibleElements count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    return [self.accessibleElements objectAtIndex:(NSUInteger)index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    return (NSInteger)[self.accessibleElements indexOfObject:element];
}

- (BOOL)isAccessibilityElement
{
    return NO;
}

@end

@implementation CustomNotificationView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [CustomNotificationView class])
	{
        // Fonts
        kCustomNotificationViewTitleFont = [UIFont boldSystemFontOfSize:14.0];
        kCustomNotificationViewDescriptionFont = [UIFont systemFontOfSize:12.0];
        
        // Colors
        kCustomNotificationViewTitleColor = [UIColor blackColor];  //[UIColor colorWithWhite:1.0 alpha:1.0];
        kCustomNotificationViewDescriptionColor = [UIColor blackColor]; //[UIColor colorWithWhite:1.0 alpha:1.0];
	}
}

- (id)initWithTitle:(NSString *)title description:(NSString *)description type:(CustomNotificationViewMessageType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.userInteractionEnabled = YES;
        
        _titleString = title;
        _descriptionString = description;
        _messageType = type;
        
        _hasCallback = NO;
        _hit = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeDeviceOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([self.delegate respondsToSelector:@selector(styleSheetForMessageView:)])
    {
        id<CustomNotificationViewStyleSheet> styleSheet = [self.delegate styleSheetForMessageView:self];
        
        // background fill
        CGContextSaveGState(context);
        {
            if ([styleSheet respondsToSelector:@selector(backgroundColorForMessageType:)])
            {
                [[styleSheet backgroundColorForMessageType:self.messageType] set];
                CGContextFillRect(context, rect);
            }
        }
        CGContextRestoreGState(context);
        
        // bottom stroke
        CGContextSaveGState(context);
        {
            if ([styleSheet respondsToSelector:@selector(strokeColorForMessageType:)])
            {
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, 0, rect.size.height);
                CGContextSetStrokeColorWithColor(context, [styleSheet strokeColorForMessageType:self.messageType].CGColor);
                CGContextSetLineWidth(context, 1.0);
                CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
                CGContextStrokePath(context);
            }
        }
        CGContextRestoreGState(context);
        
        CGFloat xOffset = kCustomNotificationViewPadding;
        CGFloat yOffset = kCustomNotificationViewPadding + [self statusBarOffset];
        
        // icon
        CGContextSaveGState(context);
        {
            if ([styleSheet respondsToSelector:@selector(iconImageForMessageType:)])
            {
                [[styleSheet iconImageForMessageType:self.messageType] drawInRect:CGRectMake(xOffset, yOffset, kCustomNotificationViewIconSize, kCustomNotificationViewIconSize)];
            }
        }
        CGContextRestoreGState(context);
        
        yOffset -= kCustomNotificationViewTextOffset;
        xOffset += kCustomNotificationViewIconSize + kCustomNotificationViewPadding;
        
        CGSize titleLabelSize = [self titleSize];
        CGSize descriptionLabelSize = [self descriptionSize];
        
        if (self.titleString && !self.descriptionString)
        {
            yOffset = ceil(rect.size.height * 0.5) - ceil(titleLabelSize.height * 0.5) - kCustomNotificationViewTextOffset;
        }
        
        if ([[UIDevice currentDevice] isRunningiOS7OrLater])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            [[self titleColor] set];
            [self.titleString drawWithRect:CGRectMake(xOffset, yOffset, titleLabelSize.width, titleLabelSize.height)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                attributes:@{NSFontAttributeName:[self titleFont], NSForegroundColorAttributeName:[self titleColor], NSParagraphStyleAttributeName:paragraphStyle}
                                   context:nil];
            
            yOffset += titleLabelSize.height;
            
            [[self descriptionColor] set];
            [self.descriptionString drawWithRect:CGRectMake(xOffset, yOffset, descriptionLabelSize.width, descriptionLabelSize.height)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                      attributes:@{NSFontAttributeName:[self descriptionFont], NSForegroundColorAttributeName:[self descriptionColor], NSParagraphStyleAttributeName:paragraphStyle}
                                         context:nil];
        }
        else
        {
            [[self titleColor] set];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self.titleString drawInRect:CGRectMake(xOffset, yOffset, titleLabelSize.width, titleLabelSize.height) withFont:[self titleFont] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
            
            yOffset += titleLabelSize.height;
            
            [[self descriptionColor] set];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self.descriptionString drawInRect:CGRectMake(xOffset, yOffset, descriptionLabelSize.width, descriptionLabelSize.height) withFont:[self descriptionFont] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - Getters

- (CGFloat)height
{
    CGSize titleLabelSize = [self titleSize];
    CGSize descriptionLabelSize = [self descriptionSize];
    return MAX((kCustomNotificationViewPadding * 2) + titleLabelSize.height + descriptionLabelSize.height + [self statusBarOffset], (kCustomNotificationViewPadding * 2) + kCustomNotificationViewIconSize + [self statusBarOffset]);
}

- (CGFloat)width
{
    return [self statusBarFrame].size.width;
}

- (CGFloat)statusBarOffset
{
    return [[UIDevice currentDevice] isRunningiOS7OrLater] ? [self statusBarFrame].size.height : 0.0;
}

- (CGFloat)availableWidth
{
    return ([self width] - (kCustomNotificationViewPadding * 3) - kCustomNotificationViewIconSize);
}

- (CGSize)titleSize
{
    CGSize boundedSize = CGSizeMake([self availableWidth], CGFLOAT_MAX);
    CGSize titleLabelSize;
    
    if ([[UIDevice currentDevice] isRunningiOS7OrLater])
    {
        NSDictionary *titleStringAttributes = [NSDictionary dictionaryWithObject:[self titleFont] forKey: NSFontAttributeName];
        titleLabelSize = [self.titleString boundingRectWithSize:boundedSize
                                                        options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:titleStringAttributes
                                                        context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titleLabelSize = [_titleString sizeWithFont:[self titleFont] constrainedToSize:boundedSize lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    
    return CGSizeMake(ceilf(titleLabelSize.width), ceilf(titleLabelSize.height));
}

- (CGSize)descriptionSize
{
    CGSize boundedSize = CGSizeMake([self availableWidth], CGFLOAT_MAX);
    CGSize descriptionLabelSize;
    
    if ([[UIDevice currentDevice] isRunningiOS7OrLater])
    {
        NSDictionary *descriptionStringAttributes = [NSDictionary dictionaryWithObject:[self descriptionFont] forKey: NSFontAttributeName];
        descriptionLabelSize = [self.descriptionString boundingRectWithSize:boundedSize
                                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:descriptionStringAttributes
                                                                    context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        descriptionLabelSize = [_descriptionString sizeWithFont:[self descriptionFont] constrainedToSize:boundedSize lineBreakMode:NSLineBreakByTruncatingTail];
#pragma clang diagnostic pop
    }
    
    return CGSizeMake(ceilf(descriptionLabelSize.width), ceilf(descriptionLabelSize.height));
}

- (CGRect)statusBarFrame
{
    CGRect windowFrame = NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ? [self orientFrame:[UIApplication sharedApplication].keyWindow.frame] : [UIApplication sharedApplication].keyWindow.frame;
    CGRect statusFrame = NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ?  [self orientFrame:[UIApplication sharedApplication].statusBarFrame] : [UIApplication sharedApplication].statusBarFrame;
   // return CGRectMake(windowFrame.origin.x, windowFrame.origin.y, windowFrame.size.width, statusFrame.size.height);
    
     return CGRectMake(windowFrame.origin.x, windowFrame.origin.y, windowFrame.size.width, statusFrame.size.height);
}

- (UIFont *)titleFont
{
    if ([self.delegate respondsToSelector:@selector(styleSheetForMessageView:)])
    {
        id<CustomNotificationViewStyleSheet> styleSheet = [self.delegate styleSheetForMessageView:self];
        if ([styleSheet respondsToSelector:@selector(titleFontForMessageType:)])
        {
            return [styleSheet titleFontForMessageType:self.messageType];
        }
    }
    return kCustomNotificationViewTitleFont;
}

- (UIFont *)descriptionFont
{
    if ([self.delegate respondsToSelector:@selector(styleSheetForMessageView:)])
    {
        id<CustomNotificationViewStyleSheet> styleSheet = [self.delegate styleSheetForMessageView:self];
        if ([styleSheet respondsToSelector:@selector(descriptionFontForMessageType:)])
        {
            return [styleSheet descriptionFontForMessageType:self.messageType];
        }
    }
    return kCustomNotificationViewDescriptionFont;
}

- (UIColor *)titleColor
{
    if ([self.delegate respondsToSelector:@selector(styleSheetForMessageView:)])
    {
        id<CustomNotificationViewStyleSheet> styleSheet = [self.delegate styleSheetForMessageView:self];
        if ([styleSheet respondsToSelector:@selector(titleColorForMessageType:)])
        {
            return [styleSheet titleColorForMessageType:self.messageType];
        }
    }
    return kCustomNotificationViewTitleColor;
}

- (UIColor *)descriptionColor
{
    if ([self.delegate respondsToSelector:@selector(styleSheetForMessageView:)])
    {
        id<CustomNotificationViewStyleSheet> styleSheet = [self.delegate styleSheetForMessageView:self];
        if ([styleSheet respondsToSelector:@selector(descriptionColorForMessageType:)])
        {
            return [styleSheet descriptionColorForMessageType:self.messageType];
        }
    }
    return kCustomNotificationViewDescriptionColor;
}

#pragma mark - Helpers

- (CGRect)orientFrame:(CGRect)frame
{
    return frame;
}

#pragma mark - Notifications

- (void)didChangeDeviceOrientation:(NSNotification *)notification
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self statusBarFrame].size.width, self.frame.size.height);
    [self setNeedsDisplay];
}

@end

@implementation CustomNotificationViewDefaultMessageBarStyleSheet

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [CustomNotificationViewDefaultMessageBarStyleSheet class])
	{
        // Colors (background)
        kCustomNotificationViewDefaultMessageBarStyleSheetBackgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]; //[UIColor colorWithRed:1.0 green:0.611 blue:0.0 alpha:kCustomNotificationViewStyleSheetMessageBarAlpha]; // orange
        
        // Colors (stroke)
        kCustomNotificationViewDefaultMessageBarStyleSheetStrokeColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]; //[UIColor colorWithRed:0.949f green:0.580f blue:0.0f alpha:1.0f]; // orange
    }
}

+ (CustomNotificationViewDefaultMessageBarStyleSheet *)styleSheet
{
    return [[CustomNotificationViewDefaultMessageBarStyleSheet alloc] init];
}

#pragma mark - CustomNotificationViewStyleSheet

- (nonnull UIColor *)backgroundColorForMessageType:(CustomNotificationViewMessageType)type
{
    UIColor *backgroundColor = nil;
    switch (type)
    {
        case CustomNotificationViewMessage:
            backgroundColor = kCustomNotificationViewDefaultMessageBarStyleSheetBackgroundColor;
            break;
    }
    return backgroundColor;
}

- (nonnull UIColor *)strokeColorForMessageType:(CustomNotificationViewMessageType)type
{
    UIColor *strokeColor = nil;
    switch (type)
    {
        case CustomNotificationViewMessage:
            strokeColor = kCustomNotificationViewDefaultMessageBarStyleSheetStrokeColor;
            break;
    }
    return strokeColor;
}

- (nonnull UIImage *)iconImageForMessageType:(CustomNotificationViewMessageType)type
{
    UIImage *iconImage = nil;
    switch (type)
    {
        case CustomNotificationViewMessage:
            iconImage = [UIImage imageNamed:kCustomNotificationViewStyleSheetImageIcon];
            break;
    }
    return iconImage;
}

@end

@implementation CustomNotificationViewWindow

#pragma mark - Touches

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    /*
     * Pass touches through if they land on the rootViewController's view.
     * Allows notification interaction without blocking the window below.
     */
    if ([hitView isEqual: self.rootViewController.view])
    {
        hitView = nil;
    }
    
    return hitView;
}

@end

@implementation UIDevice (Additions)

#pragma mark - OS Helpers

- (BOOL)isRunningiOS7OrLater
{
    NSString *systemVersion = self.systemVersion;
    NSUInteger systemInt = [systemVersion intValue];
    return systemInt >= kCustomNotificationViewiOS7Identifier;
}

@end

@implementation CustomNotificationViewViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [CustomNotificationViewManager sharedInstance].managerSupportedOrientationsMask;
}

#pragma mark - Setters

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    
    if ([[UIDevice currentDevice] isRunningiOS7OrLater])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;

    if ([[UIDevice currentDevice] isRunningiOS7OrLater])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

@end
