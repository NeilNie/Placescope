//
//  UserInfo.h
//  Places
//
//  Created by Yongyang Nie on 1/3/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

//#import <Realm/Realm.h>
#import <UIKit/UIKit.h>

@interface UserInfo : NSObject  //RLMObject

@property NSString *username;
@property NSString *language;
@property BOOL OpenNow;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<UserInfo>
//RLM_ARRAY_TYPE(UserInfo)
