//
//  ViewController.m
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"

#define kGOOGLE_API_KEY @"AIzaSyDIAi5NwP8UOos1Os8OIY3qtMRYm3T2krQ"
#define kAdMobAdUnitID @"ca-app-pub-7942613644553368/5543329138"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface UIViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.015;
    mapRegion.span.longitudeDelta = 0.015;
    [self.mapView setRegion:mapRegion animated: YES];
    
    searchLocation = [NSMutableArray array];
    displayName = [NSMutableArray array];
    ThumbnilURL = [NSMutableArray array];
    openNow = [NSMutableArray array];
    ratingArray = [NSMutableArray array];
    place_id= [NSMutableArray array];
    
    if ([displayName count] == 0) {
        self.tableViewConstraint.constant = 0;
    }

    //gesture recognizers
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.buttonMenu addGestureRecognizer:swipeUp];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    if (areAdsRemoved == NO) {
        self.bannerView.delegate = self;
        self.bannerView.adUnitID = kAdMobAdUnitID;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonMenu.alpha = 0;
        [self.view layoutIfNeeded];
    }];
}
-(IBAction)showMenu:(id)sender{
    
    [self showAll];
}

#pragma mark - UIGestureRecognizer

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    [self.view layoutIfNeeded];
    [self.searchText resignFirstResponder];
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchButton.center = CGPointMake(self.searchButton.center.x, -35);
            self.searchText.center = CGPointMake(self.searchText.center.x, -35);
            self.buttonMenu.alpha = 0;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBarHidden = YES;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    MapPoint *annot = [[MapPoint alloc] initWithName:@"Your Pin" address:nil coordinate:touchMapCoordinate];
    [self.mapView addAnnotation:annot];
}

#pragma mark - queryGooglePlaces

-(void)queryPlacesWithKeyword: (NSString *)keyword queryPlacesWithType: (NSString *)googleType isOpen: (BOOL)openNow {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist - 200], googleType, kGOOGLE_API_KEY];
    NSLog(@"%@", url);
    
    //check reachablity
    if ([self connected] == YES) {

        //Formulate the string as URL object.
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        
        // Retrieve the results of the URL.
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        });
    }else{
        UIAlertController *messageAlert = [UIAlertController alertControllerWithTitle:@"Opps..." message:@"No internet connection. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:messageAlert animated:YES completion:nil];
    }
}

- (void)fetchedData:(NSData *)responseData {

    //parse out the json data
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //Add objects to arrays. The results from Google will be an array obtained from the NSDictionary object with the key "results".
    searchResult = [json objectForKey:@"results"];

    NSArray* ErrorMEssage = [json objectForKey:@"error_message"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", searchResult);
    NSLog(@"error %@", ErrorMEssage);
    
    if (searchResult.count > 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableViewConstraint.constant = 250;
            [self.view layoutIfNeeded];
        }];
        [self plotPositions:searchResult]; //plot positions
    }
}

- (void)plotPositions:(NSMutableArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in _mapView.annotations){
        
        if ([annotation isKindOfClass:[MapPoint class]]){
            
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i < [data count]; i++)
    {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary *place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        [displayName addObject:name];
        [searchLocation addObject:vicinity];
        [ThumbnilURL addObject:[place objectForKey:@"icon"]];
        [place_id addObject:[place objectForKey:@"place_id"]];
        
        if ([place objectForKey:@"rating"]) {
            [ratingArray addObject:[place objectForKey:@"rating"]];
        }else{
            [ratingArray addObject:@"0.0"];
        }
        NSDictionary *dictionary = [place objectForKey:@"opening_hours"];
        if ([dictionary objectForKey:@"open_now"]) {
            [openNow addObject:[dictionary objectForKey:@"open_now"]];
        }else{
            [openNow addObject:@"1"];
        }
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [_mapView addAnnotation:placeObject];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.TableView reloadData];
    });
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [searchLocation count];
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

    cell.thumbnailImageView.image = [UIImage imageNamed:@"menu-placeholder.png"];
    cell.locationName.text = [displayName objectAtIndex:indexPath.row];
    cell.Address.text = [searchLocation objectAtIndex:indexPath.row];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [ThumbnilURL objectAtIndex:indexPath.row]]];
    cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    cell.rating.text = [NSString stringWithFormat:@"%@", [ratingArray objectAtIndex:indexPath.row]];
    if ([[openNow objectAtIndex:indexPath.row] intValue] == 1) {
        cell.OpenNow.textColor = [UIColor colorWithRed:37.0f/255.0f green:183.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
        cell.OpenNow.text = @"Open Now";
    }else{
        cell.OpenNow.textColor = [UIColor redColor];
        cell.OpenNow.text = @"Closed Now";
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for(MapPoint* currentAnnotation in self.mapView.annotations)
    {
        if([currentAnnotation.title isEqualToString:[displayName objectAtIndex:indexPath.row]])
        {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta = 0.005;
            span.longitudeDelta = 0.005;
            region.span = span;
            region.center = currentAnnotation.coordinate;
            
            [self.mapView setRegion:region animated:YES];
            [self.mapView selectAnnotation:currentAnnotation animated:YES];
        }
    }
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    placeid = [place_id objectAtIndex:indexPath.row];
    
    for(MapPoint* currentAnnotation in self.mapView.annotations){
        if([currentAnnotation.title isEqualToString:[displayName objectAtIndex:indexPath.row]]){
            coordinate = currentAnnotation;
        }
    }
    
    [self performSelector:@selector(showAll) withObject:nil afterDelay:2];
    
    
    NSLog(@"place id %@", placeid);
}

-(void)showAll{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.searchButton.center = CGPointMake(self.searchButton.center.x, 37);
        self.searchText.center = CGPointMake(self.searchText.center.x, 37);
        self.buttonMenu.alpha = 1;
        self.navigationController.navigationBarHidden = NO;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - MKMapViewDelegate methods.

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 900, 900);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

#pragma mark - Private

- (IBAction)search:(id)sender {
    
    [self queryPlacesWithKeyword:self.searchText.text queryPlacesWithType:nil isOpen:YES];
    
}
- (IBAction)clear:(id)sender {
    
    [displayName removeAllObjects];;
    [searchLocation removeAllObjects];
    [ThumbnilURL removeAllObjects];
    [openNow removeAllObjects];
    [ratingArray removeAllObjects];
    [self.TableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableViewConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)bar:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"bar" isOpen:YES];
}
- (IBAction)food:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"food" isOpen:YES];
}
- (IBAction)cafe:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"cafe" isOpen:YES];
}
- (IBAction)atm:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"bank" isOpen:YES];
}
- (IBAction)parks:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"parks" isOpen:YES];
}
- (IBAction)gas:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"gas" isOpen:YES];
}
- (IBAction)shopping:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"shopping" isOpen:YES];
}
- (IBAction)parking:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"parking" isOpen:YES];
}
- (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
