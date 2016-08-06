//
//  ScrollImageItem.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.


#import "ScrollImageItem.h"

@implementation ScrollImageItem


- (id)initWithImageURL:(int)itemIndex imageURL:(NSString*)imageURL {
    self = [super init];
    
    if (self) {
        _itemIndex  = itemIndex;
        _itemType   = ScrollImageItemType_ImageURL;
        _imageURL   = imageURL;
    }
    
    return self;
}


- (id)initWithImageObj:(int)itemIndex imageObj:(UIImage*)imageObj {
    self = [super init];
    
    if (self) {
        _itemIndex  = itemIndex;
        _itemType   = ScrollImageItemType_ImageObj;
        _imageObj   = imageObj;
    }
    
    return self;
}

@end
