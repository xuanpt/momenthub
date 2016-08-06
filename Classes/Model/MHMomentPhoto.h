//
//  MHMomentPhoto.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MHMomentPhoto : NSObject

@property (nonatomic, strong) PFObject *momentObj;
@property (nonatomic, assign) int      photoIndex;

- (id)initWithMomentObj:(PFObject*)momentObj;

@end
