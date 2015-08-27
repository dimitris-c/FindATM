//
//  ATMUserSettings.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/8/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATMUserSettings : NSObject

+ (NSUserDefaults *)userDefaults;

+ (void)saveDistance:(CGFloat)distance;
+ (CGFloat )getDistance;

+ (void)saveFavouritesBanks:(NSMutableArray *)banks;
+ (NSArray *)getFavouritesBanks;

+ (void)save;

@end
