//
//  MHMoment.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MHMoment : NSObject

@property (nonatomic, strong) PFObject          *momentObj;
@property (nonatomic, strong) PFObject          *userObj;
@property (nonatomic, strong) NSMutableArray    *likeList;
@property (nonatomic, strong) NSMutableArray    *loadedImageList;

- (id)initWithMomentObj:(PFObject*)momentObj;

@end
