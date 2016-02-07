//
//  UserInfo.h
//  Placescope
//
//  Created by Yongyang Nie on 2/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserInfo : RLMObject

@property NSString *username;
@property NSString *email;
@property NSString *language;
@property BOOL travelNotification;
@property BOOL newsteller;
@property BOOL dailyNotification;
@property BOOL coffee;
@property int id;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<UserInfo>
RLM_ARRAY_TYPE(UserInfo)
