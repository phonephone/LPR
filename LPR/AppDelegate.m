//
//  AppDelegate.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "LeftMenu.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize loginStatus;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckConnection" object:reach];
        });
    };
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    };
    [reach startNotifier];
    
    sharedManager = [Singleton sharedManager];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    
    if (sharedManager.loginStatus == YES) {
        UINavigationController *navi = [storyboard instantiateViewControllerWithIdentifier:@"Navi"];
        UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
        //UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
        
        [container setLeftMenuViewController:leftSideMenuViewController];
        //[container setRightMenuViewController:rightSideMenuViewController];
        [container setCenterViewController:navi];
    }
    else{
        UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        //Login *login = [[Login alloc]initWithNibName:@"Login" bundle:nil];
        UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
        
        [container setLeftMenuViewController:leftSideMenuViewController];
        [container setCenterViewController:login];
    }
    
    if (IS_IPHONE) {
        //[container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.7];
        [container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.80];
        
    }
    if (IS_IPAD) {
        //[container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.4];
        [container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.5];
    }
    [container setMenuSlideAnimationEnabled:YES];
    [container setMenuSlideAnimationFactor:3.0f];
    [container setMenuAnimationDefaultDuration:1.0f];
    
    
    sleep(2);
    
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
