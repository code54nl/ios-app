//
//  TimeListController.m
//  Uurapp
//
//  Created by Code54 on 3/8/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "TimeListController.h"
#import "Globals.h"
#import "WebPost.h"
#import "TimeRow.h"
#import "Constants.h"

@interface TimeListController ()

@end

@implementation TimeListController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
  //  self.navigationController.navigationBarHidden = YES;
    [self.DatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self updateTimeRows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Logoff:(id)sender {
    //Logoff by erasing token and password
    Globals *globals=[Globals getInstance];
    globals.token = @"";
    globals.saveToken=FALSE;
    [globals savePreferences];
    
    NSLog(@"Logoff user: %@", globals.username);
    [self performSegueWithIdentifier:@"pushToLogin" sender:self];
}

- (IBAction)Today:(id)sender {
    NSDate *today = [NSDate new];
    [[self DatePicker] setDate:today];
    [self updateTimeRows];
}

-(IBAction)Add:(id)sender {
    Globals *globals=[Globals getInstance];
    [globals.selection clearSelection];
    globals.selection.date = [self.DatePicker date];
    [self performSegueWithIdentifier:@"pushToTimeEntryP1" sender:self];
    return;
}

- (void)datePickerChanged:(id)sender
{
    [self updateTimeRows];
}

- (void) updateTimeRows
{
    [self startSpinner];
    //Update date from DatePicker
    Globals *globals=[Globals getInstance];
    globals.selectedDate = [self.DatePicker date];
    
    // Do WebPost for login
    WebPost *aPost = [[WebPost alloc] init];
    [aPost AddKey:@"cmd" AddValue:@"timerows"];
    [aPost AddKey:@"token" AddValue:globals.token];
	[aPost AddKey:@"date" AddValue:globals.getSelectedDateString];
    [NSURLConnection
        sendAsynchronousRequest:[aPost GetURLRequest]
        queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
        {
         [self didReceiveDataGetTimeRows:data];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView
        numberOfRowsInSection:(NSInteger)section
{	
    Globals *globals=[Globals getInstance];
    return globals.timeRows.count;
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
    TimeRow *Row = [globals.timeRows objectAtIndex:indexPath.row];
    
    NSMutableArray *details = [NSMutableArray new];
    if ((Row.startTime.length > 0) && (Row.endTime.length > 0))
    {
        [details addObject:Row.startTime];
        [details addObject:@"-"];
        [details addObject:Row.endTime];
    }
    [details addObject:Row.hours];
    [details addObject:@"uur"];
    [details addObject:Row.organizationAbbrv];
    [details addObject:Row.activityAbbrv];
    cell.textLabel.text = Row.description;
    cell.detailTextLabel.text = [details componentsJoinedByString:@" "];
    if (Row.declared == FALSE)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Request details of selected timerow
    Globals *globals=[Globals getInstance];
    TimeRow *Row = [globals.timeRows objectAtIndex:indexPath.row];
    
    if (Row.declared)
    {
        [self alertBox:@"Deze regel is al gedeclareerd."];
        return;
    }
    else
    {
        [globals.selection clearSelection];
        globals.selection.timerowID = Row.id;
        
        // Do WebPost 
        WebPost *aPost = [[WebPost alloc] init];
        [aPost AddKey:@"cmd" AddValue:@"rowdetails"];
        [aPost AddKey:@"token" AddValue:globals.token];
        [aPost AddKey:@"timerowid" AddValue:Row.id];
        [NSURLConnection
         sendAsynchronousRequest:[aPost GetURLRequest]
         queue:[NSOperationQueue mainQueue]
         completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
         {
             [self didReceiveDataGetDetails:data];
         }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // http://stackoverflow.com/questions/3309484/uitableviewcell-show-delete-button-on-swipe
    // Return YES if you want the specified item to be editable.
    Globals *globals=[Globals getInstance];
    TimeRow *Row = [globals.timeRows objectAtIndex:indexPath.row];
    return !Row.declared;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Code to delete
        
        [self startSpinner];
        
        //Get TimeRowID first
        Globals *globals=[Globals getInstance];
        TimeRow *Row = [globals.timeRows objectAtIndex:indexPath.row];
        if (!Row.declared)
        {
            globals.selection.timerowID = Row.id;
            //webpost with delete request
            WebPost *aPost = [[WebPost alloc] init];
            [aPost AddKey:@"cmd" AddValue:@"rowdelete"];
            [aPost AddKey:@"token" AddValue:globals.token];
            [aPost AddKey:@"timerowid" AddValue:Row.id];
            [NSURLConnection
             sendAsynchronousRequest:[aPost GetURLRequest]
             queue:[NSOperationQueue mainQueue]
             completionHandler:^(NSURLResponse *res, NSData *data, NSError *err)
             {
                 [self didReceiveDataTimeRowDelete:data];
             }];
        }
        else{
            [self alertBox:@"Deze tijdregel is al gedeclareerd."];
        }
        

    }
}


- (void) didReceiveDataGetTimeRows:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSMutableArray *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            Globals *globals=[Globals getInstance];
            [globals clearTimeRows];
            for (int i = 0; i < [JSON count]; i++)
            {
                NSDictionary *dict = [JSON objectAtIndex:i];
                NSLog(@"Receiving timerow s%@", dict);
                
                TimeRow *row = [[TimeRow alloc] init];
                row.id = [dict objectForKey:@"id"];
                row.startTime = [dict objectForKey:@"startTime"];
                row.endTime=  [dict objectForKey:@"endTime"];
                row.hours=  [dict objectForKey:@"hours"];
                row.activityID = [dict objectForKey:@"activityID"];
                row.activityAbbrv = [dict objectForKey:@"activityAbbrv"];
                row.organizationID = [dict objectForKey:@"organizationID"];
                row.addressID = [dict objectForKey:@"addressID"];
                row.organizationAbbrv = [dict objectForKey:@"organizationAbbrv"];
                row.projectPhaseAbbrv = [dict objectForKey:@"projectPhaseAbbrv"];
                row.projectAbbrv = [dict objectForKey:@"projectAbbrv"];
                row.projectPhaseID = [dict objectForKey:@"projectPhaseID"];
                row.remarks = [dict objectForKey:@"remarks"];
                row.description = [dict objectForKey:@"description"];
                row.declared = [[dict objectForKey:@"declared"] boolValue];
                [globals addTimeRow: row];
            }
            [[self TimeRowList] reloadData];
            return;
        }
    }
    [self alertBox:@"Fout tijdens ophalen tijdregels."];
}


- (void) didReceiveDataTimeRowDelete:(id)jsonData
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
                    [self updateTimeRows];
                    return;
                }
                if ([key isEqualToString: dictionary_RESULT]
                    && [[JSON objectForKey:key] isEqualToString:result_FAILED])
                {
                    [self alertBox:@"Fout tijdens verwijderen van deze regel."];
                    return;
                }
            }
        }
        return;
    }
    [self alertBox:@"Fout tijdens verwijderen regel."];
}

