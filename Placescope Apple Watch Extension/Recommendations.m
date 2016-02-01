//
//  Recommendations.m
//  
//
//  Created by Yongyang Nie on 1/28/16.
//
//

#import "Recommendations.h"

@interface Recommendations ()

@end

@implementation Recommendations

#pragma WCsession Delegates

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    
    NSLog(@"received %@", message);
    
    if ([[message objectForKey:@"reply"] isEqualToString:@"yes"]) {
        NSLog(@"got data");
        name = [message objectForKey:@"name"];
        address = [message objectForKey:@"address"];
        rating = [message objectForKey:@"rating"];
        [self setupTable];
    }
}
- (void)setupTable
{
    
    [self.Table setNumberOfRows:name.count withRowType:@"default"];
    
    NSInteger rowCount = self.Table.numberOfRows;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        NSString *nameString = name[i];
        NSString *locationString = address[i];
        NSString *ratingString = rating[i];
        
        Row *row = [self.Table rowControllerAtIndex:i];
        [row.placeName setText:nameString];
        [row.Address setText:locationString];
        [row.Rating setText:ratingString];
    }
    
}


- (void)awakeWithContext:(id)context {
    
    if ([WCSession isSupported]) {
        NSLog(@"Activated");
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
        [[WCSession defaultSession] sendMessage:@{@"key": @"rec"}
                                   replyHandler:^(NSDictionary *reply) {
                                       //handle reply from iPhone app here
                                   }
                                   errorHandler:^(NSError *error) {
                                       NSLog(@"error %@", error);
                                   }
         ];
        
    }else{
        NSLog(@"not supported");
    }
    
    name = [[NSMutableArray alloc] init];
    address = [[NSMutableArray alloc] init];
    rating = [[NSMutableArray alloc] init];
    
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



