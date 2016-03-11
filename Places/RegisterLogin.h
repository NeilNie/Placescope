//
//  RegisterLogin.h
//  
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <KinveyKit/KinveyKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserInfo.h"

@interface RegisterLogin : UIViewController{
    NSTimer *timer;
    FBSDKLoginManager *login;
}

//first page
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *paris;
@property (weak, nonatomic) IBOutlet UIImageView *swiss;
-(IBAction)stop:(id)sender;

//second
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FacebookLogin;

@end
