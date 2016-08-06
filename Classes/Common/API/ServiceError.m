//
//  ServiceError.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "ServiceError.h"
#import "APIHelper.h"

NSString * const JsonResponseKeyStatus      = @"status";
NSString * const JsonResponseKeyErrorCode   = @"error_cd";
NSString * const JsonResponseKeyErrorMsg    = @"message";
NSString * const JsonResponseKeyResult      = @"result";

@implementation ServiceError

@synthesize httpCode;
@synthesize serviceCode;
@synthesize message;


- (id)init {
    self = [super init];
    if(self) {
        self.httpCode = 0;
        self.serviceCode = 0;
        self.message = @"";
    }
    return self;
}


- (NSString *)localizedMessage {
    if (self.serviceCode == 107) {
        self.message = LocStr(@"ToastMissingParameter");
    } else if(self.serviceCode == 204) {
        self.message = LocStr(@"PasswordWrongMsg");
    } else if(self.serviceCode == 205) {
        self.message = LocStr(@"PasswordInvalidMsg");
    } else if(self.serviceCode == 302) {
        self.message = LocStr(@"ToastTaskAlreadyClosed");
    } else if(self.serviceCode == 401) {
        self.message = LocStr(@"ToastReportAlreadyCompleted");
    } else if(self.serviceCode == 402) {
        self.message = LocStr(@"ToastReportAlreadyOpen");
    } else if(self.serviceCode == 206) {
        self.message = LocStr(@"AvatarNotChanged");
    } else if(self.serviceCode > 0) {
        self.message = LocStr(@"UnknownError");
    }
    return self.message;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Http code: %d, service code: %d, message: %@", (int)self.httpCode, (int)self.serviceCode, self.message];
}


+ (id)errorWithServiceCode:(NSInteger)serviceCode httpCode:(NSInteger)httpCode message:(NSString *)msg {
    ServiceError *serviceErr = [[ServiceError alloc] init];
    serviceErr.httpCode = httpCode;
    serviceErr.serviceCode = serviceCode;
    serviceErr.message = msg;
    return serviceErr;
}


+ (id)errorWithServiceCode:(NSInteger)serviceCode message:(NSString *)msg {
    return [ServiceError errorWithServiceCode:serviceCode httpCode:0 message:msg];
}


+ (id)errorWithNSError:(NSError *)error httpCode:(NSInteger)httpCode {
    ServiceError *serviceErr = [[ServiceError alloc] init];
    serviceErr.httpCode = httpCode > 0 ? httpCode : error.code;
    serviceErr.message = [error localizedDescription];
    
    NSDictionary *userInfo = [error userInfo];
    if(userInfo && [userInfo objectForKey:@"NSLocalizedRecoverySuggestion"]) {
        NSString *jsonStr = [userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        if(data) {
            NSError *err = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if(!err) {
                if ([dict objectForKey:JsonResponseKeyErrorCode]) {
                    serviceErr.serviceCode = [[dict objectForKey:JsonResponseKeyErrorCode] integerValue];
                }
                if ([dict objectForKey:JsonResponseKeyErrorMsg]) {
                    serviceErr.message = [dict objectForKey:JsonResponseKeyErrorMsg];
                }
            }
        }
    }
    
    return serviceErr;
}


+ (BOOL)hasErrorWithResponseJson:(id)responseJSON {
    if(!responseJSON) return false;
    NSString *value = [responseJSON objectForKey:JsonResponseKeyErrorCode];
    if(value) {
        return [value integerValue] > 0;
    }
    return false;
}


+ (ServiceError *)makeServiceErrorIfNeededWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject {
    return [ServiceError makeServiceErrorIfNeededWithOperation:operation withNSError:nil withResponseObject:responseObject];
}


+ (ServiceError *)makeServiceErrorIfNeededWithOperation:(AFHTTPRequestOperation *)operation withNSError:(NSError *)nsError {
    return [ServiceError makeServiceErrorIfNeededWithOperation:operation withNSError:nsError withResponseObject:nil];
}


+ (ServiceError *)makeServiceErrorIfNeededWithOperation:(AFHTTPRequestOperation *)operation withNSError:(NSError *)nsError withResponseObject:(id)responseObject {
    ServiceError *serviceError = nil;
    NSInteger httpCode = operation.response.statusCode;
    
    if([operation isCancelled]) {
        serviceError = [ServiceError errorWithServiceCode:999 message:@"Request cancelled"];
    } else if(nsError) {
        serviceError = [ServiceError errorWithNSError:nsError httpCode:httpCode];
    } else if(responseObject) {
        if([ServiceError hasErrorWithResponseJson:responseObject]) {
            NSInteger serviceCode = [[responseObject objectForKey:JsonResponseKeyErrorCode] integerValue];
            serviceError = [ServiceError errorWithServiceCode:serviceCode
                                                        httpCode:httpCode
                                                         message:[responseObject objectForKey:JsonResponseKeyErrorMsg]];
            if(serviceError.serviceCode == 103 || serviceError.serviceCode == 104) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:kInvalidSessionNotification object:nil];
                //[Util showErrorMessage:LocStr(@"ErrorAuthFailed")];
            }
        }
    } else if(![[APIHelper sharedAPIHelper] isNetworkAvailable]) {
        serviceError = [ServiceError errorWithServiceCode:kNetworkError
                                                    httpCode:kNetworkError
                                                     message:LocStr(@"NetworkError")];
        
    }
        
    return serviceError;
}

@end
