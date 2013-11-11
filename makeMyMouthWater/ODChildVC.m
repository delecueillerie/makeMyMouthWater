//
//  ODChildVC.m
//  introTutoScreen
//
//  Created by Olivier Delecueillerie on 04/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "ODChildVC.h"
#import "LORegisterVC.h"

@interface ODChildVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ODChildVC


- (void) viewDidAppear:(BOOL)animated {
    self.imageView.image = self.imageToDisplay;
    self.imageView.frame=self.view.frame;
    self.labelView.text=self.labelToDisplay;
    self.textView.text=self.textToDisplay;
    self.textView.editable=NO;
    [self updatePageControl:self.pageControl];
}



- (void) updatePageControl:(UIPageControl *)pageControl {
    pageControl.numberOfPages = 4;
    pageControl.currentPage = self.index;
    
}

- (IBAction)createMenu:(id)sender {
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

    LORegisterVC *registerVC;
    if (IPAD) {
    registerVC = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:NULL] instantiateViewControllerWithIdentifier:@"navLogin"];
    } else {
    registerVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:@"navLogin"];
    }
    [self presentViewController:registerVC animated:YES completion:nil];
    
    
}

@end
