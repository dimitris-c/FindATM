//
//  NetworkEngine.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

#import "GetNearestBanks.h"
#import "SubmitBank.h"

#ifdef DEBUG
    #define BASE_URL            @"http://www.vresatm.gr/app/api"
//    #define BASE_URL            @"http://www.vresatm.gr/staging-app/api"
#else
    #define BASE_URL            @"http://www.vresatm.gr/app/api"
#endif

#define Eng [NetworkEngine sharedInstance]


typedef enum : NSUInteger {
    EErrorCodeNoEntries = 0
} EErrorCode;

@interface NetworkEngine : AFHTTPRequestOperationManager

@property (nonatomic, strong, readonly) GetNearestBanks *getNearestBanks;
@property (nonatomic, strong, readonly) SubmitBank *submitBank;

+ (NetworkEngine *)sharedInstance;

- (void)getMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
