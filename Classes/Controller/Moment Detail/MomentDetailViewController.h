//
//  MomentDetailViewController.h
//  MomentHub
//
//  Created by Xuan Pham on 12/26/15.
//  Copyright © 2015 Xuan Pham. All rights reserved.
//

#import "BaseViewController.h"
#import "MHMoment.h"

@interface MomentDetailViewController : BaseViewController
@property (nonatomic, strong) MHMoment  *moment;
@property (nonatomic, assign) int       scrollToImageIndex;

@end
