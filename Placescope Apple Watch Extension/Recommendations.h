//
//  Recommendations.h
//  
//
//  Created by Yongyang Nie on 1/28/16.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "Row.h"

NSMutableArray *name;
NSMutableArray *address;
NSMutableArray *rating;

@interface Recommendations : WKInterfaceController <CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *Table;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *loading;

@end
