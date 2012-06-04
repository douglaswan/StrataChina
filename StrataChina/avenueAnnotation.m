//
//  avenueAnnotation.m
//  StrataChina
//
//  Created by Douglas Wan on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "avenueAnnotation.h"

@implementation avenueAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinColor;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subtitle:(NSString *)paramSubtitle
{
    self = [super init];
    
    if (self != nil)
    {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubtitle;
    }
    return self;
}

@end
