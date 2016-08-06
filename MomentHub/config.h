//
//  config.h
//  MomentHub
//
//  Created by Xuan Pham on 7/29/16.
//  Copyright (c) 2016 Xuan Pham. All rights reserved.
//

#ifndef MomentHub_config_h
#define MomentHub_config_h


//================================ SERVER - ACCESS POINT CONSTANTS DEFINITION =====================
#define kParseApplicationID                 @"0NKkeWyIATO3HYEjC4du93GlbVJtQfPZ7FsoCCrn"
#define kParseClientKey                     @"lXF08dQJuDtQACmZyx6uQHSFhvHFZYi6GHcW00so"
#define kParseAPIKey                        @"Qor0QIBkVokd2PAo9QCLewSMdPhZ0DUdivHDT3qZ"
#define kParseMasterKey                     @"C1I45JLqcAPEOCj7mbeMFknaj4deBkAoq8sYIsW5"

#define kAPIBaseURL                         @"http://52.21.247.29/api/momenthub/api.php"

#define kParseAPIBaseURL                    @"https://api.parse.com"
#define kParseAPIMatching                   @"/1/functions/match"
#define kParseAPIUploadFile                 @"/1/files/"

#define kParseApplicationIDHeader           @"X-Parse-Application-Id"
#define kParseAPIKeyHeader                  @"X-Parse-REST-API-Key"
#define kParseMasterKeyHeader               @"X-Parse-Master-Key"

#define kRequestAuthUserNameKey             @"requestauthuser"
#define kRequestAuthPasswordKey             @"requestauthpwd"
#define kRequestAuthUserNameValue           @"MomentHubAPI_rau"
#define kRequestAuthPasswordValue           @"MomentHubAPI_rap"

#define kAuthHeaderUsername                 @"admin"
#define kAuthHeaderPassword                 @"password"
#define kAPIHeaderMomentHubUUID             @"X-MomentHubUUID"
#define kAPIHeaderMomentHubToken            @"X-MomentHubToken"
#define kAPIHeaderDeviceType                @"X-DeviceType"
#define kAPIHeaderDeviceID                  @"X-DeviceID"

#define kHTTPContentType                    @"Content-Type"
#define kHTTPContentLength                  @"Content-Length"
#define kAuthorization                      @"Authorization"

#define kHTTPAccept                         @"Accept"
#define kHTTPPost                           @"POST"
#define kHTTPGet                            @"GET"
#define kHTTPDelete                         @"DELETE"
#define IGNORE_ALL_CACHE                    NO
#define CACHE_CONTROL_MAX_AGE               @"max-age=60"

#define kHTTPContentType_ApplicationJson    @"application/json"
#define kHTTPContentType_ImageJpeg          @"image/jpeg"


//================================ APP CONSTANTS DEFINITION =======================================
#define kCurrentViewMode                    @"CurrentViewMode"
#define kCurrentLanguage                    @"CurrentLanguage"
#define kCurrentCurrency                    @"CurrentCurrency"

#define kLoginEmailAddress                  @"LoginEmailAddress"
#define kLoginPasssword                     @"LoginPasssword"

#define kLoginFacebookID                    @"LoginFacebookID"
#define kLoginFacebookAccessToken           @"LoginFacebookAccessToken"

#define kLoginUserType                      @"LoginUserType"
#define kCurrentFinishedRegistrationStep    @"CurrentFinishedRegistrationStep"

#define kDeviceIdPref                       @"deviceid_pref"
#define kAuthenticatedPref                  @"authenticated_pref"
#define kAccessTokenPref                    @"accesstoken_pref"
#define kLoginIdPref                        @"login_id_pref"
#define kDeviceTokenPref                    @"devicetoken_pref"


//================================ DB CONSTANTS DEFINITION ========================================
//================================ MOMENT CLASS ===================================================
#define Moment_Class                            @"Moment"
#define UserID_Field                            @"UserID"
#define Title_Field                             @"Title"
#define Photo1_Field                            @"Photo1"
#define Photo2_Field                            @"Photo2"
#define Photo3_Field                            @"Photo3"
#define Photo4_Field                            @"Photo4"
#define Photo5_Field                            @"Photo5"
#define NumberOfLikes_Field                     @"NumberOfLikes"
#define NumberOfComments_Field                  @"NumberOfComments"
#define LastUpdatedAt_Field                     @"LastUpdatedAt"

//================================ USER CLASS =====================================================
#define PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define	PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define	PF_INSTALLATION_USER				@"user"					//	Pointer to User Class
#define	PF_USER_CLASS_NAME					@"_User"				//	Class name
#define	PF_USER_OBJECTID					@"objectId"				//	String

#define	PF_USER_SIGNUP_TYPE                 @"SignupType"           //0:By email; 1: By Facebook
#define	PF_USER_FULLNAME					@"FullName"
#define	PF_USER_USERNAME					@"username"
#define	PF_USER_PASSWORD					@"password"
#define	PF_USER_EMAIL						@"email"
#define	PF_USER_FACEBOOKID					@"FacebookID"
#define	PF_USER_FULLNAME_LOWER				@"FullNameLower"
#define	PF_USER_INTRODUCTION                @"Introduction"
#define	PF_USER_IMAGE                       @"Image"
#define	PF_USER_THUMBNAIL					@"Thumbnail"


#define	NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define	NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define	NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"
#define NOTIFICATION_MOMENT_CREATED         @"NCMomentCreated"


typedef NS_ENUM(int, ScrollImageItemType) {
    ScrollImageItemType_ImageURL = 0,
    ScrollImageItemType_ImageObj
};


#endif
