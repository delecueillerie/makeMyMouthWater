//
//  ODViewController.m
//  introTutoScreen
//
//  Created by Olivier Delecueillerie on 04/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "ODViewController.h"
#import "ODChildVC.h"

@interface ODViewController ()

@end

///////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
///////////////////////////////////////////////////////////////////////////

@implementation ODViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ODChildVC *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

///////////////////////////////////////////////////////////////////////////
//PAGE CREATION
///////////////////////////////////////////////////////////////////////////
- (ODChildVC *)viewControllerAtIndex:(NSUInteger)index {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"introTuto" bundle:nil];
    ODChildVC *childViewController = [storyboard instantiateViewControllerWithIdentifier:@"child"];

    childViewController.index = index;
    NSArray *array = [self pageContent:index];
    childViewController.portraitImage = array[0];
    childViewController.landscapeImage = array[1];
    childViewController.labelToDisplay = array[2];
    childViewController.textToDisplay = array[3];
    return childViewController;
    
}

///////////////////////////////////////////////////////////////////////////
//PAGEVIEW CONTROLLER DELEGATE
///////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ODChildVC *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ODChildVC *)viewController index];
    
    
    index++;
    
    if (index == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}


///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
//Get the images to display within the pageview
///////////////////////////////////////////////////////////////////////////

- (NSArray *) pageContent :(NSInteger)index {

    UIImage *landscape0 = [UIImage imageNamed:@"coverLandscape.png"];
    UIImage *landscape1 = [UIImage imageNamed:@"barLandscape.png"];
    UIImage *landscape2 = [UIImage imageNamed:@"bottleLandscape.png"];
    UIImage *landscape3 = [UIImage imageNamed:@"tableLandscape.png"];
    UIImage *landscape4 = [UIImage imageNamed:@"cuisineLandscape.png"];

    UIImage *portrait0 = [UIImage imageNamed:@"coverPortrait.png"];
    UIImage *portrait1 = [UIImage imageNamed:@"barPortrait.png"];
    UIImage *portrait2 = [UIImage imageNamed:@"bottlePortrait.png"];
    UIImage *portrait3 = [UIImage imageNamed:@"tablePortrait.png"];
    UIImage *portrait4 = [UIImage imageNamed:@"cuisinePortrait.png"];

    NSString *label0 = NSLocalizedString(@"label0", nil);
    NSString *label1 = NSLocalizedString(@"label1", nil);
    NSString *label2 = NSLocalizedString(@"label2", nil);
    NSString *label3 = NSLocalizedString(@"label3", nil);
    NSString *label4 = NSLocalizedString(@"label4", nil);

    NSString *text0 = NSLocalizedString(@"text0", nil);
    NSString *text1 = NSLocalizedString(@"text1", nil);
    NSString *text2 = NSLocalizedString(@"text2", nil);
    NSString *text3 = NSLocalizedString(@"text3", nil);
    NSString *text4 = NSLocalizedString(@"text4", nil);

    
    NSArray *array;
    
    switch (index) {
        case 0:
            array = [NSArray arrayWithObjects:portrait0, landscape0,label0,text0,nil];
            break;
        case 1:
            array = [NSArray arrayWithObjects:portrait1, landscape1,label1,text1,nil];
            break;
        case 2:
            array = [NSArray arrayWithObjects:portrait2, landscape2,label2,text2,nil];
            break;
        case 3:
            array = [NSArray arrayWithObjects:portrait3, landscape3,label3,text3,nil];
            break;
        default:
            array = [NSArray arrayWithObjects:portrait4, landscape4,label4,text4,nil];
            break;
    }
    return array;
}




@end
