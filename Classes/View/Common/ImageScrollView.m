//  SchoolImageScrollView.m
//  MomentHub
//
//  Created by Xuan Pham on 2015/1/19.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+MomentHub.h"
#import "ImageViewController.h"
#import "ScrollImageItem.h"

@implementation ImageScrollView {
    NSMutableArray *viewList;
}


- (void)settingView {
    self.backgroundColor = [UIColor clearColor];
    
    viewList = [NSMutableArray array];
    
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
	//Setting scroll images list
    ScrollImageItem *scrollImageItem;
    
    if ([Util isGoodArray:_imageURLList]) {
        _scrollImageList = [NSMutableArray array];
        
        for (int i = 0; i < _imageURLList.count; i++) {
            scrollImageItem = [[ScrollImageItem alloc] initWithImageURL:i imageURL:_imageURLList[i]];
            [_scrollImageList addObject:scrollImageItem];
        }
        
        _imageList = [NSMutableArray array];
    } else if ([Util isGoodArray:_imageList]) {
        _scrollImageList = [NSMutableArray array];
        
        for (int i = 0; i < _imageList.count; i++) {
            scrollImageItem = [[ScrollImageItem alloc] initWithImageObj:i imageObj:_imageList[i]];
            [_scrollImageList addObject:scrollImageItem];
        }
    }
    
	self.scrollViewPreview = [[BSPreviewScrollView alloc] initWithFrameAndPageSize:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                                          pageSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.scrollViewPreview.parentView = self;
	self.scrollViewPreview.delegate = self;
	[self addSubview:self.scrollViewPreview];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 10);
    self.pageControl.numberOfPages = _scrollImageList.count;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    self.pageControl.currentPageIndicatorTintColor = DefaultThemeColor;
    [self addSubview:self.pageControl];
    
    [self createViewList];
}


- (void)createViewList {
    UIImageView *imageView;
    UIImageView *expandImageView;
    UIButton    *removeButton;
    
    ScrollImageItem *scrollImageItem;
    
    for (int i = 0; i < _scrollImageList.count; i++) {
        scrollImageItem = _scrollImageList[i];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
        imageView.tag = i;
        
        if (scrollImageItem.itemType == ScrollImageItemType_ImageURL) {
            [Util loadImageWithImageURL:scrollImageItem.imageURL noImageFile:@"no-image-available.jpg" completed:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                    [_imageList addObject:image];
                    if (_imageList.count == _imageURLList.count) {
                        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(loadedAllImage:tagIndex:)]) {
                            [self.delegate loadedAllImage:_imageList tagIndex:(int)self.tag];
                        }
                    }
                });
            }];
        } else if (scrollImageItem.itemType == ScrollImageItemType_ImageObj) {
            imageView.image = scrollImageItem.imageObj;
        }
        
        if (_isShowExpandImageView == TRUE) {
            expandImageView = [Util createImageView:CGRectMake(5, 5, 20, 20) imageFileName:@"icon_expand.png" parentView:imageView];
            expandImageView.userInteractionEnabled = YES;
            expandImageView.tag = i;
            [expandImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandImageViewTapped:)]];
        }
        
        if (self.isEditMode == TRUE) {
            removeButton = [Util createImageButton:CGRectMake(ViewWidth(imageView) - 40, 5, 30, 30) imageFileName:@"icon_delete.png"
                                                  parentView:imageView];
            removeButton.tag = i;
            [removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [viewList addObject:imageView];
    }
}


- (void)reloadView:(NSMutableArray*)imageURLList {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    self.imageURLList = imageURLList;
    [self settingView];
}


#pragma mark BSPreviewScrollViewDelegate methods
- (int)itemCount:(BSPreviewScrollView*)scrollView {
    return (int)_scrollImageList.count;
}


- (UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index {
    return viewList[index];
}


- (void)removeButtonClicked:(UIButton*)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(removeImage:)]) {
        [self.delegate removeImage:(int)sender.tag];
    }
}


- (void)setSelectedPage:(int)pageIndex {
    self.scrollViewPreview.selectedPageIndex = pageIndex;
}


- (void)updatePageControlIndex:(int)index {
    self.currentPage = index;
    self.pageControl.currentPage = index;
}


- (void)imageViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    if (_isShowFullScreenImage == TRUE) {
        UIImageView *imageView = (UIImageView *)viewList[gestureRecognizer.view.tag];
        ImageViewController *imageViewController = [[ImageViewController alloc] init];
        imageViewController.image = imageView.image;
        [self.parentVC presentViewController:imageViewController animated:YES completion:nil];
    } else {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imageScrollViewTapped:)]) {
            [self.delegate imageScrollViewTapped:self.tag];
        }
    }
}


- (void)expandImageViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    UIImageView *imageView = (UIImageView *)viewList[gestureRecognizer.view.tag];
    ImageViewController *imageViewController = [[ImageViewController alloc] init];
    imageViewController.image = imageView.image;
    [self.parentVC presentViewController:imageViewController animated:YES completion:nil];
}

@end
