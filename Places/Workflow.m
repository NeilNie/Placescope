//
//  Workflow.m
//  Placescope
//
//  Created by Yongyang Nie on 1/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "Workflow.h"
#import "TableViewCell.h"
#import "Reachability.h"

#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface Workflow ()

@end

@implementation Workflow

#pragma mark - Table view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *locationImage = (UIImageView *)[cell viewWithTag:1];
    UILabel *locationName = (UILabel *)[cell viewWithTag:2];
    UILabel *locationAddress = (UILabel *)[cell viewWithTag:3];
    
    locationImage.image = [UIImage imageNamed:@"default-placeholder.png"];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [ThumbnilURL objectAtIndex:indexPath.row]]];
    locationImage.image = [UIImage imageWithData:imageData];
    locationName.text = [nameArray objectAtIndex:indexPath.row];
    locationAddress.text = [addressArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Google Places

-(void)queryPlacesWithKeyword: (NSString *)keyword queryPlacesWithType: (NSString *)googleType{
    
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", 700], googleType, kGOOGLE_API_KEY];
    
    //check reachablity
    if ([self connected] == YES) {
        
        //Formulate the string as URL object.
        NSURL *googleRequestURL = [NSURL URLWithString:url];
        
        //get JSON data and put it into a dictionary
        NSData *data = [NSData dataWithContentsOfURL: googleRequestURL];
        
        NSError* error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        dispatch_async(kBgQueue, ^{

            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:json waitUntilDone:YES];
            NSLog(@"%@", json);
        });
    }else{
        NSLog(@"Not reacheable, no result displayed");
    }
}

- (void)fetchedData:(NSDictionary *)responseData{
    
    //parse out the json data for places
    NSMutableArray *result = [responseData objectForKey:@"results"];
    
    for (int i = 0 ; i < [result count]; i++) {
        
        NSDictionary *place = [result objectAtIndex:i];
        
        if ([[place objectForKey:@"rating"] floatValue] >= 4.2) {
            
            [nameArray addObject:[place objectForKey:@"name"]];
            [addressArray addObject:[place objectForKey:@"vicinity"]];
            
            NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:[place objectForKey:@"photos"]];
            if (photos.count != 0) {
                NSDictionary *dic = [photos objectAtIndex:0];
                NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=2000&photoreference=%@&key=%@", [dic objectForKey:@"photo_reference"], kGOOGLE_API_KEY];
                [ThumbnilURL addObject:url];
            }
        }
    }
    NSLog(@"result %@", ThumbnilURL);
    
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
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alpha = 0;
    
    dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"HH"];
    NSString *string = [dateformat stringFromDate:[NSDate date]];
    if ([string intValue] >= 7 && [string intValue] <= 11) {
        
        [self queryPlacesWithKeyword:nil queryPlacesWithType:@"breakfast"];
        
    }else if ([string intValue] >= 12 && [string intValue] <= 17){
        
        [self queryPlacesWithKeyword:nil queryPlacesWithType:@"lunch"];
        
    }else if ([string intValue] >= 18 && [string intValue] <= 21){
        
        [self queryPlacesWithKeyword:nil queryPlacesWithType:@"dinner"];
        
    }else{
        
        [self queryPlacesWithKeyword:nil queryPlacesWithType:@"night"];
    }
    
    size_t size;
    sysctlbyname("hw.mfachine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    NSLog(@"iPhone Device %i",[self platformType:platform]);
    ScreenSize = [self platformType:platform];
    free(machine);
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
        
        [self queryPlacesWithKeyword:@"breakfast" queryPlacesWithType:@"breakfast"];
        
    }else if ([string intValue] >= 12 && [string intValue] <= 17){
        
        [self queryPlacesWithKeyword:@"tea" queryPlacesWithType:@"tea"];
        
    }else if ([string intValue] >= 18 && [string intValue] <= 21){
        
        [self queryPlacesWithKeyword:@"dinner" queryPlacesWithType:@"dinner"];
        
    }else{
        
        [self queryPlacesWithKeyword:@"night" queryPlacesWithType:@"night"];
    }
}

- (int)platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone4,1"])    return 550;
    if ([platform isEqualToString:@"iPhone5,1"])    return 670;
    if ([platform isEqualToString:@"iPhone5,2"])    return 670;
    if ([platform isEqualToString:@"iPhone5,3"])    return 670;
    if ([platform isEqualToString:@"iPhone5,4"])    return 670;
    if ([platform isEqualToString:@"iPhone6,1"])    return 670;
    if ([platform isEqualToString:@"iPhone6,2"])    return 670;
    if ([platform isEqualToString:@"iPhone7,2"])    return 700;
    if ([platform isEqualToString:@"iPhone7,1"])    return 720;
    if ([platform isEqualToString:@"iPod4,1"])      return 630;
    if ([platform isEqualToString:@"iPod5,1"])      return 630;
    if ([platform isEqualToString:@"iPad2,1"])      return 850;
    if ([platform isEqualToString:@"iPad2,2"])      return 850;
    if ([platform isEqualToString:@"iPad2,3"])      return 850;
    if ([platform isEqualToString:@"iPad2,4"])      return 850;
    if ([platform isEqualToString:@"iPad2,5"])      return 850;
    if ([platform isEqualToString:@"iPad2,6"])      return 850;
    if ([platform isEqualToString:@"iPad2,7"])      return 850;
    if ([platform isEqualToString:@"iPad3,1"])      return 850;
    if ([platform isEqualToString:@"iPad3,2"])      return 850;
    if ([platform isEqualToString:@"iPad3,3"])      return 850;
    if ([platform isEqualToString:@"iPad3,4"])      return 850;
    if ([platform isEqualToString:@"iPad3,5"])      return 850;
    if ([platform isEqualToString:@"iPad3,6"])      return 850;
    if ([platform isEqualToString:@"iPad4,1"])      return 850;
    if ([platform isEqualToString:@"iPad4,2"])      return 850;
    if ([platform isEqualToString:@"iPad4,3"])      return 850;
    if ([platform isEqualToString:@"iPad4,4"])      return 850;
    if ([platform isEqualToString:@"iPad4,5"])      return 850;
    if ([platform isEqualToString:@"iPad4,6"])      return 850;
    if ([platform isEqualToString:@"iPad4,7"])      return 850;
    if ([platform isEqualToString:@"iPad4,8"])      return 850;
    if ([platform isEqualToString:@"iPad4,9"])      return 850;
    if ([platform isEqualToString:@"iPad5,3"])      return 850;
    if ([platform isEqualToString:@"iPad5,4"])      return 850;
    if ([platform isEqualToString:@"i386"])         return 630;
    if ([platform isEqualToString:@"x86_64"])       return 690;
    
    return 700;
}


@end
