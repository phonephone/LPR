//
//  Singleton.h
//  LPR
//
//  Created by Firststep Consulting on 3/8/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MFSideMenu/MFSideMenu.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <CarbonKit/CarbonKit.h>

#define HOST_DOMAIN @"http://www.tmadigital.com/lpr/API/"

@interface Singleton : NSObject

@property (nonatomic) float fontSize;
@property (strong, nonatomic) NSString *fontLight;
@property (strong, nonatomic) NSString *fontRegular;
@property (strong, nonatomic) NSString *fontMedium;
@property (strong, nonatomic) NSString *fontSemibold;
@property (strong, nonatomic) NSString *fontBold;

@property (nonatomic) BOOL loginStatus;
@property (strong, nonatomic) NSString *memberID;
@property (strong, nonatomic) NSString *memberToken;

@property (strong, nonatomic) UIColor *mainThemeColor;
@property (strong, nonatomic) UIColor *subThemeColor;
@property (strong, nonatomic) UIColor *btnThemeColor;

@property (strong, nonatomic) NSMutableDictionary *profileJSON;
@property (strong, nonatomic) NSMutableArray *provinceJSON;

@property (strong, nonatomic) MFSideMenuContainerViewController *mainRoot;

@property (strong, nonatomic) CarbonTabSwipeNavigation *mainCarbon;

+ (id)sharedManager;

@end
