//
//  Bank.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "Bank.h"
#import "LocationHandler.h"

@interface Bank ()

@property(nonatomic,assign,readwrite) NSInteger buid;
@property(nonatomic,assign,readwrite) CGFloat longtitude;
@property(nonatomic,assign,readwrite) CGFloat latitude;
@property(nonatomic,strong,readwrite) NSString *name;
@property(nonatomic,strong,readwrite) NSString *address;
@property(nonatomic,strong,readwrite) NSString *phone;
@property(nonatomic,assign,readwrite) EBankType bankType;
@property(nonatomic,assign,readwrite) EBankState bankState;
@property(nonatomic,assign,readwrite) NSInteger visitors;
@property(nonatomic,assign,readwrite) CLLocationCoordinate2D location;
@property(nonatomic,assign,readwrite) CGFloat distance;

@end

@implementation Bank

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    if(self) {
        self.buid = [[dict objectForKey:@"buid"] integerValue];
        self.longtitude = [[dict objectForKey:@"longitude"] floatValue];
        self.latitude = [[dict objectForKey:@"latitude"] floatValue];
        self.name = [dict objectForKey:@"name"];
        self.phone = [dict objectForKey:@"phone"];
        self.bankType = [[dict objectForKey:@"banktype"] integerValue];
        self.bankState = [[dict objectForKey:@"state"] integerValue];
        self.visitors = [[dict objectForKey:@"visitors"] integerValue];
        self.location = CLLocationCoordinate2DMake(self.latitude, self.longtitude);
        self.address = [dict objectForKey:@"address"];
        self.distance = [[dict objectForKey:@"distance"] floatValue];
    }
    return self;
}


+ (NSString *)getBankNameFromType:(EBankType)bankType {
    switch (bankType) {
        case EBankTypeAlpha:
        case EBankTypeCitybank:
            return NSLocalizedStringFromTable(@"bank.alphabank", @"Localization", nil);
            break;
        case EBankTypeAttica:
            return NSLocalizedStringFromTable(@"bank.atticabank", @"Localization", nil);
            break;
        case EBankTypeEurobank:
            return NSLocalizedStringFromTable(@"bank.eurobank", @"Localization", nil);
            break;
        case EBankTypeHsbc:
            return NSLocalizedStringFromTable(@"bank.hsbc", @"Localization", nil);
            break;
        case EBankTypeNationalBank:
            return NSLocalizedStringFromTable(@"bank.nationalbank", @"Localization", nil);
            break;

        case EBankTypePiraeusBank:
            return NSLocalizedStringFromTable(@"bank.piraeusbank", @"Localization", nil);
            break;
        case EBankTypePostbank:
            return NSLocalizedStringFromTable(@"bank.postbank", @"Localization", nil);
            break;
            
        default:
            break;
    }
    return @"";
}

+ (NSString *)getStateNameFromState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateMoneyNoTwenties:
            return NSLocalizedStringFromTable(@"bankstate.money", @"Localization", nil);
            break;
        case EbankStateMoneyAndTwenties:
            return NSLocalizedStringFromTable(@"bankstate.moneytwenties", @"Localization", nil);
            break;
        case EBankStateNoMoney:
            return NSLocalizedStringFromTable(@"bankstate.nomoney", @"Localization", nil);
            break;
        case EbankStateUknown:
            return NSLocalizedStringFromTable(@"No information", @"Localization", nil);
            break;
        default:
            return NSLocalizedStringFromTable(@"", @"Localization", nil);
            break;
    }
    return @"";
}


+ (UIColor *)getTextColorFromBankState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateUknown:
            return [UIColor colorWithRed:1.0 green:0.64 blue:0.0 alpha:1.0];
            break;
            
        case EbankStateMoneyAndTwenties:
        case EbankStateMoneyNoTwenties:
            return [UIColor colorWithRed:0.13 green:0.69 blue:0.04 alpha:1.0];
            break;
        case EBankStateNoMoney:
            return [UIColor colorWithRed:0.89 green:0.13 blue:0.07 alpha:1.0];
            break;
            
            
        default:
            break;
    }
    return [UIColor colorWithRed:1.0 green:0.64 blue:0.0 alpha:1.0];
}

+ (NSString *)getImageNameFromBankState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateUknown:
            return @"money-icon-noinfo";
            break;
            
        case EbankStateMoneyAndTwenties:
        case EbankStateMoneyNoTwenties:
            return @"money-icon-full";
            break;
            
        case EBankStateNoMoney:
            return @"money-icon-empty";
            break;
            
            
        default:
            break;
    }
    return @"money-icon-noinfo";
}

+ (UIImage *)getBankLogoFromBankType:(EBankType)bankType {
    // TODO: add logo specific image for current language.
    // TODO: Add a generic way to do the checking.
    NSString *currentLanguage = [Tk currentLanguage];
    
    switch (bankType) {
        case EBankTypeAlpha:
        case EBankTypeCitybank:
            return [UIImage imageNamed:@"alphabank"];
            break;
            
        case EBankTypeAttica:
            return [UIImage imageNamed:@"atticabank"];
            break;
            
        case EBankTypeEurobank:
            return [UIImage imageNamed:@"eurobank"];
            break;

        case EBankTypeHsbc:
            return [UIImage imageNamed:@"hsbc"];
            break;

        case EBankTypeNationalBank:
            return [UIImage imageNamed:@"nationalbank"];
            break;

        case EBankTypePostbank:
            return [UIImage imageNamed:@"tteurobank"];
            break;
        case EBankTypePiraeusBank: {
            NSString *imageName = [NSString stringWithFormat:@"piraeus-%@", currentLanguage];
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                return image;
            }
            return [UIImage imageNamed:@"piraeus"];
            break;
        }

        default:
            break;
    }
    return [UIImage imageNamed:@"atm-placeholder"];
}

+ (NSString *)getReadableStateFromBankState:(EBankState)bankState
{
    switch (bankState) {
        case EbankStateMoneyNoTwenties:
            return NSLocalizedStringFromTable(@"bankstate.money.readable", @"Localization", nil);
            break;
        case EbankStateMoneyAndTwenties:
            return NSLocalizedStringFromTable(@"bankstate.moneytwenties.readable", @"Localization", nil);
            break;
        case EBankStateNoMoney:
            return NSLocalizedStringFromTable(@"bankstate.nomoney.readable", @"Localization", nil);
            break;
        case EbankStateUknown:
            return NSLocalizedStringFromTable(@"No information", @"Localization", nil);
            break;
        default:
            return NSLocalizedStringFromTable(@"", @"Localization", nil);
            break;
    }
    return @"";

}


@end
