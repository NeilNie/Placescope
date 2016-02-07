//
//  UserInfo.m
//  Placescope
//
//  Created by Yongyang Nie on 2/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSString *)primaryKey {
    return @"id";
}
// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
