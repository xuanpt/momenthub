//
//  AppDelegate.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//


#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "MainViewController.h"
#import "UpdateMomentViewController.h"
#import "MomentBrowseViewController.h"
#import "SettingViewController.h"
#import "ProgressHUD.h"


@implementation AppDelegate {
    UITabBarController *mainTabBarController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:kParseApplicationID clientKey:kParseClientKey];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
	[PFImageView class];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([PFUser currentUser] == nil) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[WelcomeViewController alloc] init]];
        self.window.rootViewController = navigationController;
    } else {
        [SystemInfo sharedInstance];
        [self showMainScreen];
    }
	
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processUserLoggedIn) name:NOTIFICATION_USER_LOGGED_IN object:nil];
	return YES;
}


- (void)processUserLoggedIn {
    [self showMainScreen];
}


- (void)showMainScreen {
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:[[MomentBrowseViewController alloc] init]];
    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:[[UpdateMomentViewController alloc] init]];
    UINavigationController *navController4 = [[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]];
    
    mainTabBarController = [[UITabBarController alloc] init];
    mainTabBarController.viewControllers = [NSArray arrayWithObjects:navController1, navController2, navController3, navController4, nil];
    mainTabBarController.tabBar.translucent = NO;
    mainTabBarController.selectedIndex = DEFAULT_TAB;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:UIColorFromRGBValues(21, 126, 251)];

    self.window.rootViewController = mainTabBarController;
}


- (void)changeTabBarSelectedIndex:(int)selectedIndex {
    mainTabBarController.selectedIndex = selectedIndex;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	[FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - Facebook responses
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
