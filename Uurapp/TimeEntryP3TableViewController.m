//
//  TimeEntryP3TableViewController.m
//  Uurapp
//
//  Created by Code54 on 3/13/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "TimeEntryP3TableViewController.h"
#import "Globals.h"
#import "WebPost.h"
#import "PRLabel.h"
#import "Constants.h"

@interface TimeEntryP3TableViewController ()

@property (weak, nonatomic) IBOutlet PRLabel *ActivityText;
@property (weak, nonatomic) IBOutlet PRLabel *ProjectText;
@property (weak, nonatomic) IBOutlet PRLabel *AddressText;
@property (weak, nonatomic) IBOutlet UITextField *DescriptionText;
@property (weak, nonatomic) IBOutlet UITextField *RemarkText;
- (IBAction)Save:(id)sender;
- (IBAction)Cancel:(id)sender;

@end

@implementation TimeEntryP3TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // set up pickers
    activityPicker = [[UIPickerView alloc] init];
    addressPicker = [[UIPickerView alloc] init];
    projectphasePicker = [[UIPickerView alloc] init];
    
    activityPicker.showsSelectionIndicator = YES;
    addressPicker.showsSelectionIndicator = YES;
    projectphasePicker.showsSelectionIndicator = YES;
    
    activityPicker.delegate = self;
    addressPicker.delegate = self;
    projectphasePicker.delegate = self;
    
   
    //toolbar for picker
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:
                                CGRectMake(0,0, 320, 44)]; //should code with variables to support view rotation
    UIBarButtonItem *doneButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self action:@selector(inputAccessoryViewDidFinish)];
    doneButton.title = @"Klaar";
    
    //using default text field delegate method here, here you could call
    //myTextField.resignFirstResponder to dismiss the views
    [pickerToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    self.ActivityText.inputAccessoryView = pickerToolbar;
    self.ProjectText.inputAccessoryView = pickerToolbar;
    self.AddressText.inputAccessoryView = pickerToolbar;
    
    //set selected description and remarks.
    //the selected projects, etc. are set in didReceiveDataProjectphases,etc.
    Globals *globals=[Globals getInstance];
    self.DescriptionText.text = globals.selection.description;
    self.RemarkText.text = globals.selection.remarks;
    
    //do http request for data
    [self getActivitiesProjectsAddresses];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)inputAccessoryViewDidFinish
{
    [self.ActivityText resignFirstResponder];
    [self.AddressText resignFirstResponder];
    [self.ProjectText resignFirstResponder];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    Globals *globals=[Globals getInstance];
    DescriptionIDrow *Row = nil;
    if (pickerView == activityPicker)
    {
        Row = [globals.activities objectAtIndex:row];
        self.ActivityText.text = Row.description;
        globals.selection.activityID = Row.id;
    }
    if (pickerView == addressPicker)
    {
        Row = [globals.addresses objectAtIndex:row];
        self.AddressText.text = Row.description;
        globals.selection.addressID = Row.id;
        
    }
    if (pickerView == projectphasePicker)
    {
        Row = [globals.projectphases objectAtIndex:row];
        self.ProjectText.text = Row.description;
        globals.selection.projectPhaseID = Row.id;
        
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    Globals *globals=[Globals getInstance];
    
    if (pickerView == activityPicker) return globals.activities.count;
    if (pickerView == addressPicker) return globals.addresses.count;
    if (pickerView == projectphasePicker) return globals.projectphases.count;
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Globals *globals=[Globals getInstance];
    DescriptionIDrow *Row = nil;
    if (pickerView == activityPicker) Row = [globals.activities objectAtIndex:row];
    if (pickerView == addressPicker) Row = [globals.addresses objectAtIndex:row];
    if (pickerView == projectphasePicker) Row = [globals.projectphases objectAtIndex:row];
    if (Row != nil)
        return Row.description;
    else return @"-fout-";
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

// --------------- textbox delegates ---------------

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if ((theTextField == self.DescriptionText)
        || (theTextField == self.RemarkText)) {
        
        [theTextField resignFirstResponder];
        Globals *globals=[Globals getInstance];
        globals.selection.description = self.DescriptionText.text;
        globals.selection.remarks = self.RemarkText.text;
        return YES;
    }
    return FALSE;
}

// ----------------- Toolbar buttons ---------------

- (IBAction)Save:(id)sender {
    [self postNewEntry];
}

- (IBAction)Cancel:(id)sender {
    [self performSegueWithIdentifier:@"pushFromP3ToTimeList" sender:self];
}



// --------------- http data ---------------

- (void) postNewEntry
{
    //Update date from DatePicker
    Globals *globals=[Globals getInstance];
    
    if (![globals.selection isValid])
    {
        [self alertBox:@"Kies activiteit"];     // activity is the only required field at this point
        return;
    }
    [self startSpinner];


    // Do WebPost for Activities
    WebPost *actPost = [[WebPost alloc] init];
    [actPost AddKey:@"cmd" AddValue:@"newtimeentry"];
    [actPost AddKey:@"token" AddValue:globals.token];
    [actPost AddKey:@"timerowid" AddValue:globals.selection.timerowID];
    [actPost AddKey:@"date" AddValue:[globals.selection getDateAsNSString]];
    [actPost AddKey:@"starttime" AddValue:[globals.selection getStartTimeAsNSString]];
    [actPost AddKey:@"endtime" AddValue:[globals.selection getEndTimeAsNSString]];
    [actPost AddKey:@"hours" AddValue:[globals.selection getHoursAsNSString]];
    [actPost AddKey:@"description" AddValue:globals.selection.description];
    [actPost AddKey:@"remarks" AddValue:globals.selection.remarks];
    [actPost AddKey:@"activityid" AddValue:globals.selection.activityID];
    [actPost AddKey:@"addressid" AddValue:globals.selection.addressID];
    [actPost AddKey:@"organizationid" AddValue:globals.selection.organizationID];
    [actPost AddKey:@"projectphaseid" AddValue:globals.selection.projectPhaseID];
    [NSURLConnection
     sendAsynchronousRequest:[actPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveDataNewEntry:data];
     }];
}

