//
//  Singleton.m
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Singleton.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation Singleton

@synthesize fontSize,fontLight,fontRegular,fontMedium,fontSemibold,fontBold,loginStatus,memberID,memberToken,mainThemeColor,subThemeColor,btnThemeColor,provinceJSON,profileJSON,mainRoot,mainCarbon;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"th", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        mainThemeColor = [UIColor colorWithRed:61.0/255 green:166.0/255 blue:220.0/255 alpha:1];
        subThemeColor = [UIColor colorWithRed:243.0/255 green:165.0/255 blue:39.0/255 alpha:1];
        btnThemeColor = [UIColor colorWithRed:222.0/255 green:122.0/255 blue:44.0/255 alpha:1];
        
        fontLight = @"Kanit-Light";
        fontRegular = @"Kanit-Regular";
        fontMedium = @"Kanit-Medium";
        fontSemibold = @"Kanit-SemiBold";
        fontBold = @"Kanit-Bold";
        
        memberID = @"";
        memberToken = @"";
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        loginStatus = [ud boolForKey:@"loginStatus"];
        
        if (loginStatus == YES) {
            memberID = [ud stringForKey:@"memberID"];
            NSLog(@"LOG IN %@",memberID);
        }
        else{
            NSLog(@"LOG OUT");
        }
        
        //loginStatus = NO;
        //loginStatus = YES;
        
        if (IS_IPHONE) {
            float factor = [UIScreen mainScreen].bounds.size.width/320;
            fontSize = 13*factor;
        }
        if (IS_IPAD) {
            float factor = [UIScreen mainScreen].bounds.size.width/768;
            fontSize = 25*factor;
        }
    }
    return self;
}

@end

