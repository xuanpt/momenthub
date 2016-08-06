//
//  SettingViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 7/30/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#import "SettingViewController.h"
#import "ImageScrollView.h"
#import "ProgressHUD.h"
#import "WelcomeViewController.h"
#import "UIImageView+MomentHub.h"

#define CellHeight_Top              150
#define CellHeight_BasicInfo        144
#define CellHeight_Logout           70


@implementation SettingViewController {
    UITableView         *settingsTableView;
    UIImageView         *profileImageView;
}


- (id)init {
    self = [super init];
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_settings"]];
        self.tabBarItem.title = LocStr(@"Settings");
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocStr(@"Settings");
    self.view.backgroundColor = DefaultBackgroundColor_Gray;
    
    [self settingView];
}


- (void)settingView {
    settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ViewHeight(self.view) - self.navigationController.navigationBar.frame.size.height - StatusBarHeight - [[[self tabBarController] tabBar] bounds].size.height) style:UITableViewStylePlain];
    settingsTableView.delegate = self;
    settingsTableView.dataSource = self;
    settingsTableView.backgroundColor = [UIColor clearColor];
    settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingsTableView];
}


#pragma mark - UITableViewDelegate delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return CellHeight_Top;
    if (indexPath.row == 1) return CellHeight_BasicInfo;
    if (indexPath.row == 2) return CellHeight_Logout;
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"SettingViewCellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (indexPath.row == 0) [self settinggCell_Top:cell];
    if (indexPath.row == 1) [self settinggCell_BasicInfo:cell];
    if (indexPath.row == 2) [self settinggCell_Logout:cell];
    
    return cell;
}


- (void)settinggCell_Top:(UITableViewCell*)cell {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, CellHeight_Top - 10)];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor clearColor];
    [cell addSubview:contentView];
    
    
    float yPos = 15;
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ViewWidth(contentView) - 80) / 2, yPos, 80, 80)];
    [profileImageView roundedStyle];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [Util loadImageWithImageURL:[PFUser currentUser][PF_USER_IMAGE] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
        profileImageView.image = image;
    }];
    [contentView addSubview:profileImageView];
    
    profileImageView.userInteractionEnabled = TRUE;
    [profileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageViewTapped)]];
    
    
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
    
    UILabel *nameTitleLablel = [Util createLabelWithDynamicWidth:CGRectMake(10, 0, 0, ViewHeight(nameView)) text:LocStr(@"Full name") textAlignment:NSTextAlignmentLeft
        font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:nameView];
    
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
    
    UILabel *mailTitleLablel = [Util createLabelWithDynamicWidth:CGRectMake(10, 0, 0, ViewHeight(emailView)) text:LocStr(@"Email") textAlignment:NSTextAlignmentLeft
        font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:emailView];
    
    valueTextWidth = ViewWidth(emailView) - (ViewX(mailTitleLablel) + ViewWidth(mailTitleLablel) + 10);
    
    [Util createLabel:CGRectMake(ViewWidth(emailView) - valueTextWidth - 10, 0, valueTextWidth, ViewHeight(emailView)) text:[PFUser currentUser][PF_USER_EMAIL]
        textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:16] textColor:DefaultTitleTextColor parentView:emailView];
}


- (void)settinggCell_Logout:(UITableViewCell*)cell {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, CellHeight_Logout - 20)];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = UIColorFromRGBValues(197, 199, 204).CGColor;
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];
    
    UIButton *logoutButton = [Util createButton:contentView.bounds title:LocStr(@"Log out") parentView:contentView];
    [logoutButton setTitleColor:DefaultTitleTextColor forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor whiteColor];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.layer.borderWidth = 1;
    logoutButton.layer.borderColor = UIColorFromRGBValues(197, 199, 204).CGColor;
}


- (void)logoutButtonClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocStr(@"Are you sure you want to log out ?") delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    actionSheet.tag = 1;
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}


- (void)profileImageViewTapped {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocStr(@"Cancel") destructiveButtonTitle:nil
                                                    otherButtonTitles:LocStr(@"Take Photo"), LocStr(@"Choose Photo"), nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}



#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [PFUser logOut];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[WelcomeViewController alloc] init]];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    } else if (actionSheet.tag == 2) {
        if ([Util getDeviceModel] != DeviceModel_iPad) [self openUIImagePickerController:buttonIndex];
    }
}


- (void)openUIImagePickerController:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *picture    = [Util resizeImage:image width:300 height:300 scale:1];
    UIImage *thumbnail  = [Util resizeImage:image width:150 height:150 scale:1];
    
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(thumbnail, 0.5)];
    [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error == nil) {
            [Util loadImageWithImageURL:fileThumbnail.url noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
                profileImageView.image = image;
            }];
            
            PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 1)];
            
            [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error == nil) {
                    PFUser *user = [PFUser currentUser];
                    user[PF_USER_IMAGE] = filePicture.url;
                    user[PF_USER_THUMBNAIL] = fileThumbnail.url;
                    
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error != nil) [ProgressHUD showError:LocStr(@"Failed to save user data.")];
                    }];
                } else [ProgressHUD showError:LocStr(@"Failed to save profile picture.")];
            }];
        } else [ProgressHUD showError:LocStr(@"Failed to save profile thumbnail.")];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
