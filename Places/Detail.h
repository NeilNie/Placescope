//
//  Detail.h
//  Placescope
//
//  Created by Yongyang Nie on 1/9/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import <CoreLocation/CoreLocation.h>
#import <Realm/Realm.h>
#import "UserList.h"
#import "Preference.h"

@import GoogleMobileAds;

NSMutableString *placeid;
MapPoint *coordinate;

@interface Detail : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>{
    
    CLLocationCoordinate2D currentCentre;
    CLLocationManager *locationManager;
    UIImage *photo;
    NSMutableArray *array;
    NSMutableArray *array2;
    
    NSMutableArray *reviewer;
    NSMutableArray *reviews;
    NSMutableArray *ratingArray;
    
    NSDictionary *searchResult;
}
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (IBAction)navigate:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)save:(id)sender;
@end
