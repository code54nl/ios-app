//
//  TimeEntryP3TableViewController.h
//  Uurapp
//
//  Created by Code54 on 3/13/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeEntryP3TableViewController : UITableViewController <UIPickerViewDelegate>
{
    UIActivityIndicatorView   *aSpinner;
    UIPickerView *activityPicker;
    UIPickerView *addressPicker;
    UIPickerView *projectphasePicker;
}


@end
