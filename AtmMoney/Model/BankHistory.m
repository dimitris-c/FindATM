//
//  Bank.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "BankHistory.h"
#import "Toolkit.h"

@interface BankHistory ()

@property(nonatomic,assign,readwrite) EBankState bankState;
@property(nonatomic,strong,readwrite) NSDate *time;
@property(nonatomic,strong,readwrite) NSString   *comment;

@end

@implementation BankHistory {

    
}

- (instancetype)initWithDict:(NSDictionary *)dict {

    
    self = [super init];
    if(self) {
        self.bankState = [[dict objectForKey:@"state"] integerValue];
        
        Tk.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        Tk.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Europe/London"];
        self.time = [Tk.dateFormatter dateFromString:[dict objectForKey:@"time"]];
        
        Tk.dateFormatter.timeZone = [NSTimeZone localTimeZone];
        NSString *convertedDate = [Tk.dateFormatter stringFromDate:self.time];
        
        self.time = [Tk.dateFormatter dateFromString:convertedDate];
        self.comment = [dict objectForKey:@"comment"];

    }
    return self;
}

- (NSString *)getBankNameFromType:(EBankType)bankType {
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

- (NSString *)getStateNameFromState:(EBankState)bankState {
    switch (bankState) {
        case EbankStateUknown:
            return NSLocalizedStringFromTable(@"bankstate.money", @"Localization", nil);
            break;
            
        case EbankStateMoneyAndTwenties:
            return NSLocalizedStringFromTable(@"bankstate.moneytwenties", @"Localization", nil);
            break;

        case EBankStateNoMoney:
            return NSLocalizedStringFromTable(@"bankstate.nomoney", @"Localization", nil);
            break;

        default:
            return NSLocalizedStringFromTable(@"bankstate.money", @"Localization", nil);
            break;
    }
    return @"";
}

@end
