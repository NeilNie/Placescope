//
//  Drink.m
//  Placescope
//
//  Created by Yongyang Nie on 2/7/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "Drink.h"
#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"

@interface Drink ()

@end

@implementation Drink

-(void)queryPlacesKeyword: (NSString *)keyword queryWithType: (NSString *)type1 secondType: (NSString *)typet thirdType: (NSString *)type3{
    
    NSLog(@"query started");
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
    NSString *myurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@|%@&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", 700], type1, typet, kGOOGLE_API_KEY];
    
    NSURL *searchURL = [NSURL URLWithString:[myurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL: searchURL];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:json waitUntilDone:YES];
    NSLog(@"%@", json);
}

- (void)fetchedData:(NSDictionary *)responseData{
    
    //parse out the json data for places
    NSMutableArray *result = [responseData objectForKey:@"results"];
    
    for (int i = 0 ; i < [result count]; i++) {
        
        NSDictionary *place = [result objectAtIndex:i];
        
        if ([[place objectForKey:@"rating"] floatValue] >= 4) {
            
            [name addObject:[place objectForKey:@"name"]];
            [address addObject:[place objectForKey:@"vicinity"]];
            [rating addObject:[place objectForKey:@"rating"]];
        }
    }
    
    //refresh table and display
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"reload table");
        [self setupTable];
    });
}

- (void)setupTable
{
    [self.Table setNumberOfRows:name.count withRowType:@"default"];
    
    NSInteger rowCount = self.Table.numberOfRows;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        NSString *nameString = name[i];
        NSString *locationString = address[i];
        NSString *ratingString = [NSString stringWithFormat:@"%@ Rating", rating[i]];
        
        Row *row = [self.Table rowControllerAtIndex:i];
        [row.placeName setText:nameString];
        [row.Address setText:locationString];
        [row.Rating setText:ratingString];
    }
    [self.Table setHidden:NO];
    [self.loading setHidden:YES];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if ([locations count] == 0) {
        
        return;
    }
    CLLocation *loc = [locations firstObject];
    currentCentre = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
    [self queryPlacesKeyword:nil queryWithType:@"cafe" secondType:@"bar" thirdType:nil];
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    
    NSLog(@"%@", error);
}
-(void)locationQuickUpdate{
    
    [locationManager requestAlwaysAuthorization];
    [locationManager requestLocation];
}

- (void)awakeWithContext:(id)context {
    
    name = [[NSMutableArray alloc] init];
    address = [[NSMutableArray alloc] init];
    rating = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [self locationQuickUpdate];
    
    [self.Table setHidden:YES];
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