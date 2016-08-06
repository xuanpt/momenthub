//
//  MomentDetailViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 12/26/15.
//  Copyright © 2015 Xuan Pham. All rights reserved.
//

#import "MomentDetailViewController.h"
#import "ImageScrollView.h"
#import "UserMomentViewController.h"
#import "ImageViewController.h"
#import "UIImageView+MomentHub.h"
#import "PFUserHelper.h"


@implementation MomentDetailViewController {
    UIScrollView    *mainScrollView;
    UIImageView     *profileImageView;
    UILabel         *usernameLabel;
    UILabel         *descLabel;
    
    NSMutableArray  *imageList;
    NSMutableArray  *imageViewList;
    int             numberOfImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = DefaultNavigationBackgroundColor_Gray;
    self.view.backgroundColor = DefaultBackgroundColor_Gray;
    
    [self settingMainView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_scrollToImageIndex != 0) {
        CGRect frame = mainScrollView.frame;
        frame.origin.y = ViewY(((UIImageView*)imageViewList[_scrollToImageIndex]));
        [mainScrollView scrollRectToVisible:frame animated:YES];
    }
}


- (void)settingMainView {
    imageViewList = [NSMutableArray array];
    NSMutableArray *imageURLList = [NSMutableArray array];
    
    if ([Util isGoodArray:_moment.loadedImageList]) {
        imageList       = _moment.loadedImageList;
        numberOfImage   = (int)_moment.loadedImageList.count;
    } else {
        NSString *photoFieldName;
        
        for (int i = 1; i <= 5; i++) {
            photoFieldName = [NSString stringWithFormat:@"Photo%d", i];
            if ([Util isGoodString:_moment.momentObj[photoFieldName]]) {
                [imageURLList addObject:_moment.momentObj[photoFieldName]];
                numberOfImage++;
            }
        }
    }
    
    float viewHeight = ViewHeight(self.view) - [[[self tabBarController] tabBar] bounds].size.height;
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrollView];
    
    
    float yPos = 10;
    float xPos = 10;
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 40, 40)];
    [profileImageView roundedStyle];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 1;
    [mainScrollView addSubview:profileImageView];
    profileImageView.userInteractionEnabled = YES;
    [profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageViewTapped:)]];

    xPos += ViewWidth(profileImageView) + 5;
    
    usernameLabel = [Util createLabelWithDynamicWidth:CGRectMake(xPos, yPos, 0, 25) text:@"" textAlignment:NSTextAlignmentLeft
        font:[UIFont boldSystemFontOfSize:14] textColor:DefaultTitleTextColor parentView:mainScrollView];
    
    descLabel = [Util createLabelWithDynamicWidth:CGRectMake(ViewX(usernameLabel) + ViewWidth(usernameLabel) + 5, yPos, 0, 25)
        text:[NSString stringWithFormat:@"%@ %d %@", LocStr(@"added"), numberOfImage, LocStr(@"new photos")]
        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14] textColor:DefaultTitleTextColor parentView:mainScrollView];
    descLabel.hidden = TRUE;
    
    if (_moment.userObj == nil) {
        [[PFUserHelper sharedInstance] getUserInfo:_moment.momentObj[UserID_Field] completed:^(BOOL isFound, PFUser *userObj) {
            if (isFound == TRUE) {
                _moment.userObj = userObj;
                [self settingUserInfo];
            }
        }];
    } else {
        [self settingUserInfo];
    }
    
    
    NSDate *postedDate = [NSDate dateWithTimeIntervalSince1970:[_moment.momentObj[LastUpdatedAt_Field] integerValue]];
    
    [Util createLabelWithDynamicWidth:CGRectMake(xPos, yPos + ViewHeight(usernameLabel), ViewWidth(mainScrollView) - xPos - 10, 15)
        text:[Util dateToString:postedDate format:@"MMM d, h:mm"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]
        textColor:[UIColor lightGrayColor] parentView:mainScrollView];
    
    
    yPos += ViewHeight(profileImageView) + 5;
    xPos = 10;
    
    if (_moment.momentObj[Title_Field] != nil) {
        UITextView *momentTitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, yPos, ViewWidth(mainScrollView) - xPos - 10, 0)];
        momentTitleTextView.text = _moment.momentObj[Title_Field];
        momentTitleTextView.textColor = DefaultTitleTextColor;
        momentTitleTextView.backgroundColor = [UIColor clearColor];
        momentTitleTextView.font = [UIFont systemFontOfSize:14];
        momentTitleTextView.scrollEnabled = FALSE;
        momentTitleTextView.editable = FALSE;
        [mainScrollView addSubview:momentTitleTextView];
        [Util updateTextViewHeightByText:momentTitleTextView];
        
        yPos += ViewHeight(momentTitleTextView);
    }
    
    yPos += 10;
    
    mainScrollView.contentSize = CGSizeMake(ViewWidth(mainScrollView), yPos);
    
    if ([Util isGoodArray:_moment.loadedImageList]) {
        [self settingImageList:yPos];
    } else {
        [self loadImageList:imageURLList];
    }
}


- (void)settingUserInfo {
    self.title = [NSString stringWithFormat:@"%@'s Post", _moment.userObj[PF_USER_FULLNAME]];
    usernameLabel.text = _moment.userObj[PF_USER_FULLNAME];
    [Util updateLabelWidthByText:usernameLabel];
    [Util setViewXPos:descLabel xPos:ViewX(usernameLabel) + ViewWidth(usernameLabel) + 5];
    descLabel.hidden = FALSE;
    [Util loadImageWithImageURL:_moment.userObj[PF_USER_THUMBNAIL] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
        profileImageView.image = image;
    }];
}


- (void)loadImageList:(NSMutableArray*)imageURLList {
    _moment.loadedImageList = [NSMutableArray array];
    
    for (NSString *imageURL in imageURLList) {
        [Util loadImageWithImageURL:imageURL noImageFile:@"no-image-available.jpg" completed:^(UIImage *image) {
            [_moment.loadedImageList addObject:image];
            if (_moment.loadedImageList.count == numberOfImage) {
                imageList = _moment.loadedImageList;
                [self settingImageList:mainScrollView.contentSize.height];
            }
        }];
    }
}


- (void)settingImageList:(CGFloat)startYPos {
    UIImageView *imageView;
    CGFloat yPos = startYPos;
    
    for (int i = 0; i < imageList.count; i++) {
        imageView = [self createMomentImageView:imageList[i] yPos:yPos];
        [imageViewList addObject:imageView];
        yPos += ViewHeight(imageView) + 5;
    }
    
    yPos += 10;
    mainScrollView.contentSize = CGSizeMake(ViewWidth(mainScrollView), yPos);
}


- (UIImageView*)createMomentImageView:(UIImage*)image yPos:(CGFloat)yPos {
    CGFloat imageWidth = ViewWidth(mainScrollView);
    CGFloat imageHeight = imageWidth * image.size.height / image.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos, imageWidth, imageHeight)];
    imageView.image = image;
    [mainScrollView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    return imageView;
}


- (void)imageViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    ImageViewController *imageViewController = [[ImageViewController alloc] init];
    imageViewController.image = imageView.image;
    [self.parentVC presentViewController:imageViewController animated:YES completion:nil];
}


- (void)profileImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    UserMomentViewController *userMomentViewController = [[UserMomentViewController alloc] init];
    userMomentViewController.parentVC = self;
    userMomentViewController.userObj = _moment.userObj;
    [self.navigationController pushViewController:userMomentViewController animated:YES];
}


@end
