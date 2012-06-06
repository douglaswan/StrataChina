//
//  SecondViewController.m
//  StrataChina
//
//  Created by Douglas Wan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondRootViewController.h"

#import "Speakers.h"

@interface SecondRootViewController ()

@end

@implementation SecondRootViewController

@synthesize secondTableView;
@synthesize speakerArray;

@synthesize speakerTableCell;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"嘉宾";
        self.tabBarItem.image = [UIImage imageNamed: @"TABartists.png"];
        
        UIImage *backroundImageNavigationBar = [UIImage imageNamed:@"navbar.png"];
        // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setBackgroundImage:backroundImageNavigationBar
                                           forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.title = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.secondTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                        style:UITableViewStylePlain];
    
    self.secondTableView.rowHeight = 64;
    self.secondTableView.dataSource = self;
    self.secondTableView.delegate = self;
    
    //prevent the Tab bar covering the last cell of the tableView.
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 90)];
    footer.backgroundColor = [UIColor clearColor];
    self.secondTableView.tableFooterView = footer;

    [self.view addSubview:self.secondTableView];
    
    //read speakers from Core Data
    NSFetchRequest *readingSpeakersFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *speakersEntity = [NSEntityDescription entityForName:@"Speakers"
                                                      inManagedObjectContext:self.managedObjectContext];
    [readingSpeakersFetchRequest setEntity:speakersEntity];
    NSError *readingSpeakersError = nil;
    self.speakerArray = [self.managedObjectContext executeFetchRequest:readingSpeakersFetchRequest
                                                                 error:&readingSpeakersError];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    if ([tableView isEqual:self.secondTableView])
    {
        result = 1;
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if ([tableView isEqual:self.secondTableView])
    {
        result = [self.speakerArray count];
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondTableViewCellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondTableViewCellIdentifier];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"speakerTableCell"
                                      owner:self
                                    options:nil];
        cell = speakerTableCell;
        self.speakerTableCell = nil;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_cell_gradient_large.png"] autorelease]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSMutableString *speakerimageURLString = [[NSMutableString alloc] initWithString:@"http://localhost/webProjects/strata/trunk/strata2012/public/images/"];
    [speakerimageURLString appendString:[[self.speakerArray objectAtIndex:indexPath.row] photo_filename]];
    
    NSURL *speakerImageURL = [[NSURL alloc] initWithString:speakerimageURLString];
    NSData *speakerImageData = [[NSData alloc] initWithContentsOfURL:speakerImageURL];
    UIImage *speakerUIImage = [UIImage imageWithData:speakerImageData];
    UIImageView *imageViewInCell = [[UIImageView alloc] initWithImage:speakerUIImage];
//    imageViewInCell.contentMode = UIViewContentModeScaleToFill;
//    imageViewInCell = (UIImageView *) [cell viewWithTag:0];
//    imageViewInCell.image = speakerUIImage;
    imageViewInCell.frame = CGRectMake(0, 0, 30, 40);
    cell.accessoryView = imageViewInCell;
        
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [[self.speakerArray objectAtIndex:indexPath.row] name];
    
    NSMutableString *titleAndEmployerNSString = [[NSMutableString alloc] initWithString:[[self.speakerArray objectAtIndex:indexPath.row] title]];
    [titleAndEmployerNSString appendString:@", "];
    [titleAndEmployerNSString appendString:[[self.speakerArray objectAtIndex:indexPath.row] employer]];
    label = (UILabel *) [cell viewWithTag:2];
    label.text = titleAndEmployerNSString;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.secondTableView = nil;
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
