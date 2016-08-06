//
//  UserMomentViewController.h
//  MomentHub
//
//  Created by Xuan Pham on 7/30/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ImageScrollView.h"

@interface UserMomentViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, ImageScrollViewDelegate>
@property (nonatomic, strong) PFObject *userObj;

@end
