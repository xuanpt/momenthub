//
//  UpdateMomentViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 12/26/15.
//  Copyright © 2015 Xuan Pham. All rights reserved.
//

#import "UpdateMomentViewController.h"
#import "AppDelegate.h"
#import "ImageScrollView.h"
#import "UIAlertView+Blocks.h"
#import "ProgressHUD.h"
#import "ScrollImageItem.h"
#import "UITextView+Placeholder.h"


@implementation UpdateMomentViewController {
    UIScrollView        *mainScrollView;
    UIImageView         *defaultImageView;
    ImageScrollView     *imageScrollView;
    UITextView          *momentTitleTextView;
    UIButton            *libraryButton;
    UIButton            *cameraButton;
    UIBarButtonItem     *postButton;
    
    NSMutableArray      *selectedImageList;
    NSMutableDictionary *uploadedImageURLDic;
    NSMutableDictionary *uploadedThumbnailImageURLDic;
    
    PFObject            *momentObj;
    int                 numberOfUploadedImageFile;
}


- (id)init {
    self = [super init];
    
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_camera"]];
        self.tabBarItem.title = @"Update moment";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocStr(@"Update moment");
    self.view.backgroundColor = UIColorFromRGBValues(250, 250, 250);
    
    postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonClicked)];
    self.navigationItem.rightBarButtonItem = postButton;
    postButton.enabled = FALSE;
    
    selectedImageList   = [NSMutableArray array];
    momentObj           = [PFObject objectWithClassName:Moment_Class];
    
    [self settingView];
}


- (void)settingView {
    float viewHeight = ViewHeight(self.view) - [[[self tabBarController] tabBar] bounds].size.height;
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight)];
    [self.view addSubview:mainScrollView];
    
    
    float yPos = 0;
    float imageWidth = ViewWidth(mainScrollView);
    float imageHeight = imageWidth * 240 / 360;
    
    defaultImageView = [Util createImageView:CGRectMake(0, yPos, imageWidth, imageHeight) imageFileName:@"default_no_photo.png" parentView:mainScrollView];
    defaultImageView.userInteractionEnabled = YES;
    [defaultImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(libraryButtonClicked)]];
    
    imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, yPos, ViewWidth(mainScrollView), imageHeight)];
    imageScrollView.parentVC = self;
    imageScrollView.delegate = self;
    imageScrollView.isShowFullScreenImage = TRUE;
    [mainScrollView addSubview:imageScrollView];
    imageScrollView.hidden = TRUE;
    [imageScrollView settingView];
    
    
    yPos += ViewHeight(imageScrollView);
    
    //Create line view
    [Util createView:CGRectMake(0, yPos, ViewWidth(mainScrollView), 1) backgroundColor:UIColorFromRGBValues(222, 223, 224) borderColor:nil parentView:mainScrollView];


    yPos += 1;
    
    UIView *selectionPhotoView = [Util createView:CGRectMake(0, yPos, ViewWidth(mainScrollView), 40) backgroundColor:UIColorFromRGBValues(239, 239, 244) borderColor:nil parentView:mainScrollView];
    
    libraryButton = [Util createButton:CGRectMake(0, 0, ViewWidth(selectionPhotoView) / 2, ViewHeight(selectionPhotoView)) title:LocStr(@"Library")
        parentView:selectionPhotoView];
    libraryButton.titleLabel.font = [UIFont systemFontOfSize:18];
    libraryButton.backgroundColor = [UIColor clearColor];
    [libraryButton setTitleColor:UIColorFromRGBValues(91, 147, 252) forState:UIControlStateNormal];
    [libraryButton addTarget:self action:@selector(libraryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    cameraButton = [Util createButton:CGRectMake(ViewWidth(selectionPhotoView) / 2, 0, ViewWidth(selectionPhotoView) / 2, ViewHeight(selectionPhotoView))
        title:LocStr(@"Camera") parentView:selectionPhotoView];
    cameraButton.titleLabel.font = [UIFont systemFontOfSize:18];
    cameraButton.backgroundColor = [UIColor clearColor];
    [cameraButton setTitleColor:UIColorFromRGBValues(91, 147, 252) forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [Util createView:CGRectMake(ViewWidth(selectionPhotoView) / 2, 0, 1, ViewHeight(selectionPhotoView)) backgroundColor:UIColorFromRGBValues(222, 223, 224)
         borderColor:nil parentView:selectionPhotoView];
    
    
    yPos += ViewHeight(selectionPhotoView);
    
    //Create line view
    [Util createView:CGRectMake(0, yPos, ViewWidth(mainScrollView), 1) backgroundColor:UIColorFromRGBValues(222, 223, 224) borderColor:nil parentView:mainScrollView];
    
    
    yPos += 1;
    
    momentTitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, yPos, ViewWidth(mainScrollView), 60)];
    momentTitleTextView.placeholder = LocStr(@"Write a title...");
    momentTitleTextView.textColor = DefaultTitleTextColor;
    momentTitleTextView.font = [UIFont systemFontOfSize:14];
    momentTitleTextView.scrollEnabled = TRUE;
    momentTitleTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    momentTitleTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:momentTitleTextView.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [mainScrollView addSubview:momentTitleTextView];

    
    yPos += ViewHeight(momentTitleTextView) + 1;
    
    //Create line view
    [Util createView:CGRectMake(0, yPos, ViewWidth(mainScrollView), 1) backgroundColor:UIColorFromRGBValues(222, 223, 224) borderColor:nil parentView:mainScrollView];
    
    mainScrollView.contentSize = CGSizeMake(ViewWidth(mainScrollView), yPos);
}


