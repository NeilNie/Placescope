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
    
    [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_-yffmhMwpg" withAppSecret:@"7c0c198cb2fe4e4c9d818bb0df23d9dc" usingOptions:nil];
    
    //Check the Username string and display UIViewController
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *StartView = [MainStoryBoard instantiateViewControllerWithIdentifier:@"welcome"];
    UIViewController *Viewcontroller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    if (![KCSUser activeUser]) {
        self.window.rootViewController = StartView;
        [self.window makeKeyAndVisible];

    } else {
        self.window.rootViewController = Viewcontroller;
        [self.window makeKeyAndVisible];
    }
    
    application.applicationIconBadgeNumber = 0;

    //register for notification
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    INTULocationRequestID locationRequestID;
    
    locationRequestID = [locMgr subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            
            // A new updated location is available in currentLocation, create and push a notification
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:120];
            notification.fireDate = date;
            notification.alertTitle = @"You are at a new place";
            notification.alertBody = @"It seems like you are traveling. Open Placescope and find the right places for you.";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            NSLog(@"%@", notification);
            
            traveling = YES;
            [[NSUserDefaults standardUserDefaults] setBool:traveling forKey:@"traveling"];
        }
        else {
            // An error occurred
            NSLog(@"Location Manager Error");
        }
    }];
    
    if (traveling == YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:60*60 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
        
    }else if ([string integerValue] == 12){
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        notification.fireDate = date;
        notification.alertTitle = @"Hey, It's lunch time!";
        notification.alertBody = @"Open Placescope to find the best restaurant for you!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];

        //send local notification lunch
    }else if ([string integerValue] == 18){
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        notification.fireDate = date;
        notification.alertTitle = @"Dinner is the best part of the day!";
        notification.alertBody = @"Placescope finds you the best restaurant for you!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //local notification dinner
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [timer invalidate];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are in a new place"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

@end
