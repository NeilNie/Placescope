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
#import <Parse.h>
#import "MapPoint.h"
#import "TableViewCell.h"
#import "Reachability.h"
#import "Detail.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    
    NSMutableArray *searchResult;
    
    NSMutableArray *displayName;
    NSMutableArray *searchLocation;
    NSMutableArray *ThumbnilURL;
    NSMutableDictionary *photo_reference;
    
    int currenDist;
    BOOL firstLaunch;
    
    
}
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *buttonMenu;
@property (weak, nonatomic) IBOutlet UIButton *bar;
@property (weak, nonatomic) IBOutlet UIButton *food;
@property (weak, nonatomic) IBOutlet UIButton *cafe;
@property (weak, nonatomic) IBOutlet UIButton *atm;
@property (weak, nonatomic) IBOutlet UIButton *parks;
@property (weak, nonatomic) IBOutlet UIButton *gas;
@property (weak, nonatomic) IBOutlet UIButton *shopping;
@property (weak, nonatomic) IBOutlet UIButton *parking;
- (IBAction)bar:(id)sender;
- (IBAction)food:(id)sender;
- (IBAction)cafe:(id)sender;
- (IBAction)atm:(id)sender;
- (IBAction)parks:(id)sender;
- (IBAction)gas:(id)sender;
- (IBAction)shopping:(id)sender;
- (IBAction)parking:(id)sender;
@end

