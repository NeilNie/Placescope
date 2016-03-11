//
//  RegisterLogin.m
//  
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import "RegisterLogin.h"

@interface RegisterLogin ()

@end

@implementation RegisterLogin

- (void)viewDidLoad {
    
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(AnimateBackground) userInfo:nil repeats:YES];
    self.FacebookLogin.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             [self saveUserInfoName:result[@"name"] email:result[@"email"]];
             [self presentMainView];
             NSLog(@"saved user %@", result);
         }
     }];
    
    [super viewDidAppear:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.Email resignFirstResponder];
    [self.Name resignFirstResponder];
    [self.Password resignFirstResponder];
    
}

-(void)AnimateBackground{
    
    if (self.background.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.background.alpha = 0;
            self.paris.alpha = 1;
        }];
    }
    if (self.swiss.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.swiss.alpha = 0;
            self.background.alpha = 1;
        }];
    }
    if (self.paris.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.paris.alpha = 0;
            self.swiss.alpha = 1;
        } ];
    }
    
}
-(IBAction)stop:(id)sender{
    [timer invalidate];
    timer = nil;
}
-(IBAction)save1:(id)sender{
    
    [self saveUserInfoName:self.Name.text email:self.Email.text];

    [KCSUser userWithUsername:self.Name.text password:self.Password.text fieldsAndValues:@{KCSUserAttributeEmail: self.Email.text} withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (errorOrNil == nil) {
            [self presentMainView];
        } else {
            NSLog(@"%@", errorOrNil);
        }
    }];
}
-(IBAction)login:(id)sender{
    
    [KCSUser loginWithUsername:self.Email.text password:self.Password.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        
        [self saveUserInfoName:user.username email:user.email];
        
        if (errorOrNil ==  nil) {
            [self presentMainView];
        } else {
            //there was an error with the update save
            NSString* message = [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Sign account failed") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

-(void)presentMainView{
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)saveUserInfoName:(NSString *)name email:(NSString *)email{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    UserInfo *info = [[UserInfo alloc] init];
    info.id = 0;
    info.username = name;
    info.email = email;
    info.travelNotification = YES;
    info.newsteller = YES;
    info.coffee = YES;
    [realm addObject:info];
    [realm commitWriteTransaction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
