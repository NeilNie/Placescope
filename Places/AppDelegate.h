//
//  AppDelegate.h
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

NSTimer *timer;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

