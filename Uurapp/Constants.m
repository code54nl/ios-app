//
//  Constants.m
//  Uurapp
//
//  Created by Code54 on 3/7/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "Constants.h"

@implementation Constants

    NSString *const RememberMeDescriptionTrue = @"Wachtwoord opslaan";
    NSString *const RememberMeDescriptionFalse = @"Wachtwoord intypen";
    NSString *const PREF_FILE_NAME = @"Uurapp";
    NSString *const APIVersion = @"2";
    NSString *const dictionary_RESULT = @"result";
    NSString *const result_UNSUPPORTED_API_VERSION = @"api_unsupported_api_version";
    NSString *const result_SUCCESS = @"success";
    NSString *const result_NOT_LOGGED_ON = @"not_logged_on";
    NSString *const result_FAILED = @"failed";
    NSString *const result_LOGIN_PROCESS_FAILED = @"login_process_failed";
    NSString *const result_LOGIN_NOT_APPROVED = @"login_not_approved";
    NSString *const result_LOGIN_LOCKED_OUT = @"login_login_locked_out";
    NSString *const result_LOGIN_INVALID = @"login_invalid";
    NSString *const result_LOGIN_TOKEN_EXPIRED = @"login_token_expired";
    NSString *const savedPasswordAlias = @"******";
    NSString *const apiURL = @"http://erpdebug.code54.nl/API/jsonapi.ashx";     // debug version
    //NSString *const apiURL = @"https://app.uurapp.nl/API/jsonapi.ashx";			// production version

@end
