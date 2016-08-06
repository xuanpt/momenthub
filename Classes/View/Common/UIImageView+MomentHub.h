//
//  UIImageView+MomentHub.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UIImageView (MomentHub)

- (void)roundedStyle;
- (void)setPlaceholderImage:(NSString*)placeholderImage;
- (void)loadImageWithImageURL:(NSString *)url noImageFile:(NSString*)noImageFile;
- (void)setImageWithPFFile:(PFFile*)pfFile noImageFile:(NSString*)noImageFile loadedImage:(UIImage*)loadedImage;

@end