- (void) getActivitiesProjectsAddresses
{
    [self startSpinner];

    
    self.ActivityText.text = @"Laden...";
    self.AddressText.text = @"Laden...";
    self.ProjectText.text = @"Laden...";
    
    //disable pickers
    self.ActivityText.inputView = nil;
    self.ProjectText.inputView = nil;
    self.AddressText.inputView = nil;
    
    //Remove old lists
    Globals *globals=[Globals getInstance];
    
    [globals clearActivities];
    [globals clearAddresses];
    [globals clearProjectphases];
     
    // Do WebPost for Activities
    WebPost *actPost = [[WebPost alloc] init];
    [actPost AddKey:@"cmd" AddValue:@"activities"];
    [actPost AddKey:@"token" AddValue:globals.token];
    [NSURLConnection
     sendAsynchronousRequest:[actPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveDataActivities:data];
     }];
    
    // Do WebPost for Addresses
    WebPost *addrPost = [[WebPost alloc] init];
    [addrPost AddKey:@"cmd" AddValue:@"addresses"];
    [addrPost AddKey:@"organizationid" AddValue:globals.selection.organizationID];
    [addrPost AddKey:@"token" AddValue:globals.token];
    [NSURLConnection
     sendAsynchronousRequest:[addrPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveDataAddresses:data];
     }];
    
    // Do WebPost for ProjectPhases
    WebPost *prjPost = [[WebPost alloc] init];
    [prjPost AddKey:@"cmd" AddValue:@"projectphases"];
    [prjPost AddKey:@"organizationid" AddValue:globals.selection.organizationID];
    [prjPost AddKey:@"token" AddValue:globals.token];
    [NSURLConnection
     sendAsynchronousRequest:[prjPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveDataProjectphases:data];
     }];
    
    
}

- (void) didReceiveDataNewEntry:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            for (id key in JSON) {
                if ([key isEqualToString: dictionary_RESULT]
                    && [[JSON objectForKey:key] isEqualToString:result_SUCCESS])
                {
                    Globals *globals=[Globals getInstance];
                    [globals.selection clearSelection];
                    [self performSegueWithIdentifier:@"pushFromP3ToTimeList" sender:self];
                    return;
                }
                if ([key isEqualToString: dictionary_RESULT]
                    && [[JSON objectForKey:key] isEqualToString:result_FAILED])
                {
                    [self alertBox:@"Fout tijdens opslaan van deze regel."];
                    return;
                }
            }
        }
    }
}

