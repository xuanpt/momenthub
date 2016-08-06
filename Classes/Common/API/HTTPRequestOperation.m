//
//  HTTPRequestOperation.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "HTTPRequestOperation.h"

@interface AFURLConnectionOperation ()

@property (readwrite, nonatomic, strong) NSURLResponse *response;
@property (readwrite, nonatomic, strong) NSData *responseData;
@property (readwrite, nonatomic, strong) NSError *error;

- (void)operationDidStart;
- (void)finish;

@end

@implementation HTTPRequestOperation

- (void)operationDidStart {
    if (self.request.cachePolicy != NSURLRequestReloadIgnoringCacheData && [self.request.HTTPMethod isEqualToString:@"GET"]) {
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:self.request];
        if (cachedResponse) {
            self.response = cachedResponse.response;
            self.responseData = cachedResponse.data;
            self.error = nil;
            [self finish];
            return;
        }
    }
    
    [super operationDidStart];
}

@end
