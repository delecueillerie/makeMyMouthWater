//
//  ODChildVC.h
//  introTutoScreen
//
//  Created by Olivier Delecueillerie on 04/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODChildVC : UIViewController

@property (nonatomic, strong) UIImage *imageToDisplay;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *labelToDisplay;
@property (nonatomic, strong) NSString *textToDisplay;
@end