- (void) didReceiveDataActivities:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSMutableArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            Globals *globals=[Globals getInstance];
            [globals clearActivities];
            for (int i = 0; i < [JSON count]; i++)
            {
                NSDictionary *dict = [JSON objectAtIndex:i];
                DescriptionIDrow *row = [[DescriptionIDrow alloc] init];
                row.id = [dict objectForKey:@"id"];
                row.description= [dict objectForKey:@"description"];
                [globals addActivity: row];
                if ([globals.selection.activityID isEqualToString:row.id]) // set the selected text
                    self.ActivityText.text = row.description;
            }
            [activityPicker reloadAllComponents];
            if (globals.activities.count == 0)
            {
                self.ActivityText.userInteractionEnabled = FALSE;
                self.ActivityText.text = @"-nvt-";
                self.ActivityText.inputView = nil;
            }
            if (globals.activities.count == 1)
            {
                self.ActivityText.userInteractionEnabled = FALSE;
                self.ActivityText.text = [globals.activities[0] description];
                globals.selection.activityID = [globals.activities[0] id];
                self.ActivityText.inputView = nil;
            }
            if (globals.activities.count > 1)
            {
                self.ActivityText.userInteractionEnabled = TRUE;
                if (!globals.selection.activityID.length > 0)
                    self.ActivityText.text = @"-kies-";
                self.ActivityText.inputView = activityPicker;
            }
            return;
        }
    }
    [self alertBox:@"Fout tijdens ophalen activiteiten."];
}


- (void) didReceiveDataAddresses:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSMutableArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            Globals *globals=[Globals getInstance];
            [globals clearAddresses];
            for (int i = 0; i < [JSON count]; i++)
            {
                NSDictionary *dict = [JSON objectAtIndex:i];
                DescriptionIDrow *row = [[DescriptionIDrow alloc] init];
                row.id = [dict objectForKey:@"id"];
                row.description= [dict objectForKey:@"description"];
                [globals addAddress: row];
                if ([globals.selection.addressID isEqualToString:row.id]) // set the selected text
                    self.AddressText.text = row.description;
            }
            [addressPicker reloadAllComponents];
            if (globals.addresses.count == 0)
            {
                self.AddressText.userInteractionEnabled = FALSE;
                self.AddressText.text = @"-nvt-";
                self.AddressText.inputView = nil;
            }
            if (globals.addresses.count == 1)
            {
                self.AddressText.userInteractionEnabled = FALSE;
                self.AddressText.text = [globals.addresses[0] description];
                globals.selection.addressID = [globals.addresses[0] id];
                self.AddressText.inputView = nil;
            }
            if (globals.addresses.count > 1)
            {
                self.AddressText.userInteractionEnabled = TRUE;
                if (!globals.selection.addressID.length > 0)
                    self.AddressText.text = @"-kies-";
                self.AddressText.inputView = addressPicker;
            }
            return;
        }
    }
    [self alertBox:@"Fout tijdens ophalen adressen."];
}

- (void) didReceiveDataProjectphases:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSMutableArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            Globals *globals=[Globals getInstance];
            [globals clearProjectphases];
            for (int i = 0; i < [JSON count]; i++)
            {
                NSDictionary *dict = [JSON objectAtIndex:i];
                DescriptionIDrow *row = [[DescriptionIDrow alloc] init];
                row.id = [dict objectForKey:@"id"];
                row.description= [dict objectForKey:@"description"];
                [globals addProjectphase: row];
                if ([globals.selection.projectPhaseID isEqualToString:row.id])
                    self.ProjectText.text = row.description;            // set the selected text
            }
            [projectphasePicker reloadAllComponents];
            if (globals.projectphases.count == 0)
            {
                self.ProjectText.userInteractionEnabled = FALSE;
                self.ProjectText.text = @"-nvt-";
                self.ProjectText.inputView = nil;
            }            
            if (globals.projectphases.count > 0)
            {
                self.ProjectText.userInteractionEnabled = TRUE;
                if (globals.selection.projectPhaseID == nil)
                    self.ProjectText.text = @"-kies-";
                self.ProjectText.inputView = projectphasePicker;
            }
            return;
        }
    }
    [self alertBox:@"Fout tijdens ophalen projecten."];
}



// ------------ Common Utilties -----------


-(void) alertBox: (NSString *) aMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uurapp" message:aMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"alertBox %@", aMessage);
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

@end
