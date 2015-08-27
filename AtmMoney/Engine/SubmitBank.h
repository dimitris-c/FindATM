//
//  SubmitBank.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"

@interface SubmitBank : NSObject

- (void)submitBankWithBankID:(NSInteger)bankID andBankState:(EBankState)bankState andBankQueue:(EBankQueue)bankQueue withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure;
@end
