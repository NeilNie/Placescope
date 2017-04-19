//
//  RegisterLogin.m
//
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

#pragma mark - FaceBook Login

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (error == nil) {
        FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(AnimateBackground) userInfo:nil repeats:YES];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.email resignFirstResponder];
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    
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

-(IBAction)registerUser:(id)sender{
    
    [[FIRAuth auth] createUserWithEmail:self.email.text password:self.password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self showErrorAlert:error];
        }else{
            [self presentMainView];
        }
    }];
}

-(IBAction)login:(id)sender{
    
    [[FIRAuth auth] signInWithEmail:self.email.text password:self.password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self showErrorAlert:error];
        }else{
            [self presentMainView];
        }
    }];
    
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showErrorAlert:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps, something went wrong" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)presentMainView{
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
