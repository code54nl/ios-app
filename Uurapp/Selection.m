//
//  Selection.m
//  Uurapp
//
//  Created by Code54 on 3/12/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "Selection.h"

@implementation Selection

    @synthesize timerowID;
    @synthesize date;
    @synthesize startTime;
    @synthesize endTime;
    @synthesize hours;
    @synthesize activityID;
    @synthesize organizationID;
    @synthesize addressID;
    @synthesize projectPhaseID;
    @synthesize remarks;
    @synthesize description;

-(id) init
{
    self = [super init];
    if (self)
    {
        timerowID = nil;
        date = nil;
        startTime = nil;
        endTime = nil;
        hours = nil;
        activityID = nil;
        addressID = nil;
        organizationID = nil;
        projectPhaseID = nil;
        remarks = nil;
        description = nil;
    }
    return self;
}

-(void) clearSelection
{
    startTime = nil;
    endTime = nil;
    hours = nil;
    description =nil;
    remarks = nil;
    activityID = nil;
    organizationID = nil;
    projectPhaseID = nil;
    addressID = nil;
    date = nil;
}

-(BOOL) isValid
{
    if (date == nil) return FALSE;
    if (hours == nil) return FALSE;
    if (organizationID == nil) return FALSE;
    if (activityID == nil) return FALSE;
    return TRUE;
}

-(void) setHoursByString: (NSString *) hoursString
{
    hours = [[NSDecimalNumber alloc]initWithString:hoursString];
}

- (void) setStartTimeByNSString: (NSString*) timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    startTime = [dateFormatter dateFromString:timeStr];
}

- (void) setEndTimeByNSString: (NSString*) timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    endTime = [dateFormatter dateFromString:timeStr];
}

- (void) setDateByNSString: (NSString*) dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    date = [dateFormatter dateFromString:dateStr];
}

-(void) setHoursByNSTimeInterval: (NSTimeInterval) interval;
{
    float rounded = (roundf(interval / 36)) / 100;
    NSString *tmpStr = [NSString stringWithFormat:@"%.2f", rounded];
    hours = [NSDecimalNumber decimalNumberWithString:tmpStr];
}
	
-(NSTimeInterval) getHoursAsNSTimeInterval
{
    return [hours doubleValue] * 3600; // 3600 =  number of seconds in 1 hour
}

-(NSString *) getHoursAsNSString
{
    return [NSString stringWithFormat:@"%@", self.hours];
}

-(NSString *) getDateAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    return [format stringFromDate:self.date];
}

-(NSString *) getStartTimeAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    return [format stringFromDate:self.startTime];
}

-(NSString *) getEndTimeAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    return [format stringFromDate:self.endTime];
}

-(void) calculateHours
{
    // calculates hours, by the difference in starttime and endtime
    NSTimeInterval distanceBetweenDates = [endTime timeIntervalSinceDate:startTime];
    double secondsInAnHour = 3600;
    double dbhours = (distanceBetweenDates / secondsInAnHour);
    hours = [[NSDecimalNumber alloc] initWithDouble:(dbhours)];
}

	
@end
