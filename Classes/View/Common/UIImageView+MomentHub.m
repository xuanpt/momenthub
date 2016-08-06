//
//  UIImageView+MomentHub.m
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UIImageView+MomentHub.h"
#import "FileHelper.h"
#import "Util.h"

@implementation UIImageView (MomentHub)

- (void)roundedStyle {
    self.layer.cornerRadius = floorf(self.frame.size.width/2.0);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}


- (void)setPlaceholderImage:(NSString*)placeholderImage {
    self.image = [UIImage imageNamed:placeholderImage];
}


- (void)setImageWithPFFile:(PFFile*)pfFile noImageFile:(NSString*)noImageFile loadedImage:(UIImage*)loadedImage {
    if (loadedImage != nil) self.image = loadedImage;
    else {
        if (pfFile != nil) {
            [pfFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    self.image = [UIImage imageWithData:data];
                } else {
                    self.image = [UIImage imageNamed:noImageFile];
                }
            }];
        } else {
            self.image = [UIImage imageNamed:noImageFile];
        }
    }
}


- (void)loadImageWithImageURL:(NSString*)imageURL noImageFile:(NSString*)noImageFile {
    [Util loadImageWithImageURL:imageURL noImageFile:noImageFile completed:^(UIImage *image) {
        self.image = image;
    }];
}

@end
