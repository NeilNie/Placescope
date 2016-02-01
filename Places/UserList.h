//
//  UserList.h
//  Placescope
//
//  Created by Yongyang Nie on 1/9/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserList : RLMObject
@property NSString *name;
@property NSString *location;
@property NSString *type;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<UserList>
RLM_ARRAY_TYPE(UserList)
