//
//  ScrollImageItem.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

@interface ScrollImageItem : NSObject

@property (nonatomic, assign) int                   itemIndex;
@property (nonatomic, assign) ScrollImageItemType   itemType;
@property (nonatomic, strong) NSString              *imageURL;
@property (nonatomic, strong) UIImage               *imageObj;

- (id)initWithImageURL:(int)itemIndex imageURL:(NSString*)imageURL;
- (id)initWithImageObj:(int)itemIndex imageObj:(UIImage*)imageObj;

@end
