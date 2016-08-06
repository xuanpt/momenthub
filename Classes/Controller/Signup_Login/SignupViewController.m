//
//  SignupViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 17/12/2015.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.


#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "SignupViewController.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "WelcomeViewController.h"


@implementation SignupViewController {
    UITextField *emailTextField;
    UITextField *paswwordTextField;
    UIImageView *passengerImageView;
    UIImageView *driverImageView;
    
    BOOL        isViewMovedUp;
    int         moveUpHeight;
}


- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self settingView];
}


- (void)settingView {
    moveUpHeight = 200;
    if      ([Util getDeviceModel] == DeviceModel_6Plus)    moveUpHeight = 90;
    else if ([Util getDeviceModel] == DeviceModel_6)        moveUpHeight = 130;
    else if ([Util getDeviceModel] == DeviceModel_iPad)     moveUpHeight = 70;
    
    
    float yPos = StatusBarHeight + 10;
    
    [Util createLabel:CGRectMake(0, yPos, ScreenWidth, 20) text:LocStr(@"SIGN UP") textAlignment:NSTextAlignmentCenter
                 font:[UIFont fontWithName:@"Gill Sans" size:17] textColor:[UIColor whiteColor] parentView:self.view];
    
    [self createBackButton:TRUE];
    
    
    yPos += 35;
    
    UIButton *signupWithFacebookButton = [Util createButton:CGRectMake(0, yPos, ScreenWidth, 45) title:LocStr(@"Sign up with Facebook") parentView:self.view];
    signupWithFacebookButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    signupWithFacebookButton.titleLabel.font = [UIFont systemFontOfSize:16];
    signupWithFacebookButton.layer.cornerRadius = 0;
    signupWithFacebookButton.backgroundColor = UIColorFromRGBValues(59, 89, 149);
    [signupWithFacebookButton addTarget:self action:@selector(signupWithFacebookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [Util createImageView:CGRectMake(20, 10, 30 * 47 / 99, 30) imageFileName:@"facebook_icon.png" parentView:signupWithFacebookButton];
    
    
    yPos += 65;
    
    UILabel *orLabel = [Util createLabelWithDynamicWidth:CGRectMake(0, yPos, 0, 20) text:LocStr(@"or with e-mail") textAlignment:NSTextAlignmentCenter
                                                    font:[UIFont fontWithName:@"GillSans-Italic" size:16] textColor:UIColorFromRGBValues(172, 173, 178) parentView:self.view];
    [Util setViewXPos:orLabel xPos:(ScreenWidth - ViewWidth(orLabel)) / 2];
    
    [Util createView:CGRectMake(ViewX(orLabel) - 65, yPos + 11, 50, 1.5) backgroundColor:UIColorFromRGBValues(46, 47, 51) borderColor:nil parentView:self.view];
    [Util createView:CGRectMake(ViewX(orLabel) + ViewWidth(orLabel) + 15, yPos + 11, 50, 1.5) backgroundColor:UIColorFromRGBValues(46, 47, 51) borderColor:nil
          parentView:self.view];
    
    
    yPos += 35;
    float centerXPoint = 25;
    float imageWidth = 15 * 45 / 32;
    
    UIView *emailView = [Util createView:CGRectMake(0, yPos, ScreenWidth, 45) backgroundColor:UIColorFromRGBValues(28, 28, 31) borderColor:nil parentView:self.view];
    
    [Util createImageView:CGRectMake(centerXPoint - (imageWidth / 2), 15, imageWidth, 15) imageFileName:@"email_icon.png" parentView:emailView];
    
    emailTextField = [Util createInputField:CGRectMake(50, 0, ViewWidth(emailView) - 50, ViewHeight(emailView)) placeholderText:LocStr(@"Email")
                                 parentView:emailView];
    emailTextField.delegate = self;
    emailTextField.font = [UIFont systemFontOfSize:17];
    emailTextField.textColor = UIColorFromRGBValues(173, 174, 179);
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:emailTextField.placeholder
                                                                           attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValues(173, 174, 179)}];
    
    
    yPos += 45;
    
    [Util createView:CGRectMake(0, yPos, ScreenWidth, 1) backgroundColor:UIColorFromRGBValues(34, 35, 38) borderColor:nil parentView:self.view];
    
    yPos += 1;
    imageWidth = 15 * 33 / 38;
    
    UIView *passwordView = [Util createView:CGRectMake(0, yPos, ScreenWidth, 45) backgroundColor:UIColorFromRGBValues(28, 28, 31) borderColor:nil parentView:self.view];
    
    [Util createImageView:CGRectMake(centerXPoint - (imageWidth / 2), 15, imageWidth, 15) imageFileName:@"password_icon.png" parentView:passwordView];
    
    paswwordTextField = [Util createInputField:CGRectMake(50, 0, ViewWidth(passwordView) - 50, ViewHeight(passwordView)) placeholderText:LocStr(@"Password")
                                    parentView:passwordView];
    paswwordTextField.delegate = self;
    paswwordTextField.secureTextEntry = TRUE;
    paswwordTextField.font = [UIFont systemFontOfSize:17];
    paswwordTextField.textColor = UIColorFromRGBValues(173, 174, 179);
    paswwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:paswwordTextField.placeholder
                                                                              attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValues(173, 174, 179)}];
    
    yPos += 45;
    
    UIButton *signupButton = [Util createButton:CGRectMake(0, yPos, ScreenWidth, 45) title:LocStr(@"SIGN UP") parentView:self.view];
    signupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    signupButton.titleLabel.font = [UIFont fontWithName:@"GillSans" size:17];
    signupButton.layer.cornerRadius = 0;
    signupButton.backgroundColor = UIColorFromRGBValues(40, 165, 81);
    [signupButton addTarget:self action:@selector(signupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    yPos += 55;
    [Util createLabel:CGRectMake(10, yPos, ScreenWidth - 20, 20) text:LocStr(@"By signing up, you agree to MomentHub's Terms and conditions of Use and Privacy Policy") textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12] textColor:UIColorFromRGBValues(173, 174, 179) parentView:self.view];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dismissKeyboard {
    [emailTextField     resignFirstResponder];
    [paswwordTextField  resignFirstResponder];
    if (isViewMovedUp == TRUE) [self moveView];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (isViewMovedUp == FALSE) [self moveView];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (isViewMovedUp == TRUE) [self moveView];
    return YES;
}


- (void)moveView {
    float newYPos = (isViewMovedUp == FALSE) ? ViewY(self.view) - moveUpHeight : ViewY(self.view) + moveUpHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [Util setViewYPos:self.view yPos:newYPos];
    [UIView commitAnimations];
    
    isViewMovedUp = !isViewMovedUp;
}


- (void)signupButtonClicked {
    [self dismissKeyboard];
    
    NSString *email     = [emailTextField.text lowercaseString];
    NSString *password  = paswwordTextField.text;

    if ([[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [ProgressHUD showError:LocStr(@"Please enter an email address")];
        [emailTextField becomeFirstResponder];
        return;
    }
    
    if ([Util validateEmail:email] != TRUE) {
        [ProgressHUD showError:LocStr(@"Please enter a valid email address")];
        [emailTextField becomeFirstResponder];
        return;
    }
    
    if ([[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [ProgressHUD showError:LocStr(@"Please enter your password")];
        [paswwordTextField becomeFirstResponder];
        return;
    }
    

    [ProgressHUD show:@"Signing up..." Interaction:NO];
    
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
         if (user != nil) {
             [ProgressHUD showError:LocStr(@"The specified email is already in use. Please specify a different one.")];
             [PFUser logOut];
         }
         else [self signupWithEmail];
     }];
}


- (void)signupWithEmail {
    NSString *email     = [emailTextField.text lowercaseString];
    NSString *password  = paswwordTextField.text;
    
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    user[PF_USER_EMAIL] = email;
    user[PF_USER_SIGNUP_TYPE] = [NSNumber numberWithInt:0];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (error == nil) [self userLoggedIn:user];
         else [ProgressHUD showError:LocStr(@"An error occurred while signing up. Please try again.")];
     }];
}


- (void)signupWithFacebookButtonClicked {
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
	[PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
		if (user != nil) {
            if (user[PF_USER_FACEBOOKID] != nil) {
				[ProgressHUD showError:LocStr(@"The specified Facebook account is already in use. Please specify a different one.")];
                [PFUser logOut];
            } else {
                [self requestFacebook:user];
            }
		} else [self signupWithFacebookFailed];
	}];
}


