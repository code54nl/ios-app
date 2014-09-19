//
//  TimeEntryP2Controller.m
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "TimeEntryP2ViewController.h"
#import "Globals.h"
#import "WebPost.h" 
#import "DescriptionIDrow.h"

@interface TimeEntryP2ViewController ()
- (IBAction)Next:(id)sender;

@end

@implementation TimeEntryP2ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self startSpinner];
    [self getOrganizations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getOrganizations
{
    [self startSpinner];
    //Update date from DatePicker
    Globals *globals=[Globals getInstance];
    
    // Do WebPost for login
    WebPost *aPost = [[WebPost alloc] init];
    [aPost AddKey:@"cmd" AddValue:@"organizations"];
    [aPost AddKey:@"token" AddValue:globals.token];
    [NSURLConnection
     sendAsynchronousRequest:[aPost GetURLRequest]
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
     {
         [self didReceiveData:data];
     }];
}


- (IBAction)Next:(id)sender {
    Globals *globals=[Globals getInstance];
    if (globals.selection.organizationID != nil)
    {
        [self performSegueWithIdentifier:@"pushToTimeEntryP3" sender:self];
        return;
    }
    else
    {
        [self alertBox:@"Kies eerst een klant."];
    }
}


// ---- implement tableview ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Globals *globals=[Globals getInstance];
    return globals.organizations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Identifier for retrieving reusable cells.
    static NSString *cellIdentifier = @"MyCellIdentifier"; // Attempt to reque reusable cell.
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // No cell available - create one.
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Set the text of the cell to the row index.
    Globals *globals=[Globals getInstance];
    DescriptionIDrow *Row = [globals.organizations objectAtIndex:indexPath.row];
    cell.textLabel.text = Row.description;
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Request details of selected timerow
    Globals *globals=[Globals getInstance];
    DescriptionIDrow *Row = [globals.organizations objectAtIndex:indexPath.row];
    globals.selection.organizationID = Row.id;
    [self performSegueWithIdentifier:@"pushToTimeEntryP3" sender:self];
    
}


//  -- reponse from webpost --

- (void) didReceiveData:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSMutableArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            NSIndexPath *selectedRow = nil;
            Globals *globals=[Globals getInstance];
            [globals clearOrganizations];
            for (int i = 0; i < [JSON count]; i++)
            {
                NSDictionary *dict = [JSON objectAtIndex:i];
                DescriptionIDrow *row = [[DescriptionIDrow alloc] init];
                row.id = [dict objectForKey:@"id"];
                row.description= [dict objectForKey:@"description"];
                [globals addOrganization: row];
                if ([globals.selection.organizationID isEqualToString:row.id])
                {
                    selectedRow = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
            [[self OrganizationsList] reloadData];
            if (selectedRow != nil)
                [[self OrganizationsList] selectRowAtIndexPath:selectedRow animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
            
            return;
        }
    }
    [self alertBox:@"Fout tijdens ophalen tijdregels."];
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

- (IBAction)New:(id)sender {
}

@end
