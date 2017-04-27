//
//  AppDelegate.h
//  Bangla 1st
//
//  Created by Abhijit Rana on 18/03/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ModelIMAad.h"
#import "ModelUserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (copy) void (^backgroundSessionCompletionHandler)();

@property (strong, nonatomic) UIWindow *window;

@property (assign,nonatomic)int videoCount;

@property (strong, nonatomic) UINavigationController *navigationController;

@property(assign,nonatomic) BOOL isRechable;

@property(assign,nonatomic) BOOL isAdRequested;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) ModelIMAad *objModelAdId;

@property (strong, nonatomic)ModelUserInfo *objModelUserInfo;

@property (strong, nonatomic)NSMutableArray *arrCountryList;
@property (strong, nonatomic)NSMutableArray *arrUserTypeList;
-(void)setTabBarControllerInHome:(int)index tabBar:(UITabBarController *)tabController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

