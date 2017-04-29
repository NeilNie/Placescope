//
//  AppDelegate.m
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [FIRApp configure];
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyDlYmAFnPNXSeNHJgf0HbsLH4oRo6Qd_oA"];
    
    //Check the Username string and display UIViewController
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *StartView = [MainStoryBoard instantiateViewControllerWithIdentifier:@"welcome"];
    UIViewController *Viewcontroller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    
    if ([[FIRAuth auth] currentUser]) {
        self.window.rootViewController = Viewcontroller;
        [self.window makeKeyAndVisible];

    } else {
        self.window.rootViewController = StartView;
        [self.window makeKeyAndVisible];
    }
    //debugging only
    //self.window.rootViewController = Viewcontroller;
    //[self.window makeKeyAndVisible];
    
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"%@", error);
        }
    }];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"we have issues %@", error);
        }
    }];
    [FIRMessaging messaging].remoteMessageDelegate = self;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    INTULocationRequestID locationRequestID;
    
    locationRequestID = [locMgr subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess && notified == NO) {
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:120];
            notification.fireDate = date;
            notification.alertTitle = @"You are at a new place";
            notification.alertBody = @"It seems like you are traveling. Open Placescope and find the right places for you.";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber] + 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            notified = YES;
            traveling = YES;
        }
    }];
    
    if (traveling == YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:60*60 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    }
}

-(void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage{
    
}

-(void)updatetime{
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"HH"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] == 7) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        notification.fireDate = date;
        notification.alertTitle = @"Maybe it's time for breakfast and coffee";
        notification.alertBody = @"Open Placescope to find the best coffee shop for you!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }else if ([string intValue] == 12){
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        notification.fireDate = date;
        notification.alertTitle = @"Hey, It's lunch time!";
        notification.alertBody = @"Open Placescope to find the best restaurant for you!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    }else if ([string intValue] == 18){
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        notification.fireDate = date;
        notification.alertTitle = @"Dinner is the best part of the day!";
        notification.alertBody = @"Placescope finds you the best restaurant for you!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //local notification dinner
    }else if ([string intValue] == 24){
        notified = NO;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [timer invalidate];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You are in a new place" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // continue your work
            
            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow.hidden = YES;
        }]];
        
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - WCSession

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}
-(void)sessionDidBecomeInactive:(WCSession *)session{
    
}
-(void)sessionDidDeactivate:(WCSession *)session{
    
}

@end
