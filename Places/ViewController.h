//
//  ViewController.h
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <Realm/Realm.h>
#import "MapPoint.h"
#import "TableViewCell.h"
#import "Reachability.h"
#import "Detail.h"
#import "UserInfo.h"

@import GoogleMobileAds;

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GADAdDelegate, GADBannerViewDelegate>{
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    
    NSMutableArray *searchResult;
    
    NSMutableArray *displayName;
    NSMutableArray *searchLocation;
    NSMutableArray *ThumbnilURL;
    NSMutableArray *openNow;
    NSMutableArray *ratingArray;
    NSMutableArray *place_id;
    
    int currenDist;
}
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *buttonMenu;

- (IBAction)clear:(id)sender;
- (IBAction)bar:(id)sender;
- (IBAction)food:(id)sender;
- (IBAction)cafe:(id)sender;
- (IBAction)atm:(id)sender;
- (IBAction)parks:(id)sender;
- (IBAction)gas:(id)sender;
- (IBAction)shopping:(id)sender;
- (IBAction)parking:(id)sender;
- (IBAction)search:(id)sender;
@end

