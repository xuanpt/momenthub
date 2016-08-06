//
//  WelcomeView.m
//  MomentHub
//
//  Created by Xuan Pham on 17/12/2015.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.


#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"


@implementation WelcomeViewController


- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    
    [Util createImageView:self.view.bounds imageFileName:@"splash.png" parentView:self.view];
    
    float yPos = (ScreenHeight + StatusBarHeight) / 2 + 30;
    
    [Util createLabel:CGRectMake(0, yPos, ScreenWidth, 70) text:@"MomentHub" textAlignment:NSTextAlignmentCenter
             fontSize:30 textColor:[UIColor whiteColor] parentView:self.view];
    
    
    yPos += 70;
    [Util createLabel:CGRectMake(0, yPos, ScreenWidth, 20) text:LocStr(@"Amazing place to share your moments")
        textAlignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] parentView:self.view];
    
    
    yPos = ScreenHeight + StatusBarHeight - 50;
            
    UIButton *loginButton = [Util createButton:CGRectMake(0, yPos, ScreenWidth / 2, 50) title:LocStr(@"LOG IN") parentView:self.view];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginButton.titleLabel.font = [UIFont fontWithName:@"Gill Sans" size:18];
    loginButton.layer.cornerRadius = 0;
    loginButton.backgroundColor = UIColorFromRGBValues(33, 34, 37);
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *signupButton = [Util createButton:CGRectMake(ScreenWidth / 2, yPos, ScreenWidth / 2, 50) title:LocStr(@"SIGN UP") parentView:self.view];
    signupButton.layer.cornerRadius = 0;
    signupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    signupButton.titleLabel.font = [UIFont fontWithName:@"Gill Sans" size:18];
    signupButton.backgroundColor = UIColorFromRGBValues(42, 182, 89);
    [signupButton addTarget:self action:@selector(signupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}


- (void)loginButtonClicked {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}


- (void)signupButtonClicked {
    SignupViewController *signupViewController = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

@end
