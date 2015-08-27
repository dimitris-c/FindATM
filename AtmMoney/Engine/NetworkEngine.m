//
//  NetworkEngine.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Find ATM. All rights reserved.
//

#import "NetworkEngine.h"

@interface NetworkEngine ()
@property (nonatomic, strong, readwrite) GetNearestBanks *getNearestBanks;
@property (nonatomic, strong, readwrite) SubmitBank *submitBank;
@end

@implementation NetworkEngine

@synthesize getNearestBanks = _getNearestBanks;
@synthesize submitBank      = _submitBank;

+ (NetworkEngine *)sharedInstance {
    static NetworkEngine *_sharedClient = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkEngine alloc] init];
    });
    
    return _sharedClient;
}


- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    if (self) {
        AFJSONResponseSerializer *dataSerializer = [AFJSONResponseSerializer serializer];
    
        self.responseSerializer = dataSerializer;
        self.requestSerializer.timeoutInterval = 20;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                
            }
        }];

    }
    return self;
}

#pragma mark - Requests - 
- (GetNearestBanks *)getNearestBanks {
    if (!_getNearestBanks) {
        _getNearestBanks = [[GetNearestBanks alloc] init];
    }
    return _getNearestBanks;
}

-(SubmitBank *)submitBank {
    if (!_submitBank) {
        _submitBank = [[SubmitBank alloc] init];
    }
    return _submitBank;
}


#pragma mark - Networking helper methods

- (void)getMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil)
            failure(operation, nil);
        else
            success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"get error code %ld operation %d and url %@",(long)error.code,operation.isCancelled,path);
        if(error.code!=-999 && !operation.isCancelled)
            failure(operation, error);
    }];
    
}


- (void)postMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil)
            failure(operation, nil);
        else
            success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"post error code %ld operation %d and url %@ http code %ld",(long)error.code,operation.isCancelled,path,(long)[operation.response statusCode ]);
        if(error.code!=-999 && !operation.isCancelled)
            failure(operation, error);
    }];
    

}


- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method path:(NSString *)pathToBeMatched {
    
    for(NSOperation *operation in self.operationQueue.operations) {
        BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}

@end
