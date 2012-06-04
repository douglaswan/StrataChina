//
//  FirstSecondViewController.m
//  StrataChina
//
//  Created by Douglas Wan on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstSecondViewController.h"

@interface FirstSecondViewController ()

@end

@implementation FirstSecondViewController

@synthesize sessionName;
@synthesize sessionTime;
@synthesize sessionSite;
@synthesize sessionSpeakers;
@synthesize sessionAbstract;
@synthesize sessionId;

@synthesize shareItemsActionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void) shareButtonTapped
{
    self.shareItemsActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Twitter", @"Email", @"加入日历", nil];
    [self.shareItemsActionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
        
        NSString *twitterText = [[NSString alloc] initWithFormat:@"I am seeing %@. #strataconf", self.sessionName.text];
        [twitterController setInitialText:twitterText];
        NSString *twitterSessionURLString = @"http://localhost/webProjects/strata/trunk/strata2012/public/index.php?func=session&id=";
        [twitterSessionURLString stringByAppendingString:[self.sessionId stringValue]];
        NSURL *twitterSessionURL = [NSURL URLWithString:twitterSessionURLString];
        [twitterController addURL:twitterSessionURL];
        [self.navigationController presentModalViewController:twitterController
                                                     animated:YES];
    }
    
    if (buttonIndex == 1)
    {
        NSLog(@"email");
    }
    
    if (buttonIndex == 2)
    {
        NSLog(@"Calendars");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0,5,25,25)];
    UIImage *shareButtonImage = [UIImage imageNamed:@"shareButton.png"];
    [shareButton setImage:shareButtonImage
                 forState:UIControlStateNormal];
    [shareButton addTarget:self
                    action:@selector(shareButtonTapped)
          forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:shareButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
