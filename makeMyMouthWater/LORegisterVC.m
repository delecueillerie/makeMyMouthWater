//
//  LORegisterVC.m
//  loginMenu
//
//  Created by Olivier Delecueillerie on 06/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "LORegisterVC.h"
#import <Parse/Parse.h>
#import "EDRootVC.h"
#import "LOInterfaceController.h"

@interface LORegisterVC ()

@end

@implementation LORegisterVC

@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}


#pragma mark IB Actions

////Sign Up Button pressed
-(IBAction)signUpUserPressed:(id)sender
{
    PFUser *user = [PFUser user];
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self postLoginAction];
                   } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    
    
}

- (void) postLoginAction {

    //No synchronization yet because it is a fresh new user
#warning demo database could be useful


    //The registration was succesful, go to the next slide
    LOInterfaceController *interface = [[LOInterfaceController alloc]init];
    interface.currentVC = self;
    [interface openTheNextVC:[[EDRootVC alloc]init] withIPadStoryboard:@"editionTableView_iPad" withIPhoneStoryboard:@"editionTableView_iPhone" inBundle:nil witViewIdentifier:@"root"];



}




@end
