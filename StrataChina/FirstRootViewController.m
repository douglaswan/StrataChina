//
//  FirstViewController.m
//  StrataChina
//
//  Created by Douglas Wan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstRootViewController.h"

#import "FirstSecondViewController.h"

#import "Sessions.h"

@interface FirstRootViewController ()

@end

@implementation FirstRootViewController

@synthesize firstTableView;
@synthesize scheduleArray;

@synthesize scheduleTableCell;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"日程表";
        self.tabBarItem.image = [UIImage imageNamed:@"137-presentation.png"];
        
        UIImage *backroundImageNavigationBar = [UIImage imageNamed:@"navbar.png"];
        // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setBackgroundImage:backroundImageNavigationBar
                                           forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = nil;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:nil];
        backButton.tintColor = [UIColor redColor];
        
        self.navigationItem.BackBarButtonItem = backButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)
                                                       style:UITableViewStylePlain];
    
    self.firstTableView.rowHeight = 64;
    //self.firstTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.firstTableView.dataSource = self;
    self.firstTableView.delegate = self;
    
    [self.view addSubview:self.firstTableView];
    
    //read Data from Core Data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    self.scheduleArray = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                  error:&requestError];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    if ([tableView isEqual:self.firstTableView])
    {
        result = 1;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if ([tableView isEqual:self.firstTableView])
    {
        result = [self.scheduleArray count];

    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"scheduleTableCell" owner:self options:nil];
        cell = scheduleTableCell;
        self.scheduleTableCell = nil;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_cell_gradient_large.png"] autorelease]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [[self.scheduleArray objectAtIndex:indexPath.row] name];
    
    label = (UILabel *) [cell viewWithTag:2];
    label.text = [[self.scheduleArray objectAtIndex:indexPath.row] speaker];
    
    label = (UILabel *) [cell viewWithTag:3];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *time_startString = [dateFormatter stringFromDate:[[self.scheduleArray objectAtIndex:indexPath.row] time_start]];
    label.text = time_startString;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.firstTableView]) 
    {
        //NSLog(@"%@", [NSString stringWithFormat:@"Cell %ld in Section %ld is selected",
        //              (long)indexPath.row, (long)indexPath.section]);
        
        FirstSecondViewController *firstSecondViewController = [[FirstSecondViewController alloc]
                                                                initWithNibName:nil
                                                                bundle:NULL];

        [self.navigationController pushViewController:firstSecondViewController
                                             animated:YES];
        
        firstSecondViewController.sessionName.text = [NSString stringWithString:[[self.scheduleArray objectAtIndex:indexPath.row] name]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSString *time_startString = [dateFormatter stringFromDate:[[self.scheduleArray objectAtIndex:indexPath.row] time_start]];
        firstSecondViewController.sessionTime.text = time_startString;
        firstSecondViewController.sessionSite.text = [[self.scheduleArray objectAtIndex:indexPath.row] site];
        firstSecondViewController.sessionSpeakers.text = [[self.scheduleArray objectAtIndex:indexPath.row] speaker];
        NSData *abstractData = [[[self.scheduleArray objectAtIndex:indexPath.row] abstract] dataUsingEncoding:NSUTF8StringEncoding];
        [firstSecondViewController.sessionAbstract loadData:abstractData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        firstSecondViewController.sessionId = [[self.scheduleArray objectAtIndex:indexPath.row] id];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.firstTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
