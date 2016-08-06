//
//  MomentBrowseViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 7/30/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "MomentBrowseViewController.h"
#import "MomentDBHelper.h"
#import "MHMomentPhoto.h"
#import "MomentDetailViewController.h"
#import "UIImageView+MomentHub.h"

#define COLLECTION_VIEW_CELL_HEIGHT_WIDTH   (ScreenWidth - 2) / 3


@implementation MomentBrowseViewController {
    UICollectionView    *momentPhotoCollectionView;
    UIRefreshControl    *refreshControl;
    
    NSMutableArray      *momentPhotoList;
    NSInteger           currentIndex;
    BOOL                mustReloadView;
}


- (id)init {
    self = [super init];
    
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_table@2x.png"]];
        self.tabBarItem.title = @"Moments Browse";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Moments Browse";
    self.navigationController.navigationBar.barTintColor = DefaultNavigationBackgroundColor_Gray;
    self.view.backgroundColor = DefaultBackgroundColor_Gray;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    
    float viewHeight = ViewHeight(self.view) - [[[self tabBarController] tabBar] bounds].size.height;
    momentPhotoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight) collectionViewLayout:layout];
    momentPhotoCollectionView.backgroundColor = UIColorFromRGBValues(241, 240, 241);
    [momentPhotoCollectionView setDataSource:self];
    [momentPhotoCollectionView setDelegate:self];
    [momentPhotoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MomentPhotoCellIdentifier"];
    [self.view addSubview:momentPhotoCollectionView];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [momentPhotoCollectionView addSubview:refreshControl];
    refreshControl.backgroundColor = DefaultBackgroundColor_Gray;
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(getMomentPhotoList) forControlEvents:UIControlEventValueChanged];
    momentPhotoCollectionView.alwaysBounceVertical = YES;

    [Util showLoading];
    [self getMomentPhotoList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataList) name:NOTIFICATION_MOMENT_CREATED object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (mustReloadView == TRUE) {
        CGRect frame = momentPhotoCollectionView.frame;
        frame.origin.y = 0;
        [momentPhotoCollectionView scrollRectToVisible:frame animated:YES];
        [refreshControl endRefreshing];
        mustReloadView = FALSE;
    }
}


- (void)refreshDataList {
    mustReloadView = TRUE;
    [Util showLoading];
    [self getMomentPhotoList];
}


- (void)getMomentPhotoList {
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
    momentPhotoList = [NSMutableArray array];
    MHMomentPhoto *momentPhoto;
    
    for (PFObject *momentObj in momentArr) {
        for (int i = 0; i < 5; i++) {
            if ([Util isGoodString:momentObj[[NSString stringWithFormat:@"Photo%d", i + 1]]]) {
                momentPhoto = [[MHMomentPhoto alloc] initWithMomentObj:momentObj];
                momentPhoto.photoIndex = i;
                [momentPhotoList addObject:momentPhoto];
            } else {
                break;
            }
        }
    }
    
    [momentPhotoCollectionView reloadData];
    
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


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return momentPhotoList.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(COLLECTION_VIEW_CELL_HEIGHT_WIDTH, COLLECTION_VIEW_CELL_HEIGHT_WIDTH);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MomentPhotoCellIdentifier";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGBValues(241, 240, 241);
    cell.layer.borderWidth = 1.0f;
    
    for (UIView *subview in [cell subviews]) {
        [subview removeFromSuperview];
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, COLLECTION_VIEW_CELL_HEIGHT_WIDTH, COLLECTION_VIEW_CELL_HEIGHT_WIDTH)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    
    MHMomentPhoto *momentPhoto = momentPhotoList[indexPath.row];
    NSString *photoURL = momentPhoto.momentObj[[NSString stringWithFormat:@"Photo%d", momentPhoto.photoIndex + 1]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(contentView), ViewHeight(contentView))];
    [imageView loadImageWithImageURL:photoURL noImageFile:@"no_image.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [contentView addSubview:imageView];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHMomentPhoto *momentPhoto = momentPhotoList[indexPath.row];
    
    MomentDetailViewController *momentDetailViewController = [[MomentDetailViewController alloc] init];
    momentDetailViewController.parentVC = self;
    momentDetailViewController.moment = [[MHMoment alloc] initWithMomentObj:momentPhoto.momentObj];
    momentDetailViewController.scrollToImageIndex = momentPhoto.photoIndex;
    [self.navigationController pushViewController:momentDetailViewController animated:YES];
}

@end
