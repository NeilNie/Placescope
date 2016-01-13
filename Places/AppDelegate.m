//
//  AppDelegate.m
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse.h>
#import "INTULocationManager.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"QWKjB4xFEvXzI8wOGHdSD1SsLBSDNyVS22qBnDgS"
                  clientKey:@"voWCiHsFuaN8ssQj4HEYFztVy6wE9ltBmi0ikfTL"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Check the Username string and display UIViewController
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *StartView = [MainStoryBoard instantiateViewControllerWithIdentifier:@"welcome"];
    UIViewController *Viewcontroller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    PFUser *currentUser = [PFUser currentUser];
    self.window.rootViewController = Viewcontroller;
    [self.window makeKeyAndVisible];
    if (currentUser) {
        
    }else{
        //self.window.rootViewController = StartView;
        //[self.window makeKeyAndVisible];
    }
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
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
            // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
            notification.alertBody = @"It seems like you are traveling. Open Placescope and find places around you.";
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else {
            // An error occurred
            NSLog(@"Location Manager Error");
        }
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)updatetime{
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"hh"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] == 7) {
        
    }
    NSLog(@"%d", [string intValue]);
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

@end
