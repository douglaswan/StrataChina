//
//  Sessions.h
//  StrataChina
//
//  Created by Douglas Wan on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sessions : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * in_one_sentance;
@property (nonatomic, retain) NSNumber * keynote;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSString * speaker;
@property (nonatomic, retain) NSString * sponsor;
@property (nonatomic, retain) NSNumber * tea_break;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSDate * time_start;
@property (nonatomic, retain) NSString * track;

@end
