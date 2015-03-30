//
//  CalendarData.m
//  ECHackDemoApp
//
//  Created by Administrator on 3/30/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "CalendarData.h"


@implementation CalendarData{
    
}

@synthesize calendarDictionary;

- (id) init{
    [self loadCalendarData];
    return self;
}

- (void) loadCalendarData{
    
    //Find calendar data in plist file and load to calendar dictionary.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [directoryPaths objectAtIndex:0];
    NSString *userDataPath = [documentsPath stringByAppendingPathComponent:@"UserData.plist"];
    
    //look for plist in documents, if not there, retrieve from mainBundle
    if (![fileManager fileExistsAtPath:userDataPath]){
        userDataPath = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"plist"];
    }
    
    NSData *userData = [fileManager contentsAtPath:userDataPath];
    NSError *error;
    NSPropertyListFormat format;
    NSMutableDictionary *userDataDictionary = (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:userData options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
    
    
    self.calendarDictionary = [userDataDictionary objectForKey:@"calendar"];
    
}

- (void) recordCalendarData: (NSDate*)date wage:(double)wage timeWorked: (NSString*)timeWorked {
    //When stop button is pressed, record new data to plist
    //date is NSString in format yyyymmdd
    //hours and wage are NSNumbers representing hours worked, and wage per hour
    //NOTE: 1 wage per day. Currently new wage will not override.
    
    NSArray *hoursAndMinutes = [timeWorked componentsSeparatedByString: @":"];
    if([hoursAndMinutes count]!=2){
        hoursAndMinutes = [timeWorked componentsSeparatedByString: @" "];
    }
    double hours = [hoursAndMinutes[0] doubleValue] + [hoursAndMinutes[1] doubleValue]/60;

    //add array back to calendar
    
    NSArray *newData = [NSArray arrayWithObjects: [NSNumber numberWithDouble:hours], [NSNumber numberWithDouble:wage], nil];
    [self.calendarDictionary setObject:newData forKey:date.description];
    
}

- (void) saveCalendarData {
    //Save calendar back to plist in documents
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [directoryPaths objectAtIndex:0];
    NSString *userDataPath = [documentsPath stringByAppendingPathComponent:@"UserData.plist"];
    NSDictionary *userData = [NSDictionary dictionaryWithObject:self.calendarDictionary forKey: @"calendar"];
    
    
    NSError *error;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:userData format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    [plistData writeToFile:userDataPath atomically:YES];
    
}

@end
