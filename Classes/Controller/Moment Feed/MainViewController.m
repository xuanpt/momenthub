//
//  MainViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 7/30/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "MainViewController.h"
#import "UserMomentViewController.h"
#import "MomentDetailViewController.h"
#import "MomentDBHelper.h"
#import "MHMoment.h"
#import "PFUserHelper.h"
#import "UIImageView+MomentHub.h"


@implementation MainViewController {
    UITableView         *momentListTableView;
    UIRefreshControl    *refreshControl;
    
    NSMutableArray      *momentList;
    NSInteger           currentIndex;
    BOOL                mustReloadView;
}


- (id)init {
    self = [super init];
    
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_home"]];
        self.tabBarItem.title = @"Moments Feed";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moments Feed";
    self.navigationController.navigationBar.barTintColor = DefaultNavigationBackgroundColor_Gray;
    self.view.backgroundColor = DefaultBackgroundColor_Gray;
    
    
    currentIndex = 0;
    momentList = [NSMutableArray array];
    
    float viewHeight = ViewHeight(self.view) - [[[self tabBarController] tabBar] bounds].size.height;
    momentListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight) style:UITableViewStylePlain];
    momentListTableView.delegate = self;
    momentListTableView.dataSource = self;
    momentListTableView.backgroundColor = [UIColor clearColor];
    momentListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:momentListTableView];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [momentListTableView addSubview:refreshControl];
    refreshControl.backgroundColor = DefaultBackgroundColor_Gray;
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refreshDataList) forControlEvents:UIControlEventValueChanged];
    momentListTableView.alwaysBounceVertical = YES;
    
    [Util showLoading];
    [self getMomentList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataList) name:NOTIFICATION_MOMENT_CREATED object:nil];    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (mustReloadView == TRUE) {
        CGRect frame = momentListTableView.frame;
        frame.origin.y = 0;
        [momentListTableView scrollRectToVisible:frame animated:YES];
        [refreshControl endRefreshing];
        mustReloadView = FALSE;
    }
}

- (void)refreshDataList {
    mustReloadView = TRUE;
    [Util showLoading];
    [self getMomentList];
}


- (void)getMomentList {
    [[MomentDBHelper sharedInstance] getMomentList:currentIndex userID:nil completed:^(NSMutableArray *momentArr, NSError *error) {        
        [Util hideLoading];
        if (error == nil) {
            [self processData:momentArr];
        } else {
            [Util processError:error alertMsg:LocStr(@"An error occurred while loading info. Please try again.")];
        }
    }];
}


- (void)processData:(NSMutableArray*)momentArr {
    momentList = [NSMutableArray array];
    
    for (PFObject *item in momentArr) {
        [momentList addObject:[[MHMoment alloc] initWithMomentObj:item]];
    }
    
    [momentListTableView reloadData];
    
    // End the refreshing
    if (refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = Concat3String(LocStr(@"Last update:"), @" ", [formatter stringFromDate:[NSDate date]]);
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        [refreshControl endRefreshing];
    }
}


