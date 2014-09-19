//
//  TimeEntryP1ViewController.m
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "TimeEntryP1ViewController.h"
#import "Globals.h"

@interface TimeEntryP1ViewController ()

@end

@implementation TimeEntryP1ViewController

const int modeUndecided = 0;
const int modeEnterStartEnd = 1;
const int modeEnterHours = 2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [Scroller setScrollEnabled:TRUE];
    [Scroller setContentSize:CGSizeMake(320, 1280)];
 //   self.navigationController.navigationBarHidden = NO;
    [self InitTimeControls];
    [StartTime addTarget:self action:@selector(startTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [EndTime addTarget:self action:@selector(endTimeChanged:) forControlEvents:UIControlEventValueChanged];
    [Hours addTarget:self action:@selector(hoursChanged:) forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    

}	

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)InitTimeControls
{
    // Enables Hours or Start/End-time
    Globals *globals=[Globals getInstance];
    [Hours setCountDownDuration:globals.selection.getHoursAsNSTimeInterval];
    if ((globals.selection.startTime == nil)
            && (globals.selection.hours == nil)) {
        timeEntryMode = modeUndecided;
        [StartTime setEnabled: TRUE];
        [EndTime setEnabled: TRUE];
        [Hours setEnabled:TRUE];
    }
    else
    {
        if (globals.selection.startTime == nil)
        {
            timeEntryMode = modeEnterHours;
            [StartTime setEnabled: FALSE];
            [EndTime setEnabled: FALSE];
            [Hours setEnabled:TRUE];
        }
        else {
            timeEntryMode = modeEnterStartEnd;
            [StartTime setDate:globals.selection.startTime];
            [EndTime setDate:globals.selection.endTime];
            [StartTime setEnabled: TRUE];
            [EndTime setEnabled: TRUE];
            [Hours setEnabled:FALSE];
        }
    }
}

- (void) calculateAndSetHours
{

    if (timeEntryMode == modeEnterStartEnd)
    {
        Globals *globals=[Globals getInstance];
        [globals.selection calculateHours];
        [Hours setCountDownDuration: globals.selection.getHoursAsNSTimeInterval];
        [StartTime setEnabled: TRUE];
        [EndTime setEnabled: TRUE];
        [Hours setEnabled:FALSE];
    }
    if (timeEntryMode == modeEnterHours)
    {
        [StartTime setEnabled: FALSE];
        [EndTime setEnabled: FALSE];
        [Hours setEnabled:TRUE];
    }
}

- (void)startTimeChanged:(id)sender
{
    Globals *globals=[Globals getInstance];
    globals.selection.startTime = [globals loseDatePart:StartTime.date ];
    globals.selection.endTime = [globals loseDatePart:EndTime.date ];
    
    if ([globals.selection.startTime compare:globals.selection.endTime] == NSOrderedDescending)
    {
        [self alertBox:@"Starttijd mag niet later zijn dan Eindtijd."];
        [StartTime setDate: globals.selection.endTime];
        return;
    }
    timeEntryMode = modeEnterStartEnd;
    [self calculateAndSetHours];
}

- (void)endTimeChanged:(id)sender
{
    Globals *globals=[Globals getInstance];
    globals.selection.startTime = [globals loseDatePart:StartTime.date ];
    globals.selection.endTime = [globals loseDatePart:EndTime.date ];
    
    if ([globals.selection.startTime compare:globals.selection.endTime] == NSOrderedDescending)
    {
        [self alertBox:@"Eindtijd mag niet eerder zijn dan Starttijd."];
        [EndTime setDate: globals.selection.startTime];
        return;
    }
    timeEntryMode = modeEnterStartEnd;
    [self calculateAndSetHours];
}

- (void)hoursChanged:(id)sender
{
    Globals *globals=[Globals getInstance];
    [globals.selection setHoursByNSTimeInterval: Hours.countDownDuration];
    timeEntryMode = modeEnterHours;    
    [self calculateAndSetHours];
}



- (IBAction)Next:(id)sender {
    if (timeEntryMode == modeUndecided)
    {
        [self alertBox:@"Stel een begin- en eindtijd in, of kies het aantal uren."];
        return;
    }
    [self performSegueWithIdentifier:@"pushToTimeEntryP2" sender:self];
}



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