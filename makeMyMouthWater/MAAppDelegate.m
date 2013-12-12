//
//  MAAppDelegate.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 11/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MAAppDelegate.h"
#import "ODViewController.h"
#import "LOLoginVC.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>


#warning lauch the initial set up after a login
@interface MAAppDelegate()
@property (strong, nonatomic) ODViewController *viewController;
@end

@implementation MAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //loginParse app
    [Parse setApplicationId:@"C2XRFUHGSMgrAK1Cd3qa1DQkgDiqR4f0T2bMlu5l"
                  clientKey:@"j5niQANFTgraWoRj1GMXsyOHpXehcZgFSMOUoxbP"];

 //   [[SYSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Drink class]];
    //introTuto app
#warning to de-comment
    //[self introTutoInit];
    [self launchTheGoodUI];
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
#warning todelete
    // [[SYSyncEngine sharedEngine] startSync];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////////////////////////////////////////////////////////////
//Choose wich storyboard to launch
////////////////////////////////////////////////////////////////
- (void) launchTheGoodUI {
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"nextLaunchKey"];
    UIViewController *VC;
    //VC = [[UIStoryboard storyboardWithName:[self goodStoryboardAndIdentifier:index][0] bundle:NULL] instantiateViewControllerWithIdentifier:[self goodStoryboardAndIdentifier:index][1]];
    VC = [[UIStoryboard storyboardWithName:@"AD_iPad" bundle:NULL] instantiateViewControllerWithIdentifier:@"SVC"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
}

- (NSArray *) goodStoryboardAndIdentifier:(NSInteger)module {
        switch (module) {

            case 0:
                //First launch of the app (new instal, update ...). We want to give an idea of the goal of the app, thus we launch the introTuto part
                return [NSArray arrayWithObjects:[self goodExtensionForStoryboard:@"introTuto"],@"main",nil];
                break;
            case 1:
                // After a delog, or when no user is login
                return [NSArray arrayWithObjects:[self goodExtensionForStoryboard:@"login"], @"register",nil];
                break;
            case 2:
                //First launch of the app (new instal, update ...). We want to give an idea of the goal of the app, thus we launch the introTuto part
                return [NSArray arrayWithObjects:[self goodExtensionForStoryboard:@"editionTableView"], @"EDRootVC",nil];
                break;
            default:
                return [NSArray arrayWithObjects:[self goodExtensionForStoryboard:@"introTuto"],@"child",nil];
                break;
        }
}
- (NSString *) goodExtensionForStoryboard:(NSString*) storyboard {
    NSMutableString * mutableStoryboard = [NSMutableString stringWithString:storyboard];
    if (IPAD) [mutableStoryboard appendString:@"_iPad"];
    else [mutableStoryboard appendString:@"_iPhone"];
    return (NSString *)mutableStoryboard;
}

@end
