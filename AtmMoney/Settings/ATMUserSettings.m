//
//  ATMUserSettings.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/8/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "ATMUserSettings.h"

#define USER_DISTANCE_KEY   @"userDistance"
#define FAVOURITES_BANK_KEY @"favouritesBank"

@implementation ATMUserSettings

+ (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (void)saveDistance:(CGFloat)distance {
    [[[self class] userDefaults] setFloat:distance forKey:USER_DISTANCE_KEY];
    [[self class] save];
}

+ (CGFloat )getDistance {
    return [[[self class] userDefaults] floatForKey:USER_DISTANCE_KEY];
}

+ (void)saveFavouritesBanks:(NSMutableArray *)banks {
    [[[self class] userDefaults] setObject:banks forKey:FAVOURITES_BANK_KEY];
    [[self class] save];
}

+ (NSArray *)getFavouritesBanks {
    return (NSArray *)[[[self class] userDefaults] objectForKey:FAVOURITES_BANK_KEY];
}


+ (void)save {
    [[[self class] userDefaults] synchronize];
}

@end
