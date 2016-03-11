//
//  Food.h
//  Placescope
//
//  Created by Yongyang Nie on 2/7/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "Row.h"

NSMutableArray *name;
NSMutableArray *address;
NSMutableArray *rating;

@interface Food : WKInterfaceController <CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *Table;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *loading;

@end
