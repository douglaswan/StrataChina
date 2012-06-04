//
//  Speakers.h
//  StrataChina
//
//  Created by Douglas Wan on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Speakers : NSManagedObject

@property (nonatomic, retain) NSString * autobio;
@property (nonatomic, retain) NSString * employer;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_keynote;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo_filename;
@property (nonatomic, retain) NSString * session;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * website;

@end
