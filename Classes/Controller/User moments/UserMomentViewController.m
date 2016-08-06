//
//  UserMomentViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 7/30/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "UserMomentViewController.h"
#import "MomentDetailViewController.h"
#import "MomentDBHelper.h"
#import "MHMoment.h"
#import "PFUserHelper.h"
#import "UIImageView+MomentHub.h"

#define CellHeight_Top              150
#define CellHeight_BasicInfo        144


@implementation UserMomentViewController {
    UITableView         *momentListTableView;
    UIRefreshControl    *refreshControl;
    NSMutableArray      *momentList;
    NSInteger           currentIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _userObj[PF_USER_FULLNAME];
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


- (void)refreshDataList {
    [Util showLoading];
    [self getMomentList];
}


- (void)getMomentList {
    [[MomentDBHelper sharedInstance] getMomentList:currentIndex userID:_userObj.objectId completed:^(NSMutableArray *momentArr, NSError *error) {
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


- (void)refreshTableView {
    [momentListTableView reloadData];
}


#pragma mark - UITableViewDelegate delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return momentList.count + 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return CellHeight_Top;
    if (indexPath.row == 1) return CellHeight_BasicInfo;
    else return 410;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"UserMomentViewCellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if      (indexPath.row == 0)    [self settinggCell_Top:cell];
    else if (indexPath.row == 1)    [self settinggCell_BasicInfo:cell];
    else                            [self settinggCell_MomentItem:cell indexPath:indexPath];
    
    return cell;
}


- (void)settinggCell_Top:(UITableViewCell*)cell {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, CellHeight_Top - 10)];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor clearColor];
    [cell addSubview:contentView];
    
    
    float yPos = 15;
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ViewWidth(contentView) - 80) / 2, yPos, 80, 80)];
    [profileImageView roundedStyle];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [Util loadImageWithImageURL:[PFUser currentUser][PF_USER_IMAGE] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
        profileImageView.image = image;
    }];
    [contentView addSubview:profileImageView];
    
    
    yPos += 95;
    
    [Util createLabel:CGRectMake(0, yPos, ViewWidth(contentView), 20) text:[PFUser currentUser][PF_USER_FULLNAME] textAlignment:NSTextAlignmentCenter
                 font:[UIFont boldSystemFontOfSize:20] textColor:DefaultTitleTextColor parentView:contentView];
}


- (void)settinggCell_BasicInfo:(UITableViewCell*)cell {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, CellHeight_BasicInfo - 20)];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = UIColorFromRGBValues(197, 199, 204).CGColor;
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    
    float yPos = 1;
    float valueTextWidth;
    
    UIView *headerView = [Util createView:CGRectMake(0, yPos, ViewWidth(contentView), 40) backgroundColor:UIColorFromRGBValues(246, 247, 248)
        borderColor:nil parentView:contentView];
    
    
    [Util createLabelWithDynamicWidth:CGRectMake(10, yPos, 0, ViewHeight(headerView)) text:LocStr(@"Basic info") textAlignment:NSTextAlignmentLeft
        font:[UIFont boldSystemFontOfSize:16] textColor:DefaultTitleTextColor parentView:headerView];
    
    yPos += ViewHeight(headerView);
    
    //Create line view
    [Util createView:CGRectMake(0, yPos, ViewWidth(contentView), 1) backgroundColor:UIColorFromRGBValues(222, 223, 224) borderColor:nil parentView:contentView];
    
    
    yPos += 1;
    
    //Create name view
    UIView *nameView = [Util createView:CGRectMake(0, yPos, ViewWidth(contentView), 40) backgroundColor:[UIColor whiteColor] borderColor:nil parentView:contentView];
    
    UILabel *nameTitleLablel = [Util createLabelWithDynamicWidth:CGRectMake(10, 0, 0, ViewHeight(nameView)) text:LocStr(@"Full name")
                                                   textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:nameView];
    
    valueTextWidth = ViewWidth(nameView) - (ViewX(nameTitleLablel) + ViewWidth(nameTitleLablel) + 10);
    
    [Util createLabel:CGRectMake(ViewWidth(nameView) - valueTextWidth - 10, 0, valueTextWidth, ViewHeight(nameView))
                 text:[Util isGoodString:[PFUser currentUser][PF_USER_FULLNAME]] ? [PFUser currentUser][PF_USER_FULLNAME] : @"" textAlignment:NSTextAlignmentRight
                 font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:nameView];
    
    
    yPos += ViewHeight(nameView);
    
    //Create line view
    [Util createView:CGRectMake(0, yPos, ViewWidth(contentView), 1) backgroundColor:UIColorFromRGBValues(222, 223, 224) borderColor:nil parentView:contentView];
    
    
    yPos += 1;
    
    //Create email view
    UIView *emailView = [Util createView:CGRectMake(0, yPos, ViewWidth(contentView), 40) backgroundColor:[UIColor whiteColor] borderColor:nil parentView:contentView];
    
    UILabel *mailTitleLablel = [Util createLabelWithDynamicWidth:CGRectMake(10, 0, 0, ViewHeight(emailView)) text:LocStr(@"Email")
                                                   textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:emailView];
    
    valueTextWidth = ViewWidth(emailView) - (ViewX(mailTitleLablel) + ViewWidth(mailTitleLablel) + 10);
    
    [Util createLabel:CGRectMake(ViewWidth(emailView) - valueTextWidth - 10, 0, valueTextWidth, ViewHeight(emailView)) text:[PFUser currentUser][PF_USER_EMAIL]
        textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:emailView];
}


- (void)settinggCell_MomentItem:(UITableViewCell*)cell indexPath:(NSIndexPath *)indexPath {
    MHMoment *moment = momentList[indexPath.row - 2];
    NSMutableArray *imageURLList = [NSMutableArray array];
    NSString *photoFieldName;
    int numberOfPhoto;
    
    for (int i = 1; i <= 5; i++) {
        photoFieldName = [NSString stringWithFormat:@"Photo%d", i];
        if ([Util isGoodString:moment.momentObj[photoFieldName]]) {
            [imageURLList addObject:moment.momentObj[photoFieldName]];
            numberOfPhoto++;
        }
    }
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 405)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    
    float yPos = 10;
    float xPos = 10;
    
    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 40, 40)];
    profileImageView.tag = indexPath.row;
    [profileImageView roundedStyle];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 1;
    [contentView addSubview:profileImageView];
    profileImageView.userInteractionEnabled = YES;
    
    
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
    tourImageScrollView.tag = indexPath.row - 2;
    [contentView addSubview:tourImageScrollView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        MomentDetailViewController *momentDetailViewController = [[MomentDetailViewController alloc] init];
        momentDetailViewController.parentVC = self;
        momentDetailViewController.moment = momentList[indexPath.row];;
        [self.navigationController pushViewController:momentDetailViewController animated:YES];
    }
}


#pragma mark - ImageScrollViewDelegate delegate
- (void)imageScrollViewTapped:(NSInteger)tagIndex {
    MomentDetailViewController *momentDetailViewController = [[MomentDetailViewController alloc] init];
    momentDetailViewController.parentVC = self;
    momentDetailViewController.moment = momentList[tagIndex];
    [self.navigationController pushViewController:momentDetailViewController animated:YES];
}


- (void)loadedAllImage:(NSMutableArray*)imageList tagIndex:(int)tagIndex {
    MHMoment *moment = momentList[tagIndex];
    moment.loadedImageList = imageList;
}

@end
