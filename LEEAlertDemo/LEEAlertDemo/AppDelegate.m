//
//  AppDelegate.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/3/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarViewController.h"

#import "NavigationViewController.h"

#import "AlertTableViewController.h"

#import "ActionSheetTableViewController.h"

#import "LEEAlert.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    NSArray *classArray = @[@"AlertTableViewController" , @"ActionSheetTableViewController"];
    
    NSArray *titleArray = @[@"Alert" , @"ActionSheet"];
    
    NSMutableArray *ncArray = [NSMutableArray array];
    
    [classArray enumerateObjectsUsingBlock:^(id _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NavigationViewController *nc = [[NavigationViewController alloc] initWithRootViewController:[[NSClassFromString(class) alloc] init]];
        [nc.navigationBar setTranslucent:NO];
        [ncArray addObject:nc];
        
        nc.tabBarItem.title = titleArray[idx];
    }];
    
    TabBarViewController *tbc = [[TabBarViewController alloc] init];
    
    tbc.viewControllers = ncArray;
    
    self.window.rootViewController = tbc;
    
    // ⚠️ 设置主Window
    [LEEAlert configMainWindow:self.window];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
