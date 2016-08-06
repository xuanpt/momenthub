//
//  LoginViewController.m
//  MomentHub
//
//  Created by Xuan Pham on 17/12/2015.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.


#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "ProgressHUD.h"
#import "WelcomeViewController.h"
#import "LoginViewController.h"


@implementation LoginViewController {    
    UITextField *emailTextField;
    UITextField *paswwordTextField;
}


- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self settingView];
}


- (void)settingView {
    float yPos = StatusBarHeight + 10;
    
    [Util createLabel:CGRectMake(0, yPos, ScreenWidth, 20) text:LocStr(@"LOG IN") textAlignment:NSTextAlignmentCenter font:[UIFont fontWithName:@"Gill Sans" size:17]
            textColor:[UIColor whiteColor] parentView:self.view];
    
    [self createBackButton:TRUE];
    
    
    yPos += 35;
    
    UIButton *facebookLoginButton = [Util createButton:CGRectMake(0, yPos, ScreenWidth, 45) title:LocStr(@"Log in with Facebook") parentView:self.view];
    facebookLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    facebookLoginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    facebookLoginButton.layer.cornerRadius = 0;
    facebookLoginButton.backgroundColor = UIColorFromRGBValues(59, 89, 149);
    [facebookLoginButton addTarget:self action:@selector(facebookLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [Util createImageView:CGRectMake(20, 10, 30 * 47 / 99, 30) imageFileName:@"facebook_icon.png" parentView:facebookLoginButton];
    
    
    yPos += 65;
    
    UILabel *orLabel = [Util createLabelWithDynamicWidth:CGRectMake(0, yPos, 0, 20) text:LocStr(@"or") textAlignment:NSTextAlignmentCenter
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
    
    emailTextField = [Util createInputField:CGRectMake(50, 0, ViewWidth(emailView) - 50, ViewHeight(emailView)) placeholderText:LocStr(@"Email") parentView:emailView];
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
    paswwordTextField.secureTextEntry = TRUE;
    paswwordTextField.font = [UIFont systemFontOfSize:17];
    paswwordTextField.textColor = UIColorFromRGBValues(173, 174, 179);
    paswwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:paswwordTextField.placeholder
                                                                              attributes:@{NSForegroundColorAttributeName:UIColorFromRGBValues(173, 174, 179)}];
    
    
    yPos += 45;
    
    UIButton *loginButton = [Util createButton:CGRectMake(0, yPos, ScreenWidth, 45) title:LocStr(@"LOG IN") parentView:self.view];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginButton.titleLabel.font = [UIFont fontWithName:@"GillSans" size:17];
    loginButton.layer.cornerRadius = 0;
    loginButton.backgroundColor = UIColorFromRGBValues(40, 165, 81);
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [paswwordTextField resignFirstResponder];
}


- (void)loginButtonClicked {
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

    
    [ProgressHUD show:LocStr(@"Logging in...") Interaction:NO];
    
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
         if (user != nil) {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGGED_IN object:nil];
             [self dismissViewControllerAnimated:YES completion:nil];
         } else [ProgressHUD showError:LocStr(@"Your email and password do not match")];
     }];
}


- (void)facebookLoginButtonClicked {
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
	[PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
		if (user != nil) {
			if (user[PF_USER_FACEBOOKID] != nil) {
				[self userLoggedIn:user];
            } else [ProgressHUD showError:LocStr(@"The account related with your Facebook does not exist, please sign up first.")];
		} else [ProgressHUD showError:LocStr(@"An error occurred while getting Facebook account info. Please try again.")];
	}];
}


- (void)userLoggedIn:(PFUser *)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGGED_IN object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
