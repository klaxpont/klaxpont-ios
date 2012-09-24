//
//  AppDelegate.m
//  klaxpont
//
//  Created by François Benaiteau on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


// the four controllers
#import "RecordViewController.h"
#import "MyVideosViewController.h"
#import "TopVideosViewController.h"
#import "AccountViewController.h"
#import "NetworkManager.h"
#import "UserHelper.h"
#import "KlaxAppearance.h"
#import "BaseTabBarViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize fbSession = _fbSession;
@synthesize dailymotionSession = _dailymotionSession;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BaseTabBarViewController *tabBarController = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = tabBarController;
   
    // add ViewControllers
    RecordViewController *recordViewController = RecordViewController.new;
    MyVideosViewController *myVideosViewController = MyVideosViewController.new;
    TopVideosViewController *topVideosViewController = TopVideosViewController.new;
    AccountViewController *accountViewController = AccountViewController.new;
    
    myVideosViewController.managedObjectContext = [self managedObjectContext];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:myVideosViewController];
    tabBarController.viewControllers = @[recordViewController, navController, topVideosViewController, accountViewController];

    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetworkManager sharedManager] requestDailymotionToken];
    });
    [[self window] addSubview:tabBarController.view];
    NSLog(@"view image : %@", NSStringFromCGSize(    tabBarController.tabBar.frame.size));
	[[self window] makeKeyAndVisible];

    [KlaxAppearance applyStyle];  
    return YES;
}
				


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[UserHelper default] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // this means the user switched back to this app without completing a login in Safari/Facebook App
    if (self.fbSession.state == FBSessionStateCreatedOpening) {
        // BUG: for the iOS 6 preview we comment this line out to compensate for a race-condition in our
        // state transition handling for integrated Facebook Login; production code should close a
        // session in the opening state on transition back to the application; this line will again be
        // active in the next production rev
        //[self.session close]; // so we close our session and start over
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self.fbSession close];
    [[UserHelper default] save];
}

#pragma mark Facebook


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.fbSession handleOpenURL:url];
}

#pragma mark - Core Data

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    // used to retain this one, but we use ARC so just forget about it
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"klaxpont.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
