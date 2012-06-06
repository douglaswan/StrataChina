//
//  AppDelegate.m
//  StrataChina
//
//  Created by Douglas Wan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstRootViewController.h"
#import "SecondRootViewController.h"
#import "ThirdRootViewController.h"

#import "Sessions.h"
#import "Speakers.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize firstNavigationController;
@synthesize firstRootViewController;
@synthesize secondNavigationController;
@synthesize secondRootViewController;
@synthesize thirdNavigationController;
@synthesize thirdRootViewController;
@synthesize tabBarController;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
    [_window release];
    
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //Update entities of Sessions and Speakers.
    UIImage *startingBackgroundImage = [UIImage imageNamed:@"default.png"];
    UIImageView *startingBackgroundView = [[UIImageView alloc] initWithImage:startingBackgroundImage];
    [self.window addSubview:startingBackgroundView];
    
    NSString *urlAsString = @"http://localhost/webProjects/strata/trunk/strata2012/apis/read_schedule.php";
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *scheduleJSONData = [NSData dataWithContentsOfURL:url];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([scheduleJSONData length] == 0)
    {
        NSLog(@"Error: got nothing of sessions!");
                
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *readingError = nil;
        NSArray *oldSessions = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                        error:&readingError];
        if ((readingError !=nil) || ([oldSessions count] <= 0))
        {
            UIAlertView *loadingErrorAlterView = [[UIAlertView alloc] initWithTitle:@"Loading Error"
                                                                            message:@"网络故障？没有缓存？"
                                                                           delegate:nil
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"OK", nil];
            [loadingErrorAlterView show];
        }
    }
    else
    {
        NSError *deserializingJSONError = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:scheduleJSONData
                         options:NSJSONReadingAllowFragments
                         error:&deserializingJSONError];
        
        if (jsonObject != nil &&
            deserializingJSONError == nil)
        {
            //NSLog(@"Successfully deserialized...");
            
            //clean the managedObjectContext
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sessions"
                                                      inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError *readingError = nil;
            NSArray *oldSessions = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                            error:&readingError];
            if (readingError != nil)
            {
                NSLog(@"Reading old sessions error:%@",readingError);
            }
            
            for (id object in oldSessions)
            {
                [self.managedObjectContext deleteObject:object];
                
                if (![object isDeleted])
                {
                    NSLog(@"Failed to delete a row.");
                }
            }
            
            NSError *savingBlankError = nil;
            [self.managedObjectContext save:&savingBlankError];
            if (savingBlankError != nil)
            {
                NSLog(@"Failed to save blanks to Core Data:%@", savingBlankError);
            }
            
            //Insert all new records into Core Data
            for (id object in (NSMutableArray *)jsonObject)
            {
                Sessions *session = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Sessions"
                                     inManagedObjectContext:self.managedObjectContext];
                
                if (session != nil)
                {
                    session.id = [NSNumber numberWithInt:[[object objectForKey:@"id"] intValue]];
                    session.name = [object objectForKey:@"name"];
                    session.speaker = [object objectForKey:@"speaker"];
                    session.site = [object objectForKey:@"site"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    session.time_start = [dateFormatter dateFromString: [object objectForKey:@"time_start"]];
                    session.abstract = [object objectForKey:@"abstract"];
                    
                    NSError *savingError = nil;
                    [self.managedObjectContext save:&savingError];
                    if (savingError != nil)
                    {
                        NSLog(@"Failed to save the context. Error = %@", savingError);
                    }
                }
                else
                {
                    NSLog(@"Failed to create a session.");
                }
            }
        }
        else if (deserializingJSONError != nil)
        {
            NSLog(@"An error happened while deserializing the JSON data! = %@", deserializingJSONError);
        }
    }
    
    NSString *speakersURLAsString = @"http://localhost/webProjects/strata/trunk/strata2012/apis/read_speakers.php";
    NSURL *urlOfSpeakers = [NSURL URLWithString:speakersURLAsString];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *speakerJSONData = [NSData dataWithContentsOfURL:urlOfSpeakers];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([speakerJSONData length] == 0)
    {
        NSLog(@"Error: got nothing of speakers!");
        
        NSFetchRequest *speakerFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entitySpeaker = [NSEntityDescription entityForName:@"Speakers"
                                                         inManagedObjectContext:self.managedObjectContext];
        [speakerFetchRequest setEntity:entitySpeaker];
        NSError *readingSpeakerError = nil;
        NSArray *oldSpeakers = [self.managedObjectContext executeFetchRequest:speakerFetchRequest
                                                                        error:&readingSpeakerError];
        
        if ((readingSpeakerError != nil) || ([oldSpeakers count] <= 0))
        {
            UIAlertView *loadingSpeakerErrorAlterView = [[UIAlertView alloc] initWithTitle:@"Loading Speakers Error"
                                                                                   message:@"网络故障？没有缓存？"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:nil
                                                                         otherButtonTitles:@"OK", nil];
            [loadingSpeakerErrorAlterView show];
        }
    }
    else
    {
        NSError *speakerDeserializingJSONError = nil;
        id speakerJSONObject = [NSJSONSerialization
                                JSONObjectWithData:speakerJSONData
                                options:NSJSONReadingAllowFragments
                                error:&speakerDeserializingJSONError];
        
        if (speakerJSONObject != nil && speakerDeserializingJSONError == nil)
        {
            //NSLog(@"Successfully deserialized the JSON data of speakers!");
            
            //clean the entity of speakers in the managedObjectContext
            NSFetchRequest *speakerFetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *speakerEntity = [NSEntityDescription entityForName:@"Speakers"
                                                             inManagedObjectContext:self.managedObjectContext];
            [speakerFetchRequest setEntity:speakerEntity];
            NSError *readingSpeakerError = nil;
            NSArray *oldSpeakers = [self.managedObjectContext executeFetchRequest:speakerFetchRequest
                                                                            error:&readingSpeakerError];
            if (readingSpeakerError != nil)
            {
                NSLog(@"Reading old speakers error:%@", readingSpeakerError);
            }
            
            for (id object in oldSpeakers)
            {
                [self.managedObjectContext deleteObject:object];
                
                if (![object isDeleted])
                {
                          NSLog(@"Failed to delete a row.");
                }
            }
            
            NSError *savingBlankstoSpeakerEntityError = nil;
            [self.managedObjectContext save:&savingBlankstoSpeakerEntityError];
            if (savingBlankstoSpeakerEntityError != nil)
            {
                NSLog(@"Failed to save blanks to speaker entity in Core Data:%@", savingBlankstoSpeakerEntityError);
            }
            
            //Insert all new speakers into Core Data
            for (id object in speakerJSONObject)
            {
                Speakers *speaker = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Speakers"
                                     inManagedObjectContext:self.managedObjectContext];
                
                if (speaker != nil)
                {
                    speaker.id = [NSNumber numberWithInt:[[object objectForKey:@"id"] intValue]];
                    speaker.name = [object objectForKey:@"name"];
                    speaker.session = [object objectForKey:@"session"];
                    speaker.autobio = [object objectForKey:@"autobio"];
                    speaker.title = [object objectForKey:@"title"];
                    speaker.employer = [object objectForKey:@"employer"];
                    speaker.photo_filename = [object objectForKey:@"photo_filename"];
                    
                    NSError *speakerSavingError = nil;
                    [self.managedObjectContext save:&speakerSavingError];
                    if (speakerSavingError != nil)
                    {
                        NSLog(@"Failed to save speakers into Core Data. Error = %@", speakerSavingError);
                    }
                }
                else
                {
                    NSLog(@"Failed to create a speaker.");
                }

            }
        }
        else if (speakerDeserializingJSONError != nil)
        {
            NSLog(@"An error happened while deserailizing the JSON data of speakers: %@", speakerDeserializingJSONError);
        }
    }
    
    self.firstRootViewController = [[FirstRootViewController alloc] initWithNibName:nil bundle:NULL];
    self.firstNavigationController = [[UINavigationController alloc]
                                      initWithRootViewController:self.firstRootViewController];
    
    self.secondRootViewController = [[SecondRootViewController alloc] initWithNibName:nil bundle:NULL];
    self.secondNavigationController = [[UINavigationController alloc]
                                       initWithRootViewController:self.secondRootViewController];
    
    self.thirdRootViewController = [[ThirdRootViewController alloc] initWithNibName:nil bundle:NULL];
    self.thirdNavigationController = [[UINavigationController alloc]
                                      initWithRootViewController:self.thirdRootViewController];
    
    NSArray *navControllers = [[NSArray alloc]
                               initWithObjects:self.firstNavigationController,
                               self.secondNavigationController,
                               self.thirdNavigationController,
                               nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:navControllers];
    
    [self.window addSubview:self.tabBarController.view];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self saveContext];
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
