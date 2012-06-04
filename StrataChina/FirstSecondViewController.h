//
//  FirstSecondViewController.h
//  StrataChina
//
//  Created by Douglas Wan on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Twitter/Twitter.h>

@interface FirstSecondViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UILabel *sessionName;
@property (nonatomic, retain) IBOutlet UILabel *sessionTime;
@property (nonatomic, retain) IBOutlet UILabel *sessionSite;
@property (nonatomic, retain) IBOutlet UILabel *sessionSpeakers;
@property (nonatomic, retain) IBOutlet UIWebView *sessionAbstract;
@property (nonatomic, retain) NSNumber *sessionId;

@property (nonatomic, retain) UIActionSheet *shareItemsActionSheet;

@end
