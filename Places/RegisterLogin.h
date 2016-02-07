//
//  RegisterLogin.h
//  
//
//  Created by Yongyang Nie on 1/1/16.
//
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "UserInfo.h"
#import <KinveyKit/KinveyKit.h>

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
@property (weak, nonatomic) IBOutlet UISwitch *coffee;
@property (weak, nonatomic) IBOutlet UISwitch *travel;
@property (weak, nonatomic) IBOutlet UISwitch *daily;
@property (weak, nonatomic) IBOutlet UISwitch *newsteller;
@property (weak, nonatomic) IBOutlet UISegmentedControl *terms;

@end