- (void) didReceiveDataGetDetails:(id)jsonData
{
    [self stopSpinner];
    if (jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if ((error == nil) && (JSON != nil))
        {
            NSLog(@"Editing timerow %@", JSON);

            Globals *globals=[Globals getInstance];
            Selection *selection = globals.selection;
            [selection setDateByNSString:[JSON objectForKey:@"date"]];
            if (![[JSON objectForKey:@"starttime"] isEqualToString:@""])
            {
                [selection setStartTimeByNSString:[JSON objectForKey:@"starttime"]];
                [selection setEndTimeByNSString:[JSON objectForKey:@"endtime"]];
            }
            [selection setHoursByString:[JSON objectForKey:@"hours"]];
            selection.description = [JSON objectForKey:@"description"];
            selection.remarks = [JSON objectForKey:@"remarks"];
            selection.activityID = [JSON objectForKey:@"activityId"];
            selection.addressID = [JSON objectForKey:@"addressId"];
            selection.projectPhaseID = [JSON objectForKey:@"projectphaseId"];
            selection.organizationID = [JSON objectForKey:@"organizationId"];
            [self performSegueWithIdentifier:@"pushToTimeEntryP1" sender:self];
            return;
        }
        return;
    }
    [self alertBox:@"Fout tijdens ophalen tijdregel."];
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
