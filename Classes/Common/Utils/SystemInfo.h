//
//  SystemInfo.h
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfo : NSObject
@property (nonatomic, strong, readonly) NSString *loginEmailAddress;
@property (nonatomic, strong, readonly) NSString *loginPassword;

@property (nonatomic, strong, readonly) NSString *loginFacebookID;
@property (nonatomic, strong, readonly) NSString *loginFacebookToken;


+ (SystemInfo *)sharedInstance;

- (void)setLoginEmailAddress:(NSString*)loginEmailAddress;
- (void)setLoginPassword:(NSString*)loginPassword;
- (void)setFacebookID:(NSString*)facebookID;
- (void)setFacebookToken:(NSString*)facebookToken;
- (void)clearLoginInfo;
- (BOOL)checkIsLogginedIn;

@end
