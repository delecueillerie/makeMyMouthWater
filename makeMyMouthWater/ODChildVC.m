//
//  ODChildVC.m
//  introTutoScreen
//
//  Created by Olivier Delecueillerie on 04/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "ODChildVC.h"
#import "ODIntroTutoInterfaceController.h"

@interface ODChildVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ODChildVC


- (void) viewWillAppear:(BOOL)animated {
    self.imageView.image = [self theWellOrientatedImage];
    self.imageView.frame=self.view.frame;
    [self updatePageControl:self.pageControl];
    self.labelView.text=self.labelToDisplay;
    self.textView.text=self.textToDisplay;
    self.textView.editable=NO;

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.imageView.image = [self theWellOrientatedImage];
}


- (void) updatePageControl:(UIPageControl *)pageControl {
    pageControl.numberOfPages = 4;
    pageControl.currentPage = self.index;
}

//The background Image must fit the fullscreen bounds, such each time the device orientation change the background image must be updated.
- (UIImage *) theWellOrientatedImage {
    UIImage *theWellOrientedOne;
    if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait ) ||
        ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)) {
        theWellOrientedOne = self.portraitImage;
    } else {
        theWellOrientedOne = self.landscapeImage;
    }
    return theWellOrientedOne;
}

- (IBAction)pro:(UIButton*)sender {
    NSLog(@"pro touched");
    [[[ODIntroTutoInterfaceController alloc]init] proButton];
}

- (IBAction)client:(UIButton*)sender {
    [[[ODIntroTutoInterfaceController alloc ]init ]clientButton];
}


@end
