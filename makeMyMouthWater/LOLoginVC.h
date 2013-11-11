//
//  LOLoginVC.h
//  loginMenu
//
//  Created by Olivier Delecueillerie on 06/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOLoginVC : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;


-(IBAction)logInPressed:(id)sender;
@end
