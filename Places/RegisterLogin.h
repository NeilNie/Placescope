//
//  RegisterLogin.h
//  
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import <UIKit/UIKit.h>
//#import <Parse.h>
//#import <Realm/Realm.h>
#import "UserInfo.h"

@interface RegisterLogin : UIViewController{
    NSTimer *timer;
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

//third

@end
