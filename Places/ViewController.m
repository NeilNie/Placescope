//
//  ViewController.m
//  Places
//
//  Created by Yongyang Nie on 12/28/15.
//  Copyright © 2015 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"

#define kGOOGLE_API_KEY @"AIzaSyArw7ygFfOtMGDI7KpupWHWwLvDDR0-fyA"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface UIViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.mapView.delegate = self;
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    
    searchResult = [[NSMutableArray alloc] init];
    searchLocation = [[NSMutableArray alloc] init];
    displayName = [[NSMutableArray alloc] init];
    ThumbnilURL = [[NSMutableArray alloc] init];
    photo_reference = [[NSMutableDictionary alloc] init];
    
    if ([searchResult count] == 0) {
        self.tableViewConstraint.constant = 0;
        NSLog(@"TableConstrained");
    }
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestAlwaysAuthorization];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.buttonMenu addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.buttonMenu addGestureRecognizer:swipeDown];

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.015;
    mapRegion.span.longitudeDelta = 0.015;
    [self.mapView setRegion:mapRegion animated: YES];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
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
        self.buttonMenu.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    NSLog(@"Textfield Did begin editing");
}
-(IBAction)showMenu:(id)sender{
    
    self.searchText.hidden = NO;
    self.searchButton.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchButton.center = CGPointMake(self.searchButton.center.x, 37);
        self.searchText.center = CGPointMake(self.searchText.center.x, 37);
        self.buttonMenu.alpha = 1;
        self.navigationController.navigationBarHidden = NO;
        [self.view layoutIfNeeded];
    }];
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
            self.searchText.hidden = YES;
            self.searchButton.hidden = YES;
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

-(void)queryPlacesWithKeyword: (NSString *)keyword queryPlacesWithType: (NSString *)googleType defaultLanguage: (NSString *)language isOpen: (BOOL)openNow {
    
    //Resource: https://developers.google.com/maps/documentation/places/#Authentication
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
        NSLog(@"Not reacheable, no result displayed");
    }
}

- (void)fetchedData:(NSData *)responseData {
    
    if (displayName.count > 1) {
        [photo_reference removeAllObjects];
        [displayName removeAllObjects];
        [searchLocation removeAllObjects];
        [ThumbnilURL removeAllObjects];
        NSLog(@"cleared table for new data");
    }
    //parse out the json data
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //Add objects to arrays. The results from Google will be an array obtained from the NSDictionary object with the key "results".
    searchResult = [json objectForKey:@"results"];

    NSArray* ErrorMEssage = [json objectForKey:@"error_message"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", searchResult);
    NSLog(@"error %@", ErrorMEssage);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:searchResult];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableViewConstraint.constant = 250;
    }];
}

- (void)plotPositions:(NSMutableArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in _mapView.annotations){
        
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    NSLog(@"began");
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary *place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        //retrieve photo preference number
        NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:[place objectForKey:@"photos"]];
        if (photos.count != 0) {
            NSDictionary *dic = [photos objectAtIndex:0];
            [photo_reference setObject:[dic objectForKey:@"photo_reference"] forKey:[place objectForKey:@"name"]];
        }
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        NSLog(name, vicinity);
        [displayName addObject:name];
        [searchLocation addObject:vicinity];
        [ThumbnilURL addObject:[place objectForKey:@"icon"]];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        [_mapView addAnnotation:placeObject];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.TableView reloadData];
    });
    NSLog(@"ended");
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [searchLocation count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cellid" forIndexPath:indexPath];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cellid"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cellid"];
        
    }

    cell.thumbnailImageView.image = [UIImage imageNamed:@"menu-placeholder.png"];
    cell.locationName.text = [displayName objectAtIndex:indexPath.row];
    cell.Address.text = [searchLocation objectAtIndex:indexPath.row];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [ThumbnilURL objectAtIndex:indexPath.row]]];
    cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueID"]) {
        NSIndexPath *indexPath = [self.TableView indexPathForSelectedRow];
        Detail *viewController = segue.destinationViewController;
        viewController.LocationName = [displayName objectAtIndex:indexPath.row];
        viewController.Location = [searchLocation objectAtIndex:indexPath.row];
        viewController.photo_reference = [photo_reference objectForKey:[displayName objectAtIndex:indexPath.row]];
    }
}

#pragma mark - MKMapViewDelegate methods.

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

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
    NSLog(@"%@", [NSString stringWithFormat:@"%d", currenDist]);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

#pragma mark - other methods
- (IBAction)search:(id)sender {
}
- (IBAction)bar:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"bar" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)food:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"food" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)cafe:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"cafe" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)atm:(id)sender {
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"bank" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)parks:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"parks" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)gas:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"gas" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)shopping:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"shopping" defaultLanguage:@"english" isOpen:YES];
}
- (IBAction)parking:(id)sender{
    [self queryPlacesWithKeyword:nil queryPlacesWithType:@"parking" defaultLanguage:@"english" isOpen:YES];
}
- (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
@end
