//
//  Workflow.m
//  Placescope
//
//  Created by Yongyang Nie on 1/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "Workflow.h"

#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface Workflow ()

@end

@implementation Workflow

#pragma mark - Table view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return nameArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIScreen mainScreen] bounds].size.width == 320) {
        
        return CGSizeMake(320, 180);
        
    }else if ([[UIScreen mainScreen] bounds].size.width == 375) {
        
        return CGSizeMake(375, 200);
        
    }else if ([[UIScreen mainScreen] bounds].size.width > 414){
        
        return CGSizeMake(414, 290);
        
    }else{
        
        return CGSizeMake(150, 150);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"WorkflowCell";
    
    WorkflowCell *cell = (WorkflowCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.Image.image = [UIImage imageNamed:@"default-placeholder.png"];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [ThumbnilURL objectAtIndex:indexPath.row]]];
    cell.Image.image = [UIImage imageWithData:imageData];
    cell.Name.text = [nameArray objectAtIndex:indexPath.row];
    cell.Address.text = [addressArray objectAtIndex:indexPath.row];
    cell.Rating.text = [NSString stringWithFormat:@"%@", [rating objectAtIndex:indexPath.row]];
    cell.Type.text = [NSString stringWithFormat:@"%@ • %@", [type objectAtIndex:indexPath.row], [type2 objectAtIndex:indexPath.row]];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark - Google Places

-(void)queryPlacesKeyword: (NSString *)keyword queryWithType: (NSString *)type1 secondType: (NSString *)typet thirdType: (NSString *)type3{
    
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
    NSString *myurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@|%@&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", 700], type1, typet, kGOOGLE_API_KEY];
    
    if ([self connected] == YES) {
        NSURL *searchURL = [NSURL URLWithString:[myurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfURL: searchURL];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        dispatch_async(kBgQueue, ^{
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:json waitUntilDone:YES];
            NSLog(@"%@", json);
        });
    }else{
        UIAlertView* MessageAlert = [[UIAlertView alloc] initWithTitle:@"Opps..." message:@"No internet connection. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [MessageAlert show];
    }
}

- (void)fetchedData:(NSDictionary *)responseData{
    
    //parse out the json data for places
    NSMutableArray *result = [responseData objectForKey:@"results"];
    
    for (int i = 0 ; i < [result count]; i++) {
        
        NSDictionary *place = [result objectAtIndex:i];
        
        if ([[place objectForKey:@"rating"] floatValue] >= 4) {
            
            [nameArray addObject:[place objectForKey:@"name"]];
            [addressArray addObject:[place objectForKey:@"vicinity"]];
            [rating addObject:[place objectForKey:@"rating"]];
            [type addObject:[[place objectForKey:@"types"] objectAtIndex:0]];
            [type2 addObject:[[place objectForKey:@"types"] objectAtIndex:1]];
            
            NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:[place objectForKey:@"photos"]];
            if (photos.count != 0) {
                NSDictionary *dic = [photos objectAtIndex:0];
                NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=%@&key=%@", [dic objectForKey:@"photo_reference"], kGOOGLE_API_KEY];
                [ThumbnilURL addObject:url];
            }
        }
    }
    
    //refresh table and display
    if (nameArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"reload table");
            [self.collectionView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                self.refresh.alpha = 0;
                self.noResult.alpha = 0;
                self.sadFace.alpha = 0;
                self.collectionView.alpha = 1;
            }];
        });
    }
}
- (BOOL)connected {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    currentCentre = [locationManager location].coordinate;
    
    nameArray = [[NSMutableArray alloc] init];
    addressArray = [[NSMutableArray alloc] init];
    ThumbnilURL = [[NSMutableArray alloc] init];
    rating = [[NSMutableArray alloc] init];
    type = [[NSMutableArray alloc] init];
    type2 = [[NSMutableArray alloc] init];
    
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
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    
    [dateformat setDateFormat:@"HH"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] >= 7 && [string intValue] <= 11) {
        
        [self queryPlacesKeyword:nil queryWithType:@"cafe" secondType:@"establishment" thirdType:nil];
        
    }else if ([string intValue] >= 12 && [string intValue] <= 17){
        
        [self queryPlacesKeyword:nil queryWithType:@"food" secondType:@"museum" thirdType:nil];
        
    }else if ([string intValue] >= 18 && [string intValue] <= 21){
        
        [self queryPlacesKeyword:nil queryWithType:@"food" secondType:@"restaurant" thirdType:nil];
        
    }else{
        
        [self queryPlacesKeyword:nil queryWithType:@"bar" secondType:@"restaurant" thirdType:nil];
    }
}

@end
