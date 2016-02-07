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
    // Do any additional setup after loading the view.
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
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    UserInfo *info = [[UserInfo alloc] init];
    info.id = 0;
    info.username = self.Name.text;
    info.email = self.Email.text;
    info.travelNotification = YES;
    info.newsteller = YES;
    info.coffee = YES;
    [realm addObject:info];
    [realm commitWriteTransaction];
    [KCSUser userWithUsername:self.Name.text password:self.Password.text fieldsAndValues:@{KCSUserAttributeEmail: self.Email.text} withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (errorOrNil == nil) {
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [self presentViewController:vc animated:YES completion:nil];
            
        } else {
            NSLog(@"%@", errorOrNil);
        }
    }];
}
-(IBAction)login:(id)sender{
    
    [KCSUser loginWithUsername:self.Email.text password:self.Password.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        UserInfo *info = [[UserInfo alloc] init];
        info.id = 0;
        info.username = user.username;
        info.email = user.email;
        info.travelNotification = YES;
        info.newsteller = YES;
        info.coffee = YES;
        [realm addObject:info];
        [realm commitWriteTransaction];
        if (errorOrNil ==  nil) {
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            //there was an error with the update save
            NSString* message = [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Sign account failed") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
