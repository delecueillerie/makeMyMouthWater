//
//  EDAppDelegate.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "EDAppDelegate.h"
#import "DBCoreDataStack.h"
#import "EDRootVC.h"

@interface EDAppDelegate()

@property (nonatomic, strong) DBCoreDataStack *coreDataStack;

@end

@implementation EDAppDelegate

////////////////////////////////////////////////////////////////////////
//LAZY INSTANCIATION
////////////////////////////////////////////////////////////////////////
- (DBCoreDataStack*) coreDataStack {
    if (!_coreDataStack) _coreDataStack = [[DBCoreDataStack alloc]init];
    return _coreDataStack;
}

////////////////////////////////////////////////////////////////////////
//LIFE CYCLE APPLICATION
////////////////////////////////////////////////////////////////////////
							
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    EDRootVC *rootViewController = (EDRootVC *)[[navigationController viewControllers] objectAtIndex:0];
    rootViewController.managedObjectContext = self.coreDataStack.managedObjectContext;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.coreDataStack saveContext];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.coreDataStack saveContext];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.coreDataStack saveContext];
}








@end
