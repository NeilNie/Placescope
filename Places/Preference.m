//
//  Preference.m
//  Placescope
//
//  Created by Yongyang Nie on 1/5/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "Preference.h"
#import "Setting Cell.h"

#define kRemoveAdsProductIdentifier @"noads.placescope.com"
#define kAdMobAdUnitID @"ca-app-pub-7942613644553368/5543329138"

@interface Preference ()

@end

@implementation Preference

- (void)viewDidLoad {
    
    [super viewDidLoad];
    array = [[NSMutableArray alloc] initWithObjects:@"Travel notification", @"Email newsletter", @"Daily notification", @"No Ads (purchase this feature)", nil];
    
    self.Table.dataSource = self;
    self.Table.delegate = self;
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    if (areAdsRemoved == NO) {
        self.bannerView.delegate = self;
        self.bannerView.adUnitID = kAdMobAdUnitID;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];
    }
    
    objects = [UserInfo allObjects];
    NSLog(@"user info %@", objects);
    info = [[UserInfo alloc] init];
    info = [objects objectAtIndex:0];
    self.username.text = info.username;
    self.email.text = info.email;
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - in app purchase
- (IBAction)tapsRemoveAdsButton{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (IBAction)purchase:(SKProduct *)product{
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)restore1{
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    areAdsRemoved = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Ads Restored");
    
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if((SKPaymentTransactionState)transaction == SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased NoAds");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored NoAds");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                break;
        }
    }
}

- (void)doRemoveAds{
    
    areAdsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return [array count];
            break;
        case 1:
            return [array2 count];
            break;
            
        default:
            return [array count];
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellID";
    
    Setting_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"Setting Cell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    info = [objects objectAtIndex:0];
    cell.name.text = [array objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.Switch.on = info.travelNotification;
            break;
        case 1:
            cell.Switch.on = info.newsteller;
            break;
        case 2:
            cell.Switch.on = info.dailyNotification;
            break;
        case 3:
            cell.Switch.on = areAdsRemoved;
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    switch (indexPath.row) {
        case 0:
            if (info.travelNotification == YES) {
                [realm beginWriteTransaction];
                info.travelNotification = NO;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
                
            }else {
                [realm beginWriteTransaction];
                info.travelNotification = YES;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
            }
            
            break;
        case 1:
            if (info.newsteller == YES) {
                [realm beginWriteTransaction];
                info.newsteller = NO;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
                
            }else {
                [realm beginWriteTransaction];
                info.newsteller = YES;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
            }
            
            break;
        case 2:
            if (info.dailyNotification == YES) {
                [realm beginWriteTransaction];
                info.dailyNotification = NO;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
                
            }else {
                [realm beginWriteTransaction];
                info.dailyNotification = YES;;
                [realm addOrUpdateObject:info];
                [realm commitWriteTransaction];
            }
            break;
        case 3:
            if (areAdsRemoved == NO) {
                [self tapsRemoveAdsButton];
            }else{
                [self restore1];
            }
            break;
            
        default:
            break;
    }
    [self.Table reloadData];
    NSLog(@"user %@", info);
}

- (IBAction)changePass:(id)sender {
}

- (IBAction)changeEmail:(id)sender {
}

- (IBAction)changeName:(id)sender {
}
@end
