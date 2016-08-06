//
//  ImageViewController.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"

@interface ImageViewController : BaseViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIScrollView  *mainScrollView;
@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UIButton      *closeButton;
@property (strong, nonatomic) UIImage       *image;

@end
