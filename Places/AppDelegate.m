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

    //Check the Username string and display UIViewController
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *StartView = [MainStoryBoard instantiateViewControllerWithIdentifier:@"welcome"];
    UIViewController *Viewcontroller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        self.window.rootViewController = Viewcontroller;
        [self.window makeKeyAndVisible];

    } else {
        self.window.rootViewController = StartView;
        [self.window makeKeyAndVisible];
    }
        
    application.applicationIconBadgeNumber = 0;

    //register for notification
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
    // Override point for customization after application launch.
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
