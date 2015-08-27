//
//  ATMBankTableViewCell.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bank.h"

@interface ATMBankTableViewCell : UITableViewCell

- (void)updateWithBank:(Bank *)bank;

@end
