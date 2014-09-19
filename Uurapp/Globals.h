//
//  Globals.h
//  Uurapp
//
//  Created by Code54 on 3/8/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeRow.h"
#import "Selection.h"
#import "DescriptionIDrow.h"

@interface Globals : NSObject {
    NSString *token;
    NSString *username;
    BOOL saveToken;
    NSDate *selectedDate;
    NSMutableArray *timeRows;
    NSMutableArray *organizations;
    NSMutableArray *activities;
    NSMutableArray *projectphases;
    NSMutableArray *addresses;
    Selection *selection;
}

@property(nonatomic,retain)NSString *token;
@property(nonatomic,retain)NSString *username;
@property(nonatomic)BOOL saveToken;
@property(nonatomic,retain)NSDate *selectedDate;
@property(nonatomic,retain)NSMutableArray *timeRows;
@property(nonatomic,retain)NSMutableArray *organizations;
@property(nonatomic,retain)NSMutableArray *activities;
@property(nonatomic,retain)NSMutableArray *addresses;
@property(nonatomic,retain)NSMutableArray *projectphases;
@property(nonatomic,retain)Selection *selection;


+(Globals*) getInstance;
-(void) savePreferences;
-(BOOL) hasToken;
-(NSString *) getSelectedDateString;
-(void) clearTimeRows;
-(void) clearOrganizations;
-(void) clearAddresses;
-(void) clearActivities;
-(void) clearProjectphases;
-(void) addTimeRow: (TimeRow*)Row;
-(void) addOrganization: (DescriptionIDrow*)Organization;
-(void) addActivity: (DescriptionIDrow*)Activity;
-(void) addProjectphase: (DescriptionIDrow*)Projectphase;
-(void) addAddress: (DescriptionIDrow*)Address;
-(NSDate *) loseDatePart: (NSDate*) aDate;

@end
