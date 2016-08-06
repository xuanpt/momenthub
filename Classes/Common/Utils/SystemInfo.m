//
//  SystemInfo.m
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SystemInfo.h"
#import "Util.h"
#import "APIHelper.h"

@implementation SystemInfo

+ (SystemInfo *)sharedInstance {
    static SystemInfo *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SystemInfo alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    if(self) {
    }
    
    return self;
}


- (BOOL)checkIsLogginedIn {
    return ((_loginEmailAddress != nil && _loginPassword != nil) || (_loginFacebookID != nil && _loginFacebookToken != nil)) ? TRUE : FALSE;
}


- (void)setLoginEmailAddress:(NSString *)loginEmailAddress {
    _loginEmailAddress = loginEmailAddress;
}


- (void)setLoginPassword:(NSString*)loginPassword {
    _loginPassword = loginPassword;
}


- (void)setFacebookID:(NSString*)facebookID {
    _loginFacebookID = facebookID;
}


- (void)setFacebookToken:(NSString*)facebookToken {
    _loginFacebookToken = facebookToken;
}


- (void)clearLoginInfo {
    _loginEmailAddress = nil;
    _loginFacebookID = nil;
    _loginFacebookToken = nil;
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

@end
