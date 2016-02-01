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
#import <sys/sysctl.h>

int ScreenSize;

@interface Workflow : UIViewController <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    
    NSMutableArray *nameArray;
    NSMutableArray *addressArray;
    NSMutableArray *ThumbnilURL;
    NSMutableArray *tourName;
    NSMutableArray *tourLocation;
    NSMutableArray *tourThumbnilURL;
    
    CLLocationCoordinate2D currentCentre;
    CLLocationManager *locationManager;
    
    NSDateFormatter *dateformat;
}
@property (weak, nonatomic) IBOutlet UIImageView *sadFace;
@property (weak, nonatomic) IBOutlet UILabel *noResult;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *refresh;
- (IBAction)refresh:(id)sender;

@end