#pragma mark - UITableViewDelegate delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return momentList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MomentViewCellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 355)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    float yPos = 10;
    float xPos = 10;
    
    MHMoment *moment = momentList[indexPath.row];
    NSMutableArray *imageURLList = [NSMutableArray array];
    NSString *photoFieldName;
    int numberOfPhoto = 0;
    
    for (int i = 1; i <= 5; i++) {
        photoFieldName = [NSString stringWithFormat:@"Photo%d", i];
        if ([Util isGoodString:moment.momentObj[photoFieldName]]) {
            [imageURLList addObject:moment.momentObj[photoFieldName]];
            numberOfPhoto++;
        }
    }
    
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 40, 40)];
    profileImageView.tag = indexPath.row;
    [profileImageView roundedStyle];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 1;
    [contentView addSubview:profileImageView];
    profileImageView.userInteractionEnabled = YES;
    [profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageViewTapped:)]];
    
    
    xPos += ViewWidth(profileImageView) + 5;
    
    UILabel *usernameLabel = [Util createLabelWithDynamicWidth:CGRectMake(xPos, yPos, 0, 25) text:nil textAlignment:NSTextAlignmentLeft
        font:[UIFont boldSystemFontOfSize:14] textColor:DefaultTitleTextColor parentView:contentView];

    
    UILabel *descLabel = [Util createLabelWithDynamicWidth:CGRectMake(0, yPos, 0, 25)
        text:[NSString stringWithFormat:@"%@ %d %@", LocStr(@"added"), numberOfPhoto, LocStr(@"new photos")]
        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14] textColor:DefaultTitleTextColor parentView:contentView];
    descLabel.hidden = TRUE;
    
    if (moment.userObj == nil) {
        [[PFUserHelper sharedInstance] getUserInfo:moment.momentObj[UserID_Field] completed:^(BOOL isFound, PFUser *userObj) {
            if (isFound == TRUE) {
                moment.userObj = userObj;
                usernameLabel.text = userObj[PF_USER_FULLNAME];
                [Util updateLabelWidthByText:usernameLabel];
                [Util setViewXPos:descLabel xPos:ViewX(usernameLabel) + ViewWidth(usernameLabel) + 5];
                descLabel.hidden = FALSE;
                [Util loadImageWithImageURL:userObj[PF_USER_THUMBNAIL] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
                    profileImageView.image = image;
                }];
            }
        }];
    } else {
        usernameLabel.text = moment.userObj[PF_USER_FULLNAME];
        [Util updateLabelWidthByText:usernameLabel];
        [Util setViewXPos:descLabel xPos:ViewX(usernameLabel) + ViewWidth(usernameLabel) + 5];
        descLabel.hidden = FALSE;
        [Util loadImageWithImageURL:moment.userObj[PF_USER_THUMBNAIL] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
            profileImageView.image = image;
        }];
    }
    
    
    NSDate *postedDate = [NSDate dateWithTimeIntervalSince1970:[moment.momentObj[LastUpdatedAt_Field] integerValue]];
    
    [Util createLabelWithDynamicWidth:CGRectMake(xPos, yPos + ViewHeight(usernameLabel), ViewWidth(contentView) - xPos - 10, 15)
        text:[Util dateToString:postedDate format:@"MMM d, h:mm"] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13]
        textColor:[UIColor lightGrayColor] parentView:contentView];
    
    
    yPos += ViewHeight(profileImageView) + 5;
    xPos = 10;
    
    if (moment.momentObj[Title_Field] != nil) {
        UITextView *momentTitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, yPos, ViewWidth(contentView) - xPos - 10, 0)];
        momentTitleTextView.text = moment.momentObj[Title_Field];
        momentTitleTextView.textColor = DefaultTitleTextColor;
        momentTitleTextView.backgroundColor = [UIColor clearColor];
        momentTitleTextView.font = [UIFont systemFontOfSize:14];
        momentTitleTextView.scrollEnabled = FALSE;
        momentTitleTextView.editable = FALSE;
        [contentView addSubview:momentTitleTextView];
        [Util updateTextViewHeightByText:momentTitleTextView];
        
        yPos += ViewHeight(momentTitleTextView);
    }
    
    
    yPos += 10;
    
    ImageScrollView *tourImageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, yPos, ViewWidth(contentView), 250)];
    tourImageScrollView.delegate = self;
    tourImageScrollView.parentVC = self;
    tourImageScrollView.imageURLList = imageURLList;
    tourImageScrollView.isShowExpandImageView = FALSE;
    [tourImageScrollView settingView];
    tourImageScrollView.tag = indexPath.row;
    [contentView addSubview:tourImageScrollView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentDetailViewController *momentDetailViewController = [[MomentDetailViewController alloc] init];
    momentDetailViewController.parentVC = self;
    momentDetailViewController.moment = momentList[indexPath.row];;
    [self.navigationController pushViewController:momentDetailViewController animated:YES];
}


#pragma mark - ImageScrollViewDelegate delegate
- (void)imageScrollViewTapped:(NSInteger)tagIndex {
    MomentDetailViewController *momentDetailViewController = [[MomentDetailViewController alloc] init];
    momentDetailViewController.parentVC = self;
    momentDetailViewController.moment = momentList[tagIndex];
    [self.navigationController pushViewController:momentDetailViewController animated:YES];
}


- (void)profileImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    MHMoment *moment = momentList[gestureRecognizer.view.tag];
    
    UserMomentViewController *userMomentViewController = [[UserMomentViewController alloc] init];
    userMomentViewController.parentVC = self;
    userMomentViewController.userObj = moment.userObj;
    [self.navigationController pushViewController:userMomentViewController animated:YES];
}


- (void)loadedAllImage:(NSMutableArray*)imageList tagIndex:(int)tagIndex {
    MHMoment *moment = momentList[tagIndex];
    moment.loadedImageList = imageList;
}

@end
