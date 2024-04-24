//
//  AppDelegate.h
//  test
//
//  Created by 俞昊 on 2022/10/10.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MAMyPageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) MAMyPageViewController *MAMyPageViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIWindow *window;

@end

