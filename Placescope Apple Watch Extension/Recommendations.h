//
//  Recommendations.h
//  
//
//  Created by Yongyang Nie on 1/28/16.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "Row.h"

NSMutableArray *name;
NSMutableArray *address;
NSMutableArray *rating;

@interface Recommendations : WKInterfaceController <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *Table;

@end
