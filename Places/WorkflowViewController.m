//
//  Workflow.m
//  Placescope
//
//  Created by Yongyang Nie on 1/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//
#import "WorkflowViewController.h"

#define kAdMobAdUnitID @"ca-app-pub-7942613644553368/5543329138"
#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface WorkflowViewController ()

@end

@implementation WorkflowViewController

#pragma mark - Table view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return results.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIScreen mainScreen] bounds].size.width == 320) {
        
        return CGSizeMake(320, 180);
        
    }else if ([[UIScreen mainScreen] bounds].size.width == 375) {
        
        return CGSizeMake(375, 200);
        
    }else if ([[UIScreen mainScreen] bounds].size.width == 414){
        
        return CGSizeMake(414, 290);
        
    }else{
        
        return CGSizeMake(375, 200);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"WorkflowCell";
    
    WorkflowCell *cell = (WorkflowCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.Image.image = [UIImage imageNamed:@"default-placeholder.png"];
    
    NSDictionary *place = [results objectAtIndex:indexPath.row];
    NSMutableArray *photos = [place objectForKey:@"photos"];
    NSString *url;
    if (photos.count != 0) {
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=%@&key=%@", [[photos objectAtIndex:0] objectForKey:@"photo_reference"], kGOOGLE_API_KEY];
    }
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
    cell.Image.image = [UIImage imageWithData:imageData];
    cell.Name.text = [place objectForKey:@"name"];
    cell.Address.text = [place objectForKey:@"vicinity"];
    cell.Rating.text = [NSString stringWithFormat:@"%@", [place objectForKey:@"rating"]];
    cell.Type.text = [NSString stringWithFormat:@"%@ • %@", [[place objectForKey:@"types"] objectAtIndex:0], [[place objectForKey:@"types"] objectAtIndex:1]];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    placeid = [[results objectAtIndex:indexPath.row] objectForKey:@"place_id"];
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
            
            [results addObject:place];
        }
    }
    
    //refresh table and display
    if (results.count > 0) {
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

- (IBAction)refresh:(id)sender {
    
    [self getPlaces];
}

- (IBAction)FacebookLike:(id)sender {
    
    liked = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alertHeight.constant = 0;
        self.alertBody.hidden = YES;
        self.like.alpha = 0.0;
        self.share.alpha = 0.0;
        [self.view layoutIfNeeded];
        
    }];
}

- (IBAction)FacebookShare:(id)sender {
    
    shared = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alertHeight.constant = 0;
        self.alertBody.hidden = YES;
        self.like.alpha = 0.0;
        self.share.alpha = 0.0;
        [self.view layoutIfNeeded];
        
    }];
}

-(void)configureFacebookView{
    
    if (liked == NO || shared == NO) {
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/Placescope-1264092500272944/"];
        content.contentTitle = @"Placescope";
        content.contentDescription = @"Finds the best places for you no matter where you go! Donwload Placescope on the App Store today for FREE!";
        content.imageURL = [NSURL URLWithString:@"string"];
        self.share.shareContent = content;
        
        self.like.objectID = @"https://www.facebook.com/Placescope-1264092500272944/";
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5 animations:^{
            
            self.alertHeight.constant = 115;
            self.alertBody.hidden = NO;
            self.like.alpha = 1;
            self.share.alpha = 1;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    if (areAdsRemoved == NO) {
        self.bannerView.delegate = self;
        self.bannerView.adUnitID = kAdMobAdUnitID;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];
    }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    currentCentre = [locationManager location].coordinate;
    
    results = [[NSMutableArray alloc] init];
    
    self.alertBody.hidden = YES;
    self.like.alpha = 0;
    self.share.alpha = 0;
    self.alertHeight.constant = 0;
    
    [self performSelector:@selector(getPlaces) withObject:nil afterDelay:1];
    [self performSelector:@selector(configureFacebookView) withObject:nil afterDelay:1];

}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
