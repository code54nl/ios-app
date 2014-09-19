//
//  Globals.m
//  Uurapp
//
//  Created by Code54 on 3/8/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "Globals.h"
#import "Selection.h"

@implementation Globals

@synthesize token;
@synthesize username;
@synthesize saveToken;
@synthesize selectedDate;
@synthesize timeRows;
@synthesize organizations;
@synthesize addresses;
@synthesize activities;
@synthesize projectphases;
@synthesize selection;

static Globals *instance =nil;

+(Globals *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {            
            instance= [Globals new];
            instance.timeRows = [NSMutableArray new];
            instance.organizations = [NSMutableArray new];
            instance.addresses = [NSMutableArray new];
            instance.activities= [NSMutableArray new];
            instance.projectphases= [NSMutableArray new];
            instance.selection = [Selection new];
            [instance loadPreferences];
        }
    }
    return instance;
}




-(void)clearTimeRows
{
    [timeRows removeAllObjects];
}

-(void)clearOrganizations
{
    [organizations removeAllObjects];
}

-(void)clearAddresses
{
    [addresses removeAllObjects];
}

-(void)clearActivities
{
    [activities removeAllObjects];
}

-(void)clearProjectphases
{
    [projectphases removeAllObjects];
}

-(void)addTimeRow:(TimeRow*)Row
{
    [timeRows addObject:Row];
}

-(void) addOrganization: (DescriptionIDrow*)Organization
{
    [organizations addObject:Organization];
}

-(void) addActivity: (DescriptionIDrow*)Activity
{
    [activities addObject:Activity];
}

-(void) addAddress: (DescriptionIDrow*)Address
{
    [addresses addObject:Address];
}

-(void) addProjectphase:(DescriptionIDrow *)Projectphase
{
    [projectphases addObject:Projectphase];
}




-(void)savePreferences
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.username forKey:@"username"];
    [userDefaults setBool:self.saveToken forKey:@"saveToken"];
    [userDefaults setObject:self.token forKey:@"token"];
    [userDefaults synchronize];
}

-(void)loadPreferences
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.username = [userDefaults objectForKey:@"username"];
    self.token = [userDefaults objectForKey:@"token"];
    self.saveToken = [userDefaults boolForKey:@"saveToken"];
}

-(BOOL)hasToken
{
    return (saveToken) && (token.length > 0);
}

-(NSString *) getSelectedDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    return [format stringFromDate:selectedDate];
}

-(NSDate *) loseDatePart: (NSDate*) aDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *tmpStr = [format stringFromDate:aDate];
    return [format dateFromString: tmpStr];
}

@end
