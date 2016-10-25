//
//  AppDelegate.h
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <Realm/Realm.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseCore/FirebaseCore.h>
#import "INTULocationManager.h"
#import "ViewController.h"
#import "Preference.h"
#import "UserList.h"

@import GoogleMobileAds;

NSTimer *timer;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>{
    
    BOOL notified;
    BOOL traveling;
}

@property (strong, nonatomic) UIWindow *window;


@end

