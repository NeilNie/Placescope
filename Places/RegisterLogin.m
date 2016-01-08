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

/*-(void)AnimateBackground{
    
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
    
    PFUser *user = [PFUser user];
    user.username = self.Name.text;
    user.password = self.Password.text;
    user.email = self.Email.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"new user added, yeah!");
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *StartView = [MainStoryBoard instantiateViewControllerWithIdentifier:@"second"];
            [self presentViewController:StartView animated:YES completion:nil];
        }else{
            UIAlertView* MessageAlert = [[UIAlertView alloc] initWithTitle:@"Opps!?..?" message:[NSString stringWithFormat:@"Can't sign up, error %@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [MessageAlert show];
        }
    }];
}
-(IBAction)save2:(id)sender{
    
    UserInfo *info = [[UserInfo alloc] init];
    info.username = [PFUser currentUser].username;
    info.language = [[NSLocale preferredLanguages] objectAtIndex:0];
    info.OpenNow = YES;
    
}
-(IBAction)save3:(id)sender{
    
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
