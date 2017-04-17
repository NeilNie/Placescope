//
//  CollectionViewCell.h
//  Placescope
//
//  Created by Yongyang Nie on 2/7/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *Type;
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *Rating;

@end
