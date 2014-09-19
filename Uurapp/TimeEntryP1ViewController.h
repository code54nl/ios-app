//
//  TimeEntryP1ViewController.h
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TimeEntryP1ViewController : UIViewController
{
    __weak IBOutlet UIScrollView *Scroller;
    __weak IBOutlet UIDatePicker *StartTime;
    __weak IBOutlet UIDatePicker *EndTime;
    __weak IBOutlet UIDatePicker *Hours;
    int timeEntryMode;
    UIActivityIndicatorView   *aSpinner;
    
   
}
- (IBAction)Next:(id)sender;


@end
