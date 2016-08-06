//
//  FileHelper.h
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileHelper : NSObject

+ (FileHelper *)sharedInstance;

- (BOOL)hasImageFileWithURL:(NSString*)imageURL;
- (void)saveImageFile:(UIImage*)image withImageURL:(NSString *)imageURL;
- (void)loadLocalImageFromImageURL:(NSString*)imageURL completed:(void (^)(UIImage *image))completed;
    
@end
