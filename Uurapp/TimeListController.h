//
//  TimeListController.h
//  Uurapp
//
//  Created by Code54 on 3/8/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>

// from http://tech.pro/tutorial/1026/how-to-create-and-populate-a-uitableview

@interface TimeListController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIActivityIndicatorView   *aSpinner;
}

- (IBAction)Logoff:(id)sender;
- (IBAction)Today:(id)sender;
- (IBAction)Add:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UITableView *TimeRowList;


@end
