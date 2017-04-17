//
//  TableViewCell.h
//  Placescope
//
//  Created by Yongyang Nie on 1/3/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestPointTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak) IBOutlet UILabel *Address;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@property (nonatomic, weak) IBOutlet UILabel *OpenNow;

@end
