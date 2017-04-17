//
//  Preference.h
//  Placescope
//
//  Created by Yongyang Nie on 1/5/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "UserInfo.h"
#import <StoreKit/StoreKit.h>
#import <Realm/Realm.h>

@import GoogleMobileAds;

BOOL areAdsRemoved;

BOOL dailyNotification;

@interface PreferenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate, GADAdDelegate, GADBannerViewDelegate, UITextFieldDelegate>{
    
    NSMutableArray *array;
    NSMutableArray *array2;
    UserInfo *info;
    RLMResults *objects;
}
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
