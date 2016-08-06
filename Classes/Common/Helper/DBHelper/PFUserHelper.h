//
//  PFUserHelper.h
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFUserHelper : NSObject

+ (PFUserHelper *)sharedInstance;

- (void)getUserInfo:(NSString*)objectID completed:(void (^)(BOOL isFound, PFUser *userObj))completed;

@end
