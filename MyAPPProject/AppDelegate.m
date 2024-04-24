//
//  AppDelegate.m
//  test
//
//  Created by 俞昊 on 2022/10/10.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    
    self.viewController = [[ViewController alloc] init];
    self.viewController.title = @"Main Page";
    self.viewController.tabBarItem.image = [[UIImage imageNamed:@"MainPage"] imageWithRenderingMode:UIImageRenderingModeAutomatic] ;
    
    self.MAMyPageViewController = [[MAMyPageViewController alloc] init];
    self.MAMyPageViewController.title = @"Setting";
    self.MAMyPageViewController.tabBarItem.image = [[UIImage imageNamed:@"Setting"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:112.0/255.0 green:100.0/255.0 blue:225.0/255.0 alpha:1.0];
    NSArray *viewControllerArray = [NSArray arrayWithObjects:self.viewController, self.MAMyPageViewController, nil];
    self.tabBarController.viewControllers = viewControllerArray;

    self.window.rootViewController = self.tabBarController;
    //self.tabBarController.tabBar.translucent = NO;
    return YES;
}


@end
