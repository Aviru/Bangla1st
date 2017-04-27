//
//  SyncManager.m
//  Snofolio_Instructor
//
//  Created by appsbee on 11/01/17.
//  Copyright © 2017 appsbee. All rights reserved.
//

#import "ReachabilityManager.h"
#import "ContentListingWebService.h"
#import "CountryListWebService.h"
#import "UserTypeListWebService.h"
#import "UIAlertController+Window.h"
#import "ModelCountryList.h"
#import "ModelUserTypeList.h"


@interface ReachabilityManager ()


@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation ReachabilityManager

@synthesize appDel;

#pragma mark -
#pragma mark Default Manager
+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        
        appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
    }
    
    return self;
}



#pragma mark
#pragma mark reachability helping methods
#pragma mark

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];

}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        appDel.isRechable= [reachability connectionRequired];
    }
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            appDel.isRechable = NO;
            NSLog(@"Internet not rechable");
            break;
        }
        case ReachableViaWWAN:
        {
            appDel.isRechable=YES;
            NSLog(@"Internet rechable via WAN");
            
            if (![[GlobalUserDefaults getObjectWithKey:IS_FIRST_TIME] isEqualToString:@"YES"])
            {
                [self getIMAadLink];
            }
            
            break;
        }
        case ReachableViaWiFi:
        {
            appDel.isRechable=YES;
            NSLog(@"Internet rechable via WIFI");
          
            if (![[GlobalUserDefaults getObjectWithKey:IS_FIRST_TIME] isEqualToString:@"YES"])
            {
                [self getIMAadLink];
            }

            if (![GlobalUserDefaults getObjectWithKey:COUNTRY_LIST])
            {
                [self getCountryList];
            }
            
            if (![GlobalUserDefaults getObjectWithKey:USER_TYPE])
            {
                [self getUsertypeList];
            }

            break;
        }
    }
}

#pragma mark - get IMA Ad URL

-(void)getIMAadLink
{
    NSDictionary *dictParams= @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a"
                                };
    
    
    [[ContentListingWebService service] callIMAadWebServiceWithDictParams:dictParams success:^(id _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            self.appDel.objModelAdId = [[ModelIMAad alloc]initWithDictionary:response[@"ResponseData"]];
            
            NSData *IMAData = [NSKeyedArchiver archivedDataWithRootObject:self.appDel.objModelAdId];
            
            [GlobalUserDefaults saveObject:IMAData withKey:IMA_DETAILS];
            
            [GlobalUserDefaults saveObject:@"YES" withKey:IS_FIRST_TIME];
            
        }
        else
        {
            NSLog(@"%@", strMsg);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }
        
    } failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        if (![strMsg isEqualToString:NO_NETWORK])
        {
             NSLog(@"error: %@", error.userInfo);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }
    }];
    
    
}

#pragma mark - get Country List

-(void)getCountryList
{
    NSDictionary *dictParams= @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a"
                                };
    
    [[CountryListWebService service] callCountryListWebServiceWithDictParams:dictParams success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            if ([response isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response;
                NSMutableArray *arrCountryList = [NSMutableArray new];
                for (int  i =0; i<[arr count]; i++)
                {
                    ModelCountryList *modelObjCountryList = [[ModelCountryList alloc]initWithDictionary:arr[i]];
                    [arrCountryList addObject:modelObjCountryList];
                }
                
                NSData *countryListData = [NSKeyedArchiver archivedDataWithRootObject:arrCountryList];
                
                [GlobalUserDefaults saveObject:countryListData withKey:COUNTRY_LIST];
                
                self.appDel.arrCountryList = [NSMutableArray new];
                
                self.appDel.arrCountryList = [NSKeyedUnarchiver unarchiveObjectWithData:countryListData];
            }
            else
            {
                NSLog(@"Response is not an array");
            }
            
        }
        else
        {
            NSLog(@"%@", strMsg);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }
    }
    failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        if (![strMsg isEqualToString:NO_NETWORK])
        {
            NSLog(@"error: %@", error.userInfo);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }
    }];
}


#pragma mark - get User Type List

-(void)getUsertypeList
{
    NSDictionary *dictParams= @{@"ApiKey":@"0a2b8d7f9243305f2a4700e1870f673a"
                                };
    [[UserTypeListWebService service] callUserTypeListWebServiceWithDictParams:dictParams success:^(id  _Nullable response, NSString * _Nullable strMsg) {
        
        if (response != nil)
        {
            if ([response isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (id)response;
                NSMutableArray *arrUserTypeList = [NSMutableArray new];
                for (int  i =0; i<[arr count]; i++)
                {
                    ModelUserTypeList *modelObjUserTypeList = [[ModelUserTypeList alloc]initWithDictionary:arr[i]];
                    [arrUserTypeList addObject:modelObjUserTypeList];
                }
                
                NSData *userTypeListData = [NSKeyedArchiver archivedDataWithRootObject:arrUserTypeList];
                
                [GlobalUserDefaults saveObject:userTypeListData withKey:USER_TYPE];
                
                self.appDel.arrUserTypeList = [NSMutableArray new];
                
                self.appDel.arrUserTypeList = [NSKeyedUnarchiver unarchiveObjectWithData:userTypeListData];
            }
            else
            {
                NSLog(@"Response is not an array");
            }
            
        }
        else
        {
            NSLog(@"%@", strMsg);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }
    }
    failure:^(NSError * _Nullable error, NSString * _Nullable strMsg) {
        
        if (![strMsg isEqualToString:NO_NETWORK])
        {
            NSLog(@"error: %@", error.userInfo);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert show];
        }

    }];
}

#pragma mark
#pragma mark Memory Management
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.hostReachability stopNotifier];
    [self.internetReachability stopNotifier];
}

@end
