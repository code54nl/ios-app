//
//  TimeEntryP2ViewController.h
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeEntryP2ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIActivityIndicatorView   *aSpinner;
}

@property (weak, nonatomic) IBOutlet UITableView *OrganizationsList;

@end
