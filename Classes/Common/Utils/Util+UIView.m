//
//  Util+UIView.m
//  MomentHub
//
//  Created by Tran Minh Thuan on 5/10/15.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "Util+UIView.h"

@implementation UIView (Util)

- (CGFloat)topY {
    return self.frame.origin.y;
}

- (CGFloat)bottomY {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)leftX {
    return self.frame.origin.x;
}

- (CGFloat)rightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)sizeWidth {
    return self.frame.size.width;
}

- (CGFloat)sizeHeight {
    return self.frame.size.height;
}

- (void)addCenterActivityIndicator:(UIActivityIndicatorViewStyle)style {
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    aiv.hidesWhenStopped = true;
    aiv.frame = CGRectMake(self.sizeWidth / 2 - 20, self.sizeHeight / 2 - 20, 40, 40);
    aiv.tag = kTagCenterActivityIndicator;
    [self addSubview:aiv];
    
    [aiv startAnimating];
}

- (void)removeCenterActivityIndicator {
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self viewWithTag:kTagCenterActivityIndicator];
    [aiv stopAnimating];
    [aiv removeFromSuperview];
}

@end
