//
//  Workflow.h
//  Placescope
//
//  Created by Yongyang Nie on 1/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TableViewCell.h"
#import "Reachability.h"
#import "WorkflowCell.h"
#import "Detail.h"
#import "Preference.h"

@import GoogleMobileAds;

@interface Workflow : UIViewController <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, GADBannerViewDelegate>{
    
    int ScreenSize;
    int priceLevel;
    NSString *favoriteType;
    BOOL liked;
    BOOL shared;
    
    NSMutableArray *results;
    
    CLLocationCoordinate2D currentCentre;
    CLLocationManager *locationManager;
    
    NSDateFormatter *dateformat;
}
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *sadFace;
@property (weak, nonatomic) IBOutlet UILabel *noResult;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *refresh;
@property (weak, nonatomic) IBOutlet UILabel *alertBody;
@property (weak, nonatomic) IBOutlet FBSDKLikeButton *like;
@property (weak, nonatomic) IBOutlet FBSDKShareButton *share;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeight;

- (IBAction)refresh:(id)sender;
- (IBAction)FacebookLike:(id)sender;
- (IBAction)FacebookShare:(id)sender;

@end
