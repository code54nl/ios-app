//
//  DetailViewController.m
//  Uurapp
//
//  Created by Code54 on 3/6/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "WebPost.h"
#import "Globals.h"

@interface LoginViewController ()
- (void)configureView;
@end

@implementation LoginViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    self.LinkToUurapp.editable = FALSE;
    self.LinkToUurapp.dataDetectorTypes = UIDataDetectorTypeLink;
    // Load preferences
    Globals *globals=[Globals getInstance];
    self.RememberMe.On = globals.saveToken;
    self.LoginName.text = globals.username;

    [self.RememberMe addTarget:self action:@selector(rememberMeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self updateRememberMeDescription];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // auto login
    Globals *globals=[Globals getInstance];
    if (globals.hasToken)
    {
        self.LoginPassword.text = savedPasswordAlias;
        [self loginWithToken];  // auto-login if we have a saved token
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender {
    // Get values from controls, place in local properties
    self.userName = self.LoginName.text;
    self.userPassword = self.LoginPassword.text;
    if (([self.userName length] == 0) || ([self.userPassword length] == 0))
    {
        [self alertBox:@"Naam en Wachtwoord zijn verplicht."];
    }
    else
    {
        [self loginWithUsername];        
    }
}

-(void) loginWithToken
{
    // Do WebPost for login
    [self startSpinner];
   
    Globals *globals=[Globals getInstance];
    
    WebPost *aPost = [[WebPost alloc] init];
    [aPost AddKey:@"cmd" AddValue:@"testtoken"];
    [aPost AddKey:@"token" AddValue:globals.token];
	[aPost AddKey:@"apiversion" AddValue:APIVersion];
    [NSURLConnection
     sendAsynchronousRequest:[aPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveData:data];
     }];
}

- (void) loginWithUsername
{
    // Do WebPost for login
    [self startSpinner];       
    
    WebPost *aPost = [[WebPost alloc] init];
    [aPost AddKey:@"cmd" AddValue:@"login"];
    [aPost AddKey:@"username" AddValue:self.userName];
	[aPost AddKey:@"password" AddValue:self.userPassword];   
    [NSURLConnection
        sendAsynchronousRequest:[aPost GetURLRequest]
        queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
        {
            [self didReceiveData:data];
        }];
}



- (void) updateRememberMeDescription
{
    // Updates the description off the UISwitch Remember Me, according to its setting
    self.rememberPassword = [self.RememberMe isOn];
    Globals *obj=[Globals getInstance];
    obj.saveToken = [self rememberPassword];
    if (self.rememberPassword) {
        self.RememberDescription.text  = RememberMeDescriptionTrue;
    }
    else {
        self.RememberDescription.text  = RememberMeDescriptionFalse;
    }
}

// ---------------Delegates ----------------

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if ((theTextField == self.LoginName) || (theTextField == self.LoginPassword)) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)rememberMeSwitchChanged:(id)sender
{
    [self updateRememberMeDescription];
}


- (void) didReceiveData:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            for (id key in JSON) {
                if ([key isEqualToString: @"token"])
                {
                    Globals *globals=[Globals getInstance];
                    globals.token = [JSON objectForKey:key];
                    globals.username = self.userName;
                    [globals savePreferences];
                                        
                    NSLog(@"Login with username success, token %@", globals.token);
                    [self performSegueWithIdentifier:@"pushToTimeList" sender:self];
                    return;
                }
               
                if ([key isEqualToString: dictionary_RESULT])
                {
                    NSString *alertMsg = @"Onbekende fout";
                    
                    if ([[JSON objectForKey:key] isEqualToString:result_SUCCESS]) {             // login, we have success on " testtoken"
                        NSLog(@"Login with token success");
                        [self performSegueWithIdentifier:@"pushToTimeList" sender:self];
                        return;

                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_UNSUPPORTED_API_VERSION]) {
                        alertMsg = @"Deze versie wordt niet meer ondersteund. Update de app.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_LOGIN_PROCESS_FAILED]) {
                        alertMsg = @"Fout bij het openen van de administratie.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_LOGIN_NOT_APPROVED]) {
                        alertMsg = @"Het is niet toegestaan met dit account in te loggen.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_NOT_LOGGED_ON]) {
                        alertMsg = @"Je bent niet ingelogd.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_LOGIN_LOCKED_OUT]) {
                        alertMsg = @"Je account is tijdelijk geblokkeerd.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_LOGIN_INVALID]) {
                        alertMsg = @"Gebruikersnaam of wachtwoord onjuist.";
                    }
                    if ([[JSON objectForKey:key] isEqualToString:result_LOGIN_TOKEN_EXPIRED]) {
                        alertMsg = @"Opgeslagen wachtwoord is verlopen.";
                    }
                    [self alertBox: alertMsg];                  
                    return;
                }
                NSLog(@"key: %@,value:%@", key, [JSON objectForKey:key]);
            }
        }
    }
    [self alertBox:@"Onbekende communicatie-fout."];
    NSLog(@"Login with username failed, response %@", jsonData);
}

-(void) startSpinner
{
    if (aSpinner != nil)   {
        [aSpinner stopAnimating];
    }
    
    aSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                UIActivityIndicatorViewStyleGray];
    aSpinner.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
    aSpinner.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin
                                 | UIViewAutoresizingFlexibleLeftMargin
                                 | UIViewAutoresizingFlexibleBottomMargin
                                 | UIViewAutoresizingFlexibleTopMargin);
    [self.view addSubview:aSpinner];
    [aSpinner startAnimating];
}

-(void) stopSpinner
{
    if (aSpinner != nil)   {
        [aSpinner stopAnimating];
    }
}

-(void) alertBox: (NSString *) aMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uurapp" message:aMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"alertBox %@", aMessage);
}
@end