- (void)libraryButtonClicked {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)cameraButtonClicked {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)postButtonClicked {
    [self uploadMomentPhoto];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [selectedImageList addObject:image];
    [self refreshImageScrollView];
    [imageScrollView setSelectedPage:(int)selectedImageList.count - 1];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)refreshImageScrollView {
    if ([Util isGoodArray:selectedImageList]) {
        postButton.enabled = TRUE;
        imageScrollView.hidden = FALSE;
        defaultImageView.hidden = TRUE;
        
        imageScrollView.imageList = selectedImageList;
        imageScrollView.isEditMode = TRUE;
        [imageScrollView settingView];
        
        if (selectedImageList.count == 5) {
            libraryButton.enabled = FALSE;
            cameraButton.enabled = FALSE;
            [libraryButton setTitleColor:UIColorFromRGBValues(201, 201, 201) forState:UIControlStateNormal];
            [cameraButton setTitleColor:UIColorFromRGBValues(201, 201, 201) forState:UIControlStateNormal];
        } else {
            libraryButton.enabled = TRUE;
            cameraButton.enabled = TRUE;
            [libraryButton setTitleColor:UIColorFromRGBValues(91, 147, 252) forState:UIControlStateNormal];
            [cameraButton setTitleColor:UIColorFromRGBValues(91, 147, 252) forState:UIControlStateNormal];
        }
    } else {
        imageScrollView.hidden = TRUE;
        defaultImageView.hidden = FALSE;
        postButton.enabled = FALSE;
    }
}


#pragma mark - ImageScrollViewDelegate delegate
- (void)removeImage:(int)imageIndex {
    [selectedImageList removeObjectAtIndex:imageIndex];
    [self refreshImageScrollView];
    if (selectedImageList.count > 0) [imageScrollView setSelectedPage:(int)selectedImageList.count - 1];
}



- (void)uploadMomentPhoto {
    UIImage *processedImage;
    UIImage *processedThumbnailImage;
    PFFile  *photoFile;
    PFFile  *thumbnailPhotoFile;
    
    int photoIndex = 1;
    numberOfUploadedImageFile = 0;
    uploadedImageURLDic            = [NSMutableDictionary dictionary];
    uploadedThumbnailImageURLDic   = [NSMutableDictionary dictionary];
    
    [ProgressHUD show:LocStr(@"Uploading photos")];
    
    for (UIImage *image in selectedImageList) {
        processedImage          = [Util processResizeCompressImage:image maxWidthHeight:MAX_IMAGE_WIDTH_HEIGHT_SIZE];
        processedThumbnailImage = [Util processResizeCompressImage:image maxWidthHeight:MAX_THUMBNAIL_IMAGE_WIDTH_HEIGHT_SIZE];
        
        photoFile           = [PFFile fileWithName:[NSString stringWithFormat:@"photo_%d.jpg",   photoIndex] data:UIImageJPEGRepresentation(processedImage, 1)];
        thumbnailPhotoFile  = [PFFile fileWithName:[NSString stringWithFormat:@"t_photo_%d.jpg", photoIndex] data:UIImageJPEGRepresentation(processedThumbnailImage, 1)];
        
        [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                [uploadedImageURLDic setObject:photoFile.url forKey:[NSString stringWithFormat:@"photo_%d", photoIndex]];
                numberOfUploadedImageFile++;
                [self saveMoment];
            } else {
                [ProgressHUD dismiss];
                [ProgressHUD showError:LocStr(@"Failed to upload photo. Please try again.")];
            }
        }];
        
        
        [thumbnailPhotoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                [uploadedThumbnailImageURLDic setObject:thumbnailPhotoFile.url forKey:[NSString stringWithFormat:@"t_photo_%d", photoIndex]];
                numberOfUploadedImageFile++;
                [self saveMoment];
            } else {
                [ProgressHUD dismiss];
                [ProgressHUD showError:LocStr(@"Failed to upload photo. Please try again.")];
            }
        }];
        
        photoIndex++;
    }
}


- (void)saveMoment {
    if (numberOfUploadedImageFile == selectedImageList.count * 2) {
        [ProgressHUD dismiss];
        
        momentObj[UserID_Field]         = [PFUser currentUser].objectId;
        momentObj[LastUpdatedAt_Field]  =  @([[NSDate date] timeIntervalSince1970]);
        
        for (int i = 0; i < selectedImageList.count; i++) {
            momentObj[[NSString stringWithFormat:@"Photo%d", i + 1]] = [uploadedImageURLDic objectForKey:[NSString stringWithFormat:@"photo_%d", i + 1]];
            momentObj[[NSString stringWithFormat:@"ThumbnailPhoto%d", i + 1]] = [uploadedThumbnailImageURLDic objectForKey:[NSString stringWithFormat:@"t_photo_%d", i + 1]];
        }
        
        if ([Util isGoodString:momentTitleTextView.text]) momentObj[Title_Field] = momentTitleTextView.text;
        
        [ProgressHUD show:LocStr(@"Posting your moment")];
        
        [momentObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [ProgressHUD dismiss];
            
            if (error == nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MOMENT_CREATED object:nil userInfo:nil];
                [self resetView];
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeTabBarSelectedIndex:0];
            } else {
                [Util processError:error alertMsg:LocStr(@"An error occurred while saving info. Please try again.")];
            }
        }];
    }
}


- (void)resetView {
    selectedImageList   = [NSMutableArray array];
    momentObj           = [PFObject objectWithClassName:Moment_Class];
    momentTitleTextView.text = nil;
    [self refreshImageScrollView];
}

@end
