//  SchoolImageScrollView.h
//  MomentHub
//
//  Created by Xuan Pham on 2015/1/19.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//


#import "BSPreviewScrollView.h"
#import "BaseViewController.h"


@protocol ImageScrollViewDelegate <NSObject>
@optional
- (void)removeImage:(int)imageIndex;
- (void)imageScrollViewTapped:(NSInteger)tagIndex;
- (void)loadedAllImage:(NSMutableArray*)imageList tagIndex:(int)tagIndex;
@end


@interface ImageScrollView : UIView<BSPreviewScrollViewDelegate>
@property(nonatomic, weak) BaseViewController       *parentVC;
@property (nonatomic, strong) id<ImageScrollViewDelegate, NSObject> delegate;

@property (strong, nonatomic) BSPreviewScrollView   *scrollViewPreview;
@property (strong, nonatomic) UIPageControl         *pageControl;

@property (nonatomic, strong) NSMutableArray        *imageURLList;
@property (nonatomic, strong) NSMutableArray        *imageList;
@property (nonatomic, strong) NSMutableArray        *scrollImageList;

@property (nonatomic, assign) int                   currentPage;
@property (nonatomic, assign) BOOL                  isEditMode;
@property (nonatomic, assign) BOOL                  isShowExpandImageView;
@property (nonatomic, assign) BOOL                  isShowFullScreenImage;


- (void)settingView;
- (void)reloadView:(NSMutableArray*)imageURLList;
- (void)setSelectedPage:(int)pageIndex;
- (void)updatePageControlIndex:(int)index;

@end

