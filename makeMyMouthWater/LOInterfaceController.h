//
//  LOInterfaceController.h
//  makeMyMouthWater
//
//  Created by Olivier Delecueillerie on 27/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOInterfaceController : NSObject


@property (nonatomic, strong) UIViewController *currentVC;
- (void) openTheNextVC:(UIViewController*)VC withIPadStoryboard:(NSString*)ipadStory withIPhoneStoryboard:(NSString*)iphoneStory inBundle:(NSBundle*)bundle witViewIdentifier:(NSString *)id ;

@end
