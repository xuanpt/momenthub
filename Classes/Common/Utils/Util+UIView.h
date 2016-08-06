//
//  Util+UIView.h
//  MomentHub
//
//  Created by Tran Minh Thuan on 5/10/15.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagCenterActivityIndicator 10001

@interface UIView (Util)

- (CGFloat)topY;
- (CGFloat)bottomY;
- (CGFloat)leftX;
- (CGFloat)rightX;
- (CGFloat)sizeWidth;
- (CGFloat)sizeHeight;

- (void)addCenterActivityIndicator:(UIActivityIndicatorViewStyle)style;
- (void)removeCenterActivityIndicator;

@end
