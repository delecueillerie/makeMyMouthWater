//
//  LOLoginVC.m
//  loginMenu
//
//  Created by Olivier Delecueillerie on 06/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "LOLoginVC.h"
#import <Parse/Parse.h>
#import "EDRootVC.h"

@interface LOLoginVC ()

@end

@implementation LOLoginVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


//Login button pressed
-(IBAction)logInPressed:(id)sender

{
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self openTheNextVC:[[EDRootVC alloc]init] withIPadStoryboard:@"editionTableView_iPad" withIPhoneStoryboard:@"editionTableView_iPhone" inBundle:nil witViewIdentifier:@"root"];
                    } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (void) openTheNextVC:(UIViewController*)VC withIPadStoryboard:(NSString*)ipadStory withIPhoneStoryboard:(NSString*)iphoneStory inBundle:(NSBundle*)bundle witViewIdentifier:(NSString *)id {
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    if (IPAD) {
        VC = [[UIStoryboard storyboardWithName:ipadStory bundle:bundle] instantiateViewControllerWithIdentifier:id];
    } else {
        VC = [[UIStoryboard storyboardWithName:iphoneStory bundle:bundle] instantiateViewControllerWithIdentifier:id];
    }
    [self presentViewController:VC animated:YES completion:nil];

}


@end
