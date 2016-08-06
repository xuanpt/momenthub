//
//  MHMoment.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.


#import "MHMoment.h"

@implementation MHMoment


- (id)initWithMomentObj:(PFObject*)momentObj {
    self = [super init];
    
    if (self) {
        self.momentObj = momentObj;
    }
    
    return self;
}

@end
