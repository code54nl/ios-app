//
//  Selection.h
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Selection : NSObject{
    
    NSString *timerowID;
    NSDate *date;
    NSDate *startTime;
    NSDate *endTime;
    NSDecimalNumber *hours;
    NSString *organizationID;
    NSString *addressID;
    NSString *activityID;
    NSString *projectPhaseID;
    NSString *remarks;
    NSString *description;
}

@property(nonatomic,retain) NSString *timerowID;
@property(nonatomic,retain) NSDate *date;
@property(nonatomic,retain) NSDate *startTime;
@property(nonatomic,retain) NSDate *endTime;
@property(nonatomic, retain) NSDecimalNumber *hours;
@property(nonatomic,retain) NSString *activityID;
@property(nonatomic,retain) NSString *organizationID;
@property(nonatomic,retain) NSString *addressID;
@property(nonatomic,retain) NSString *projectPhaseID;
@property(nonatomic,retain) NSString *remarks;
@property(nonatomic,retain) NSString *description;


-(void) clearSelection;
-(void) setHoursByString: (NSString *) hoursString;
-(void) setHoursByNSTimeInterval: (NSTimeInterval) interval;
- (void) setStartTimeByNSString: (NSString*) timeStr;
- (void) setEndTimeByNSString: (NSString*) timeStr;
- (void) setDateByNSString: (NSString*) dateStr;
-(NSString *) getDateAsNSString;
-(NSString *) getStartTimeAsNSString;
-(NSString *) getEndTimeAsNSString;
-(NSString *) getHoursAsNSString;
-(NSTimeInterval) getHoursAsNSTimeInterval;
-(BOOL) isValid;
-(void) calculateHours;

@end
