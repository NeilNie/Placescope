//
//  Detail.h
//  Placescope
//
//  Created by Yongyang Nie on 1/9/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detail : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UIImage *photo;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UINavigationItem *Name;
@property NSString *LocationName;
@property NSString *Location;
@property NSString *LocationType;
@property NSString *photo_reference;

@end
