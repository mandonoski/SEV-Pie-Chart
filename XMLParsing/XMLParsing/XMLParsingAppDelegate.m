//
//  XMLParsingAppDelegate.m
//  XMLParsing
//
//  Created by Martin Andonovski on 4/9/13.
//  Copyright (c) 2013 Мartin. All rights reserved.
//
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#import "XMLParsingAppDelegate.h"

#import "XMLParsingViewController.h"

@implementation XMLParsingAppDelegate
@synthesize nameArray, attrArray,loading,messages,fromToArray,valueArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    loading.text = @"Loading";
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.center = CGPointMake((self.window.bounds.size.width-spinner.bounds.size.width)/2, ((self.window.bounds.size.height-loading.bounds.size.height)/3)*2);
    spinner.center = CGPointMake((self.window.bounds.size.width-loading.bounds.size.width)/2, ((self.window.bounds.size.height-spinner.bounds.size.height)/3)*2+(spinner.bounds.size.height)*2.3);
    [self.window addSubview:spinner];
    [spinner startAnimating];
    attrArray = [[NSMutableArray alloc] init];
    nameArray = [[NSMutableArray alloc] init];
    messages  = [[NSMutableArray alloc] init];
    fromToArray = [[NSMutableArray alloc] init];
    valueArray = [[NSMutableArray alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[XMLParsingViewController alloc] initWithNibName:@"XMLParsingViewController" bundle:nil];
    self.window.rootViewController = self.navigationController;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"header.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.window makeKeyAndVisible];
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
}

@end
