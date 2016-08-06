//
//  APIHelper.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "APIHelper.h"


@implementation APIHelper

+ (APIHelper *)sharedAPIHelper {
    static APIHelper *_sharedAPIHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPIHelper = [[APIHelper alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedAPIHelper;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self settingNetworkMonitoring];
    }
    
    return self;
}


- (BOOL)isNetworkAvailable {
    return _isCurrentNetworkAvailable;
}


- (void)settingNetworkMonitoring {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.checkingConnectionReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    self.checkingConnectionReach.reachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = TRUE;
    };
    
    self.checkingConnectionReach.unreachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = FALSE;
    };
    [self.checkingConnectionReach startNotifier];
    
    
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    self.internetConnectionReach.reachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = TRUE;
    };
    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = FALSE;
    };
    
    [self.internetConnectionReach startNotifier];
}


-(void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    
    if (reach == self.internetConnectionReach) {
        if([reach isReachable]) {
            self.isCurrentNetworkAvailable = TRUE;
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        } else {
            self.isCurrentNetworkAvailable = FALSE;
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
    }
}


- (void)cancelAllHTTPOperations {
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) continue;
        
        [operation cancel];
    }
}


- (void)uploadImage:(NSString*)fileName imageData:(NSData*)imageData completed:(void (^)(NSString *imageURL, NSError *error))completed {
    NSString *urlString = Concat3String(kParseAPIBaseURL, kParseAPIUploadFile, fileName);
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [parseRequest setHTTPMethod:kHTTPPost];
    [parseRequest setValue:kParseApplicationID          forHTTPHeaderField:kParseApplicationIDHeader];
    [parseRequest setValue:kParseAPIKey                 forHTTPHeaderField:kParseAPIKeyHeader];
    [parseRequest setValue:kHTTPContentType_ImageJpeg   forHTTPHeaderField:kHTTPContentType];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:imageData];
    [parseRequest setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:parseRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        if ([httpResponse statusCode] == 201) {
            NSError *error;
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers error:&error];
            
            if (completed) completed((error == nil) ? [responseDictionary objectForKey:@"url"] : nil, error);
        } else {
            if (completed) completed(nil, connectionError);
        }
    }];
}


- (void)downloadImage:(NSString *)imageUrl completed:(void (^)(UIImage *image, ServiceError *error))completed {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completed((UIImage*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ServiceError *serviceError = [ServiceError makeServiceErrorIfNeededWithOperation:operation withNSError:error];
        if (completed) {
            completed(nil, serviceError);
        }
    }];
    
    [operation start];
}


//======================================== Sample API ========================================
- (void)createUser:(NSString*)userInfo token:(NSString*)token completed:(void (^)(NSString *userID, NSError *error))completed {
    NSString *urlString = kAPIBaseURL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:kHTTPPost];
    [request setValue:@"application/json"               forHTTPHeaderField:kHTTPContentType];
    [request setValue:kRequestAuthUserNameValue         forHTTPHeaderField:kRequestAuthUserNameKey];
    [request setValue:kRequestAuthPasswordValue         forHTTPHeaderField:kRequestAuthPasswordKey];
    [request setValue:userInfo                          forHTTPHeaderField:@"UserInfo"];
    [request setValue:token                             forHTTPHeaderField:@"Token"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSString *userID;
        
        if ([httpResponse statusCode] == 200) {
            NSError *error;
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dataDic = [responseDictionary objectForKey:@"data"];
            userID = [dataDic objectForKey:@"id"];
        }
        
        if (completed) completed(userID, connectionError);
    }];
}

@end
