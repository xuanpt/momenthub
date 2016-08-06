//
//  PFUserHelper.m
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Parse/Parse.h>
#import "Util.h"
#import "PFUserHelper.h"


@implementation PFUserHelper

+ (PFUserHelper *)sharedInstance {
    static PFUserHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PFUserHelper alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}


- (void)getUserInfo:(NSString*)objectID completed:(void (^)(BOOL isFound, PFUser *userObj))completed {
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:objectID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                if (completed != nil) completed(TRUE, objects[0]);
            } else {
                if (completed != nil) completed(FALSE, nil);
            }
        } else {
            [Util processError:error alertMsg:LocStr(@"An error occurred while loading info. Please try again.")];
        }
    }];
}

@end
