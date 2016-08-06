//
//  APIHelper.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "AFSecurityPolicy.h"
#import "NSURLRequest+MomentHub.h"
#import "AFNetworking.h"
#import "ServiceError.h"
#import "defined.h"
#import "Reachability.h"


@interface APIHelper : AFHTTPRequestOperationManager

@property (strong, nonatomic) Reachability *checkingConnectionReach;
@property (strong, nonatomic) Reachability *internetConnectionReach;
@property (assign, nonatomic) BOOL isCurrentNetworkAvailable;


+ (APIHelper *)sharedAPIHelper;

- (BOOL)isNetworkAvailable;
- (void)cancelAllHTTPOperations;

- (void)uploadImage:(NSString*)fileName imageData:(NSData*)imageData completed:(void (^)(NSString *imageURL, NSError *error))completed;
- (void)downloadImage:(NSString *)imageUrl completed:(void (^)(UIImage *image, ServiceError *error))completed;

//======================================== Sample API ========================================
- (void)createUser:(NSString*)userInfo token:(NSString*)token completed:(void (^)(NSString *userID, NSError *error))completed;
//============================================================================================
@end

