//
//  ImageViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//


#import "ImageViewController.h"
#import "UIAlertView+Blocks.h"


@implementation ImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.scrollEnabled = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScrollViewTwoFingerTapped:)];
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [self.mainScrollView addGestureRecognizer:twoFingerTapGesture];
    [self.mainScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScrollViewTapped:)]];

    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = (CGRect){.origin = CGPointMake(0.0f, 0.0f), .size = self.image.size};
    [self.mainScrollView addSubview:self.imageView];
    
    self.mainScrollView.contentSize = self.image.size;
    
    [self createBackButton];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.mainScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.mainScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.mainScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.mainScrollView.minimumZoomScale = minScale;
    self.mainScrollView.maximumZoomScale = 4.0f;
    self.mainScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.view.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}


- (void)createBackButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeButton.frame = CGRectMake(0, 0, 60, 60);
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}


- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


- (void)mainScrollViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [UIAlertView showWithTitle:@""
                       message:LocStr(@"Do you want to save this photo to Photo Library ?")
             cancelButtonTitle:LocStr(@"No")
             otherButtonTitles:@[LocStr(@"Yes")]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == 1) {
                              UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
                          }
                      }];
}


- (void)mainScrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    CGFloat newZoomScale = self.mainScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.mainScrollView.minimumZoomScale);
    [self.mainScrollView setZoomScale:newZoomScale animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

@end
