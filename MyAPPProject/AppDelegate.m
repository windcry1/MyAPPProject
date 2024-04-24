//
//  AppDelegate.m
//  test
//
//  Created by 俞昊 on 2022/10/10.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *vc1;
@property (nonatomic, strong) UINavigationController *vc2;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    
    self.viewController = [[ViewController alloc] init];
    self.viewController.title = @"首页";
    self.vc1 = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.vc1.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.MAMyPageViewController = [[MAMyPageViewController alloc] init];
    self.MAMyPageViewController.title = @"设置";
    self.vc2 = [[UINavigationController alloc] initWithRootViewController:self.MAMyPageViewController];
    self.vc2.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:112.0/255.0 green:100.0/255.0 blue:225.0/255.0 alpha:1.0];
    NSArray *viewControllerArray = [NSArray arrayWithObjects:self.vc1, self.vc2, nil];
    self.tabBarController.viewControllers = viewControllerArray;
    
    self.window.rootViewController = self.tabBarController;
    //self.tabBarController.tabBar.translucent = NO;
    return YES;
}

@end
