//
//  TodayViewController.h
//  Placescope Widget
//
//  Created by Yongyang Nie on 3/31/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "InterestPointTableViewCell.h"

@interface TodayViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    int priceLevel;
    NSString *favoriteType;
    BOOL liked;
    BOOL shared;
    
    NSMutableArray *results;
    
    CLLocationCoordinate2D currentCentre;
    CLLocationManager *locationManager;
    
    NSDateFormatter *dateformat;
}

@property (weak, nonatomic) IBOutlet UIImageView *sadFace;
@property (weak, nonatomic) IBOutlet UILabel *noResult;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
