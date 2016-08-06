//
//  defined.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#ifndef MomentHub_defined_h
#define MomentHub_defined_h


// Utilities
#ifndef IS_IPAD
#define IS_IPAD   ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#endif
#ifndef IS_IPHONE
#define IS_IPHONE   (!IS_IPAD)
#endif
#ifndef IS_IPHONE_5
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#endif

#ifndef IS_IOS7
#define IS_IOS7   [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#endif
#ifndef IS_IOS6
#define IS_IOS6   [[[UIDevice currentDevice] systemVersion] floatValue] >= 6
#endif
#ifndef IS_IOS5
#define IS_IOS5   [[[UIDevice currentDevice] systemVersion] floatValue] >= 5
#endif

// For localization messages
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)
#define RADIANS_TO_DEGREES(x) (x * 180.0 / M_PI)
#define kFadeInTransitionTime           0.3
#define kFadeOutTransitionTime          0.3


#define DefaultThemeColor               UIColorFromRGBValues(25, 165, 152)
#define AppDefaultColor                 UIColorFromRGB(0x48B9E5)
#define DefaultTitleTextColor           UIColorFromRGBValues(86, 90, 92)
#define DefaultDescTextColor            UIColorFromRGBValues(130, 137, 141)



#define DefaultBackgroundColor_Dark             UIColorFromRGBValues(18, 19, 20)
#define DefaultBackgroundColor_Blue             UIColorFromRGBValues(101, 101, 244)
#define DefaultBackgroundColor_Gray             UIColorFromRGBValues(239, 239, 244)
#define DefaultNavigationBackgroundColor_Gray   UIColorFromRGBValues(245, 245, 247)


#define DefaultTourGuideTabBarBackgroundColor_Gray      UIColorFromRGBValues(86, 90, 92)
#define DefaultTourGuideNavigationBackgroundColor_Gray  UIColorFromRGBValues(86, 90, 92)


#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBValues(r,g,b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGBAValues(r,g,b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


// Converting
#define BOOLToInt(value)                            (value == TRUE) ? 1 : 0
#define Int2String(value)                           [@(value) stringValue]
#define Float2String(value)                         [NSString stringWithFormat:@"%.02f", value]
#define Float2StringWithFormat(value, format)       [NSString stringWithFormat:format, value]
#define Object2StringWithFormat(value)              [NSString stringWithFormat:@"%@", value]
#define ConcatString(value1, value2)                [NSString stringWithFormat:@"%@%@", value1, value2]
#define Concat3String(value1, value2, value3)       [NSString stringWithFormat:@"%@%@%@", value1, value2, value3]

#define StatusBarHeight     [UIApplication sharedApplication].statusBarFrame.size.height
#define ScreenWidth         [UIScreen mainScreen].applicationFrame.size.width
#define ScreenHeight        [UIScreen mainScreen].applicationFrame.size.height
#define ViewX(view)         view.frame.origin.x
#define ViewY(view)         view.frame.origin.y
#define ViewWidth(view)     view.frame.size.width
#define ViewHeight(view)    view.frame.size.height



#define NavigationBarColor [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
#define ViewBackgroundColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:243/255.0 alpha:1];
#define TableBorderColor [[UIColor colorWithRed:206/255.0 green:205/255.0 blue:208/255.0 alpha:1] CGColor];
#define TableBackgroundColor [UIColor colorWithRed:236/255.0 green:235/255.0 blue:242/255.0 alpha:1];

#define kColorBorderColor UIColorFromRGBValues(200, 199, 202)
#define kColorGrayTextColor UIColorFromRGBValues(157, 157, 157)
#define kColorDarkGrayTextColor UIColorFromRGBValues(113, 113, 113)
#define kColorBackgroundColor UIColorFromRGBValues(236, 235, 242)
#define kColorLineColor UIColorFromRGBValues(225, 223, 227)


// Display Settings
#define kConstCellHeight 45
#define kCellHorizonalMargin 10

#define kMainViewContentSize 2600
#define kMarginX 10
#define kMarginY 10
#define kMarginContentX 10
#define kMarginContentY 10
#define kHeightLabelDefault 20
#define kHeightHeaderTitle 40
#define kHeightRowDefault 30
#define kHeightButtonDefault 20
#define kTextLineSpacing 5


#define kButtonMarginContentX 25
#define kButtonMarginContentY 25

#define kCFBundleShortVersion @"CFBundleShortVersionString"

#define kNotificationReceived @"notificationReceived"

#define kDateFormaterFull @"yyyy-MM-dd HH:mm:ss"
#define kDateFormater @"yyyy-MM-dd"

#define		MAX_IMAGE_FILE_SIZE                     524288     //0.5MB
#define		MAX_IMAGE_WIDTH_HEIGHT_SIZE             800        //800 pixel
#define		MAX_THUMBNAIL_IMAGE_WIDTH_HEIGHT_SIZE   300        //300 pixel

#define		DEFAULT_TAB							0
#define		INSERT_MESSAGES						10
#define		VIDEO_LENGTH						5
#define		AFDOWNLOAD_TIMEOUT					300
#define		STATUS_LOADING						1
#define		STATUS_FAILED						2
#define		STATUS_SUCCEED						3

#define		COLOR_OUTGOING						HEXCOLOR(0x007AFFFF)
#define		COLOR_INCOMING						HEXCOLOR(0xE6E5EAFF)

#define		SCREEN_WIDTH						[UIScreen mainScreen].bounds.size.width
#define		SCREEN_HEIGHT						[UIScreen mainScreen].bounds.size.height

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]


#define		NSERROR(text, number)				[NSError errorWithDomain:text code:number userInfo:nil]

// DLog will output like NSLog only when the DEBUG variable is set
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog will always output like NSLog
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ULog will show the UIAlertView only when the DEBUG variable is set
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define Error_required_input @"*Required input  "
#define Error_typing_mistake @"*Typing mistake  "
#define ErrorDisplayColor UIColorFromRGBValues(178, 74, 25);

#endif
