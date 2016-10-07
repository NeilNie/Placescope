//
//  InterfaceController.m
//  Placescope Apple Watch Extension
//
//  Created by Yongyang Nie on 1/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"HH"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] >= 7 && [string intValue] <= 11) {
        
        [self.label setText:@"Good morning!"];
        
    }else if ([string intValue] >= 12 && [string intValue] <= 17){
        
        [self.label setText:@"Welcome back!"];
        
    }else if ([string intValue] >= 18 && [string intValue] <= 21){
        
        [self.label setText:@"Good evening!"];
        
    }else{
        
        [self.label setText:@"Good evening!"];
        
    }
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



