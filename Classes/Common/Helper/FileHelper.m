//
//  FileHelper.m
//  MomentHub
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import "FileHelper.h"
#import "Util.h"


@implementation FileHelper {
    dispatch_queue_t _write_file_serial_queue;
    dispatch_queue_t _load_file_serial_queue;
}


+ (FileHelper *)sharedInstance {
    static FileHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FileHelper alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}


- (NSString*)getLocalFilePathFromImageURL:(NSString*)imageURL {
    //Ex: http://files.parsetfss.com/f0e70754-6ef0-43c2-9103-6a8a0795454f/tfss-a553e1ea-5925-4734-b41f-a1846ee204fc-Amherst_College_buildings_-_IMG_6512%20copy.JPG
    
    NSRange range = [imageURL rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location == NSNotFound) return  nil;
    
    NSString *fileName = [imageURL substringFromIndex:range.location + 1];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsPath = [documentsPath stringByAppendingString:@"/files"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return [documentsPath stringByAppendingPathComponent:fileName];
}


- (BOOL)hasImageFileWithURL:(NSString*)imageURL {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getLocalFilePathFromImageURL:imageURL]];
}


- (void)saveImageFile:(UIImage*)image withImageURL:(NSString *)imageURL {
    @autoreleasepool {
        NSString *fileNameFullPath = [self getLocalFilePathFromImageURL:imageURL];
        BOOL isJpegImage = ([[fileNameFullPath lowercaseString] rangeOfString:@".jpg"].location != NSNotFound ||
                            [[fileNameFullPath lowercaseString] rangeOfString:@".jpeg"].location != NSNotFound) ? TRUE : FALSE;
        
        NSData *data = (isJpegImage) ? UIImageJPEGRepresentation(image, 1.0) : UIImagePNGRepresentation(image);
        CFDataRef imageDataRef = (__bridge_retained CFDataRef) data;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:fileNameFullPath contents:data attributes:nil];
        data = nil;
        CFRelease(imageDataRef);
        fileManager = nil;
    }
}


- (void)loadLocalImageFromImageURL:(NSString*)imageURL completed:(void (^)(UIImage *image))completed {
    @autoreleasepool {
        NSString *fileName = [self getLocalFilePathFromImageURL:imageURL];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            NSData *data = [NSData dataWithContentsOfFile:fileName];
            completed([UIImage imageWithData:data]);
            data = nil;
        } else {
            completed(nil);
        }
    }
}

@end
