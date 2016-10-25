//
//  Detail.m
//  Placescope
//
//  Created by Yongyang Nie on 1/9/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "DetailViewController.h"

#define kAdMobAdUnitID @"ca-app-pub-7942613644553368/5543329138"
#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 1:
            return @"reviews";
            break;
            
        default:
            return @"";
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return [reviews count];
            break;
            
        default:
            return 3;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 80;
            break;
        default:
            return 70;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellID"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCellID"];
        
    }
    UILabel *object = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *discription = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *rating = (UILabel *)[cell.contentView viewWithTag:3];
    switch (indexPath.section) {
        case 0:
            rating.hidden = YES;
            object.text = [array objectAtIndex:indexPath.row];
            discription.text = [NSString stringWithFormat:@"%@", [array2 objectAtIndex:indexPath.row]];
            break;
        case 1:
            rating.hidden = NO;
            object.text = [reviewer objectAtIndex:indexPath.row];
            discription.text = [NSString stringWithFormat:@"%@", [reviews objectAtIndex:indexPath.row]];
            rating.text = [NSString stringWithFormat:@"%@", [ratingArray objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }

    return cell;
}

- (IBAction)navigate:(id)sender {
    
    NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", currentCentre.latitude, currentCentre.longitude, coordinate.coordinate.latitude, coordinate.coordinate.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
- (IBAction)share:(id)sender{
    
}
- (IBAction)save:(id)sender{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    UserList *object = [[UserList alloc] init];
    object.name = [searchResult objectForKey:@"name"];
    object.location = [array2 objectAtIndex:0];
    object.type = [array2 objectAtIndex:1];
    [realm addObject:object];
    [realm commitWriteTransaction];
    NSLog(@"added object %@", object);
}

- (void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //Add objects to arrays. The results from Google will be an array obtained from the NSDictionary object with the key "results".
    searchResult = [json objectForKey:@"result"];
    
    //Write out the data to the console.
    NSLog(@"location detail %@", searchResult);

    //setup array
    array = [[NSMutableArray alloc] initWithObjects:@"Location",@"Type", @"Website", @"Rating", nil];
    array2 = [[NSMutableArray alloc] initWithObjects:
              [searchResult objectForKey:@"vicinity"],
              [[searchResult objectForKey:@"types"] objectAtIndex:0],
              [searchResult objectForKey:@"website"],
              [searchResult objectForKey:@"rating"], nil];
    
    //setup images
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[searchResult objectForKey:@"photos"]];
    if (arr.count > 0) {
        NSDictionary *dict = [arr objectAtIndex:0];
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=%@&key=%@", [dict objectForKey:@"photo_reference"], kGOOGLE_API_KEY];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
        self.image.image = [UIImage imageWithData:imageData];
    }else{
        self.image.image = [UIImage imageNamed:@"default-placeholder.png"];
    }
    
    //setup reviews
    NSArray *ar = [searchResult objectForKey:@"reviews"];
    NSLog(@"result %lu", (unsigned long)[ar count]);
    for (int i = 0; i < [ar count]; i++) {
        
        NSDictionary *dic = [ar objectAtIndex:i];
        NSLog(@"dictionary %@", dic);
        [reviewer addObject:[dic objectForKey:@"author_name"]];
        [reviews addObject:[dic objectForKey:@"text"]];
        [ratingArray addObject:[dic objectForKey:@"rating"]];
        
    }
    NSLog(@"reviews %@", reviews);
    self.naviBar.title = [searchResult objectForKey:@"name"];
    
    [self.table reloadData];
    self.table.alpha = 1.0f;
}


- (void)viewDidLoad {
    
    self.table.alpha = 0.0f;
    
    reviewer = [NSMutableArray array];
    reviews = [NSMutableArray array];
    ratingArray = [NSMutableArray array];
    
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@", placeid, kGOOGLE_API_KEY];
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    NSLog(@"%@", googleRequestURL);
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    currentCentre = [locationManager location].coordinate;
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    if (areAdsRemoved == NO) {
        self.banner.delegate = self;
        self.banner.adUnitID = kAdMobAdUnitID;
        self.banner.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [self.banner loadRequest:request];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
