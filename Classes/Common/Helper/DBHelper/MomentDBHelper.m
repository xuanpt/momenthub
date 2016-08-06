//
//  MomentDBHelper.m
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Parse/Parse.h>
#import "MomentDBHelper.h"
#import "Util.h"


@implementation MomentDBHelper

+ (MomentDBHelper *)sharedInstance {
    static MomentDBHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MomentDBHelper alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}


- (void)getMomentList:(NSInteger)fromIndex userID:(NSString*)userID completed:(void (^)(NSMutableArray* momentArr, NSError *error))completed {
    PFQuery *query = [PFQuery queryWithClassName:Moment_Class];
    if ([Util isGoodString:userID])[query whereKey:UserID_Field equalTo:userID];
    query.skip = fromIndex;
    [query orderByDescending:LastUpdatedAt_Field];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *momentArr = [NSMutableArray array];
        
        if (!error) {
            momentArr = [objects mutableCopy];
        }
        
        if (completed != nil) completed(momentArr, error);
    }];
}


@end
