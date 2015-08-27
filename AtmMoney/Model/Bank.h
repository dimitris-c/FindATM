//
//  Bank.h
//  AtmMoney
//
//  Created by Harris Spentzas on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum : NSUInteger {
    EbankStateUknown = 0,
    EbankStateMoneyAndTwenties,
    EbankStateMoneyNoTwenties,
    EBankStateNoMoney
} EBankState;

typedef enum : NSUInteger {
    EBankQueueUnknown = 0,
    EBankQueueNoQueue = 1,
    EBankQueueSmallQueue = 2,
    EBankQueueMediumQueue = 3,
    EBankQueueLargeQueue = 4
} EBankQueue;

typedef enum : NSUInteger {
    EBankTypePiraeusBank = 0,
    EBankTypeAttica = 1,
    EBankTypeEurobank = 2,
    EBankTypeAlpha = 3,
    EBankTypeCitybank = 4,
    EBankTypePostbank = 5,
    EBankTypeHsbc = 6,
    EBankTypeNationalBank = 7
} EBankType;

#define TOTAL_BANKS 8

@interface Bank : NSObject

@property(nonatomic,assign,readonly) NSInteger buid;
@property(nonatomic,assign,readonly) CGFloat longtitude;
@property(nonatomic,assign,readonly) CGFloat latitude;
@property(nonatomic,strong,readonly) NSString *address;
@property(nonatomic,strong,readonly) NSString *name;
@property(nonatomic,strong,readonly) NSString *phone;
@property(nonatomic,assign,readonly) CGFloat distance;
@property(nonatomic,assign,readonly) EBankType bankType;
@property(nonatomic,assign,readonly) EBankState bankState;
@property(nonatomic,assign,readonly) NSInteger visitors;
@property(nonatomic,assign,readonly) CLLocationCoordinate2D location;
@property(nonatomic,assign,readonly) CGFloat actualDistance;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSString *)getBankNameFromType:(EBankType)bankType;

+ (NSString *)getStateNameFromState:(EBankState)bankState;

+ (UIColor *)getTextColorFromBankState:(EBankState)bankState;

+ (NSString *)getImageNameFromBankState:(EBankState)bankState;

+ (NSString *)getReadableStateFromBankState:(EBankState)bankState;

+ (UIImage *)getBankLogoFromBankType:(EBankType)bankType;

@end
