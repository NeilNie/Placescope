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
}

-(void)viewDidAppear:(BOOL)animated{
    
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

}
-(IBAction)login:(id)sender{
    
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
