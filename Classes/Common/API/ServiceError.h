//
//  ServiceError.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

extern NSString *const JsonResponseKeyStatus;
extern NSString *const JsonResponseKeyErrorCode;
extern NSString *const JsonResponseKeyErrorMsg;
extern NSString *const JsonResponseKeyResult;

#define kNetworkError   1000


@interface ServiceError : NSObject

@property(nonatomic, assign) NSInteger httpCode;
@property(nonatomic, assign) NSInteger serviceCode;
@property(nonatomic, strong) NSString* message;

- (NSString *)localizedMessage;

+ (ServiceError *)makeServiceErrorIfNeededWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject;
+ (ServiceError *)makeServiceErrorIfNeededWithOperation:(AFHTTPRequestOperation *)operation withNSError:(NSError *)nsError;

@end

