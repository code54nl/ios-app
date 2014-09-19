//
//  LoginViewController.h
//  Uurapp
//
//  Created by Code54 on 3/6/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UIActivityIndicatorView   *aSpinner;
}

@property (weak, nonatomic) IBOutlet UITextField *LoginName;
@property (weak, nonatomic) IBOutlet UITextField *LoginPassword;
@property (weak, nonatomic) IBOutlet UISwitch *RememberMe;
@property (weak, nonatomic) IBOutlet UILabel *RememberDescription;
@property (weak, nonatomic) IBOutlet UITextView *LinkToUurapp;

@property (strong, nonatomic) id detailItem;

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userPassword;
@property BOOL rememberPassword;

- (IBAction)Login:(id)sender;
- (void) loginWithUsername;

@end
