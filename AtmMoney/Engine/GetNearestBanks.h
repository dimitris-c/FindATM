//
//  GetNearestBanks.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkEngine.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^VoidBlock)(void);

@interface GetNearestBanks : NSObject

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *banksData;
@property (nonatomic, strong) NSMutableArray *bankHistoryData;

@property (nonatomic, strong) NSMutableArray *selectedBanksToFilter;

- (void)getNearestBanksWithLocation:(CLLocation *)location andDistance:(CGFloat)distance withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure andNoEntriesFailure:(VoidBlock)noEntriesFailure;

- (void)getBankHistoryWithId:(NSInteger)buid withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure;

@end
