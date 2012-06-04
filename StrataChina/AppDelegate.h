//
//  AppDelegate.h
//  StrataChina
//
//  Created by Douglas Wan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstRootViewController;
@class SecondRootViewController;
@class ThirdRootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *firstNavigationController;
@property (nonatomic, strong) FirstRootViewController *firstRootViewController;

@property (nonatomic, strong) UINavigationController *secondNavigationController;
@property (nonatomic, strong) SecondRootViewController *secondRootViewController;

@property (nonatomic, strong) UINavigationController *thirdNavigationController;
@property (nonatomic, strong) ThirdRootViewController  *thirdRootViewController;

@property (nonatomic, strong) UITabBarController *tabBarController;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
