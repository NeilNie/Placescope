//
//  TodayViewController.m
//  Placescope Widget
//
//  Created by Yongyang Nie on 3/31/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#define kAdMobAdUnitID @"ca-app-pub-7942613644553368/5543329138"
#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [results count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InterestPointTableViewCell *cell = (InterestPointTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cellid" forIndexPath:indexPath];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cellid"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cellid"];
    }
    
    //data source
    NSDictionary *place = [results objectAtIndex:indexPath.row];
    NSMutableArray *photos = [place objectForKey:@"photos"];
    NSString *url;
    if (photos.count != 0) {
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=%@&key=%@", [[photos objectAtIndex:0] objectForKey:@"photo_reference"], kGOOGLE_API_KEY];
    }
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
    
    //TabelView Cell
    cell.thumbnailImageView.image = [UIImage imageNamed:@"menu-placeholder.png"];
    cell.locationName.text = [place objectForKey:@"name"];
    cell.Address.text = [place objectForKey:@"vicinity"];
    cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    cell.rating.text = [NSString stringWithFormat:@"%@", [place objectForKey:@"rating"]];
    cell.OpenNow.hidden = YES;
    
    return cell;
}


#pragma mark - Google Places

-(void)queryPlacesKeyword: (NSString *)keyword queryWithType: (NSString *)type1 secondType: (NSString *)typet thirdType: (NSString *)type3{
    
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
    NSString *myurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@|%@&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", 700], type1, typet, kGOOGLE_API_KEY];
    
    NSURL *searchURL = [NSURL URLWithString:[myurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL: searchURL];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    dispatch_async(kBgQueue, ^{
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:json waitUntilDone:YES];
        NSLog(@"%@", json);
    });
}

- (void)fetchedData:(NSDictionary *)responseData{
    
    //parse out the json data for places
    NSMutableArray *result = [responseData objectForKey:@"results"];
    
    for (int i = 0 ; i < [result count]; i++) {
        
        NSDictionary *place = [result objectAtIndex:i];
        
        if ([[place objectForKey:@"rating"] floatValue] >= 4) {
            
            [results addObject:place];
        }
    }
    
    //refresh table and display
    if (results.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"reload table");
            [self.collectionView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                self.noResult.alpha = 0;
                self.sadFace.alpha = 0;
                self.collectionView.alpha = 1;
            }];
        });
    }
}

-(void)getPlaces{
    
    dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"HH"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] >= 7 && [string intValue] <= 11) {
        
        [self queryPlacesKeyword:nil queryWithType:@"cafe" secondType:@"establishment" thirdType:nil];
        
    }else if ([string intValue] >= 12 && [string intValue] <= 17){
        
        [self queryPlacesKeyword:nil queryWithType:@"food" secondType:@"establishment" thirdType:nil];
        
    }else if ([string intValue] >= 18 && [string intValue] <= 21){
        
        [self queryPlacesKeyword:nil queryWithType:@"food" secondType:@"restaurant" thirdType:nil];
        
    }else{
        
        [self queryPlacesKeyword:nil queryWithType:@"bar" secondType:@"restaurant" thirdType:nil];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    currentCentre = [locationManager location].coordinate;
    
    results = [[NSMutableArray alloc] init];
    
    [self getPlaces];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
