//
//  Row.h
//  Placescope
//
//  Created by Yongyang Nie on 1/28/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface Row : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *placeName;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Address;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Rating;

@end
