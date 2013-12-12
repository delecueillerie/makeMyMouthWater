//
//  LOInterfaceController.m
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 27/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "LOInterfaceController.h"

@implementation LOInterfaceController





- (void) openTheNextVC:(UIViewController*)VC withIPadStoryboard:(NSString*)ipadStory withIPhoneStoryboard:(NSString*)iphoneStory inBundle:(NSBundle*)bundle witViewIdentifier:(NSString *)id {
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    if (IPAD) {
        VC = [[UIStoryboard storyboardWithName:ipadStory bundle:bundle] instantiateViewControllerWithIdentifier:id];
    } else {
        VC = [[UIStoryboard storyboardWithName:iphoneStory bundle:bundle] instantiateViewControllerWithIdentifier:id];
    }
    [self.currentVC presentViewController:VC animated:YES completion:nil];

}
@end
