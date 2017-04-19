//
//  AppDelegate.h
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>

#import "PreferenceViewController.h"
#import "INTULocationManager.h"
#import "ViewController.h"
#import "UserList.h"

@import GoogleMobileAds;

NSTimer *timer;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate>{
    
    BOOL notified;
    BOOL traveling;
}

@property (strong, nonatomic) UIWindow *window;


@end

