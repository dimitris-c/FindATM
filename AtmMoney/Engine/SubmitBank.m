//
//  SubmitBank.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "SubmitBank.h"

#define SUBMIT_BANK_URL @"submitBank"


@implementation SubmitBank

- (void)submitBankWithBankID:(NSInteger)bankID andBankState:(EBankState)bankState andBankQueue:(EBankQueue)bankQueue withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
    
    [Eng postMethod:SUBMIT_BANK_URL
         parameters:@{@"buid": @(bankID),@"state":@(bankState), @"queue": @(bankQueue)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                Log(@"JSON: %@", responseObject);
                if ([responseObject objectForKey:@"error"]) {
                    if (failure != nil)
                        failure();
                    return;
                }
                
                if (completion != nil)
                    completion();

                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                Log(@"Network Failure");
                if (failure != nil) {
                    failure();
                }
            }];
    
}

@end
