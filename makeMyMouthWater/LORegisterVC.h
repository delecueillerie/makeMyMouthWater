//
//  LORegisterVC.h
//  loginMenu
//
//  Created by Olivier Delecueillerie on 06/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LORegisterVC : UIViewController
@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;


-(IBAction)signUpUserPressed:(id)sender;
@end
