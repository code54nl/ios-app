//
//  TimeRow.h
//  Uurapp
//
//  Created by Code54 on 3/8/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeRow : NSObject{
    NSString *id;
    NSString *startTime;
    NSString *endTime;
    NSString *hours;
    NSString *activityID;
    NSString *activityAbbrv;
    NSString *organizationID;
    NSString *addressID;
    NSString *organizationAbbrv;
    NSString *projectPhaseAbbrv;
    NSString *projectAbbrv;
    NSString *projectPhaseID;
    NSString *remarks;
    NSString *description;
    BOOL declared;
}

@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *startTime;
@property(nonatomic,retain)NSString *endTime;
@property(nonatomic,retain)NSString *hours;
@property(nonatomic,retain)NSString *activityID;
@property(nonatomic,retain)NSString *activityAbbrv;
@property(nonatomic,retain)NSString *organizationID;
@property(nonatomic,retain)NSString *addressID;
@property(nonatomic,retain)NSString *organizationAbbrv;
@property(nonatomic,retain)NSString *projectPhaseAbbrv;
@property(nonatomic,retain)NSString *projectAbbrv;
@property(nonatomic,retain)NSString *projectPhaseID;
@property(nonatomic,retain)NSString *remarks;
@property(nonatomic,retain)NSString *description;
@property(nonatomic)BOOL declared;

@end
