//
//  AppDelegate.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Singleton *sharedManager;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL loginStatus;
@end

