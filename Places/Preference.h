//
//  Preference.h
//  Placescope
//
//  Created by Yongyang Nie on 1/5/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>

BOOL areAdsRemoved;

BOOL dailyNotification;

@interface Preference : UIViewController <UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate>{
    NSMutableArray *array;
}
@property (weak, nonatomic) IBOutlet UITableView *Table;

@end
