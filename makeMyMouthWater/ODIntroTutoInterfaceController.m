//
//  introTutoInterfaceController.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 26/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "ODIntroTutoInterfaceController.h"
#import <UIKit/UIKit.h>

@interface ODIntroTutoInterfaceController()

@property (strong, nonatomic) UIWindow *window;


@end

@implementation ODIntroTutoInterfaceController
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

- (void) proButton {
 
    UIViewController *VC;
    VC = [[UIStoryboard storyboardWithName:[self goodExtensionForStoryboard:@"login"] bundle:nil] instantiateViewControllerWithIdentifier:@"register"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
}


- (void) clientButton {

}






- (NSString *) goodExtensionForStoryboard:(NSString*) storyboard {
    NSMutableString * mutableStoryboard = [NSMutableString stringWithString:storyboard];
    if (IPAD) [mutableStoryboard appendString:@"_iPad"];
    else [mutableStoryboard appendString:@"_iPhone"];
    return (NSString *)mutableStoryboard;
}
@end