- (void)requestFacebook:(PFUser *)user {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error == nil) {
             NSDictionary *userData = (NSDictionary *)result;
             [self requestFacebookPicture:user UserData:userData];
         } else [self signupWithFacebookFailed];
     }];
}


- (void)requestFacebookPicture:(PFUser *)user UserData:(NSDictionary *)userData {
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:link] options:0 progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         if (image != nil) {
             [self saveFacebookPicture:user UserData:userData Image:image];
         } else [self signupWithFacebookFailed];
     }];
}


- (void)saveFacebookPicture:(PFUser *)user UserData:(NSDictionary *)userData Image:(UIImage *)image {
    UIImage *picture    = [Util resizeImage:image width:300 height:300 scale:1];
    UIImage *thumbnail  = [Util resizeImage:image width:150 height:150 scale:1];
    
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(thumbnail, 0.5)];
    [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (error == nil) {
             PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 1)];
             [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                  if (error == nil) {
                      [self saveFacebookUser:user UserData:userData Picture:filePicture.url Thumbnail:fileThumbnail.url];
                  } else [self signupWithFacebookFailed];
              }];
         } else [self signupWithFacebookFailed];
     }];
}


- (void)saveFacebookUser:(PFUser *)user UserData:(NSDictionary *)userData Picture:(NSString *)pictureUrl Thumbnail:(NSString *)thumbnailUrl {
    NSString *name = userData[@"name"];
    NSString *email = userData[@"email"];

    if (name == nil) name = @"";
    if (email == nil) email = @"";
    
    user[PF_USER_EMAIL] = email;
    user[PF_USER_FULLNAME] = name;
    user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
    user[PF_USER_FACEBOOKID] = userData[@"id"];
    user[PF_USER_IMAGE] = pictureUrl;
    user[PF_USER_THUMBNAIL] = thumbnailUrl;
    user[PF_USER_SIGNUP_TYPE] = [NSNumber numberWithInt:1];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (error == nil) [self userLoggedIn:user];
         else [self signupWithFacebookFailed];
     }];
}


- (void)userLoggedIn:(PFUser *)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGGED_IN object:nil];
    [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@, %@!", LocStr(@"Welcome"), user[PF_USER_FULLNAME]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signupWithFacebookFailed {
    [PFUser logOut];
    [ProgressHUD showError:LocStr(@"An error occurred while getting Facebook account info. Please try again.")];
}

@end
