//
//  BaseViewController.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController
@property(nonatomic, weak) BaseViewController *parentVC;

- (void)createBackButton:(BOOL)isWhiteOrBlack;
- (UIButton*)createCloseButton;

@end
