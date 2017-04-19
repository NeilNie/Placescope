//
//  RegisterLogin.h
//  
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AuthViewController : UIViewController <FBSDKLoginButtonDelegate>{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *paris;
@property (weak, nonatomic) IBOutlet UIImageView *swiss;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
