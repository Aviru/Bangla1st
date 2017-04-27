//
//  BaseVCViewController.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 01/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "BaseVC.h"
#import "VideoDetails+CoreDataClass.h"

NSString *const kUIActivityIndicatorView = @"UIActivityIndicatorView";
NSString *const kAviActivityIndicator = @"AviActivityIndicator";
NSString *const kAviCircularSpinner = @"AviCircularSpinner";
NSString *const kAviBeachBallSpinner = @"AviBeachBallSpinner";

@interface BaseVC ()

@property(nonatomic,strong) AviSpinner *spinner;

@end

@implementation BaseVC

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
}

-(void)initWithParentView:(UIView *)parentView isTranslateToAutoResizingMaskNeeded:(BOOL)boolVal leftButton:(BOOL)isLeftButton rightButton:(BOOL)isRightButton navigationTitle:(NSString *)navigationTitle navigationTitleTextAlignment:(NSTextAlignment)navTitleTextAlignment navigationTitleFontType:(UIFont *)fontType  leftImageName:(NSString *)strLeftImageName leftLabelName:(NSString *)strLeftLabelName  rightImageName:(NSString *)strRightImageName rightLabelName:(NSString *)strRightLabelName
{
    self.navBar= [[[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self options:nil] lastObject];
    
    self.navBar.navBarLeftImage.hidden = !isLeftButton;
    self.navBar.navBarLeftButtonOutlet.hidden = !isLeftButton;
    
    self.navBar.navBarRightImage.hidden=!isRightButton;
    self.navBar.navBarRightButtonOutlet.hidden=!isRightButton;
    
    if (!(navigationTitle==nil))
    {
        self.navBar.navBarLabelHeadingTitle.font = fontType;
        self.navBar.navBarLabelHeadingTitle.text=navigationTitle;
        self.navBar.navBarLabelHeadingTitle.textAlignment=navTitleTextAlignment;
    }

    
    if(!(strLeftImageName==nil))
        self.navBar.navBarLeftImage.image=[UIImage imageNamed:strLeftImageName];
    
    if(!(strRightImageName==nil))
        self.navBar.navBarRightImage.image=[UIImage imageNamed:strRightImageName];
    
    if(!(strLeftLabelName==nil))
        self.navBar.navBarLeftLabel.text = strLeftLabelName;
        
    if(!(strRightLabelName==nil))
        self.navBar.navBarRightLabel.text = strRightLabelName;
    
    [parentView addSubview:self.navBar];
    
    if (boolVal)
    {
        self.navBar.translatesAutoresizingMaskIntoConstraints = YES;
    }
    else
    {
        self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
       
    }
    
     [self boundWithSameSizeConstraint:self.navBar withParent:parentView];
    
}

-(void)boundWithSameSizeConstraint:(UIView *)childView withParent:(UIView *)parentView
{
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:childView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:parentView
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:childView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:parentView
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:childView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:parentView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:childView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [parentView addConstraint:width];
    [parentView addConstraint:height];
    [parentView addConstraint:top];
    [parentView addConstraint:leading];
}
 

#pragma mark
#pragma mark - Get Offline saved Video count
#pragma mark
-(void)getOfflineSavedVideoCount
{
    NSMutableArray *results = [VideoDetails fetchVideoDetailsWithEntityName:@"VideoDetails" managedObjectContext:[self managedObjectContext]];
    
    if (results.count > 0)
    {
        self.appDel.videoCount = (int)results.count;
    }
}

#pragma mark
#pragma mark - ACtivity Indicator
#pragma mark

-(AviSpinner *)initializeAndStartActivityIndicator:(UIView *)view
{
    self.spinner = [[AviSpinner alloc] initWithSpinnerType:kAviCircularSpinner];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.radius = 20;
    self.spinner.pathColor = [UIColor whiteColor];
    self.spinner.fillColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0];
    self.spinner.thickness = 3;
    
    [self.spinner setBounds:CGRectMake(0, 0, 50, 50)]; //
    self.spinner.center = view.center;
    [view addSubview:self.spinner];
    view.userInteractionEnabled = NO;
    [self.spinner startAnimating];
    
    return self.spinner;
}

-(AviSpinner *)StopActivityIndicator:(UIView *)view
{
    self.spinner = [self activityForView:view];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.center = view.center;
    [view addSubview:self.spinner];
    view.userInteractionEnabled = YES;
    [self.spinner stopAnimating];
    
    return self.spinner;
}

-(AviSpinner *)activityForView:(UIView *)view
{
    self.spinner = nil;
    NSArray *subviews = view.subviews;
    Class activityClass = [AviSpinner class];
    for (UIView *view in subviews)
    {
        if ([view isKindOfClass:activityClass])
        {
            self.spinner = (AviSpinner *)view;
        }
    }
    
    return self.spinner;
}

#pragma mark
#pragma mark - Password Check
#pragma mark

-(BOOL)isContainUpperCase:(NSString *)checkString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    NSLog(@"boll===%d",[passwordTest evaluateWithObject:checkString]);
    //   return [passwordTest evaluateWithObject:checkString];
    
    //get all uppercase character set
    NSCharacterSet *cset = [NSCharacterSet uppercaseLetterCharacterSet];
    //Find range for uppercase letters
    NSRange range = [checkString rangeOfCharacterFromSet:cset];
    //check it conatins or not
    if (range.location == NSNotFound) {
        
        NSLog(@"not any capital");
        return false;
    }
    else
    {
        NSLog(@"has one capital");
        return true;
    }
    return false;
}

-(BOOL)isContainLowerCase:(NSString *)checkString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    NSLog(@"boll===%d",[passwordTest evaluateWithObject:checkString]);
    //   return [passwordTest evaluateWithObject:checkString];
    
    //get all uppercase character set
    NSCharacterSet *cset = [NSCharacterSet lowercaseLetterCharacterSet];
    //Find range for uppercase letters
    NSRange range = [checkString rangeOfCharacterFromSet:cset];
    //check it conatins or not
    if (range.location == NSNotFound)
    {
        NSLog(@"not any isContainLowerCase");
        return false;
    }
    else
    {
        NSLog(@"has one isContainLowerCase");
        return true;
    }
    return false;
}

-(BOOL)isContainSpecialCase:(NSString *)checkString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    NSLog(@"boll===%d",[passwordTest evaluateWithObject:checkString]);
    //   return [passwordTest evaluateWithObject:checkString];
    
    
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([checkString.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        NSLog(@"contains special characters");
        return true;
    }
    else
    {
        NSLog(@"NOT contains special characters");
        return false;
    }
    return false;
}

-(BOOL)isLengthMoreThan6:(NSString *)checkString
{
    if (checkString.length>=6)
    {
        return true;
    }
    else
    {
        return false;
    }
    return false;
}

-(BOOL)isContainDigit:(NSString *)checkString
{
    NSString *digit = @"01234567890";
    NSCharacterSet *digitSet = [NSCharacterSet
                                characterSetWithCharactersInString:digit];
    
    if ([checkString.lowercaseString rangeOfCharacterFromSet:digitSet].length)
    {
        NSLog(@"contains digit characters");
        return true;
    }
    else
    {
        NSLog(@"NOT contains digit characters");
        return false;
    }
    return false;
}
#pragma mark

#pragma mark
#pragma mark is valid email
#pragma mark

-(BOOL)isValidEmail:(NSString*)strEmailID
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmailID];
}

#pragma mark
#pragma mark Display Error Message
#pragma mark

-(void)displayErrorWithMessage:(NSString*)strMsg
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:actionOK];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
