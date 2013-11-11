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
    
    ODChildVC *childViewController = [[ODChildVC alloc] initWithNibName:@"ODChildView" bundle:nil];
    childViewController.index = index;
    NSArray *array = [self pageContent:index];
    childViewController.imageToDisplay = array[0];
    childViewController.labelToDisplay = array[1];
    childViewController.textToDisplay = array[2];
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
//PAGE CONTROL DELEGATE & UI POSITION
///////////////////////////////////////////////////////////////////////////
/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
*/

///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
//Get the images to display within the pageview
///////////////////////////////////////////////////////////////////////////

- (NSArray *) pageContent :(NSInteger)index {
    
    UIImage *image1 = [UIImage imageNamed:@"cuisine.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"bar.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"bouteille.jpg"];
    UIImage *image4 = [UIImage imageNamed:@"table.jpg"];

    NSString *label1 = @"Découvrez les propositions du chef";
    NSString *label2 = @"Découvrez la carte du barman";
    NSString *label3 = @"Facilitez votre choix";
    NSString *label4 = @"Plus présent et tellement moins oppressant";
    
    NSString *text1 = @"Selon le marché et les choix du chef la carte du restaurant est toujours à jour et les prix actualisés au quotidien. Si la météo n'est pas de la partie ou que des réservations sont annulées en dernière minute, le patron saura faire des offres flash pour ne pas gacher des plats mijotés qui n'attendent que vous";
    NSString *text2 = @"Cocktail sophistiqué, Champagne ou pression bien fraiche, cette carte vous devoilera toute la cave en un clin d'oeil, et surtout ne vous déplacez plus pour commander";
    NSString *text3 = @"Vieux Rhum de Cuba ou Whisky de Ballycoolin aprenez toutes les caractéristique de votre elixir pour une dégustation reussie";
    NSString *text4 = @"Profitez de votre partenaire, de vos amis et redecouvrez le plaisir d'être servi. Ne cherchez plus le regard du serveur vous pouvez maintenant communiquer avec lui par télépathie. Et si vous n'avez pas reservé vous savez immédiatement où une table est libre pour vous accueillir";
    
    NSArray *array;
    
    switch (index) {
        case 0:
            array = [NSArray arrayWithObjects:image1,label1,text1,nil];
            break;
        case 1:
            array = [NSArray arrayWithObjects:image2,label2,text2,nil];
            break;
        case 2:
            array = [NSArray arrayWithObjects:image3,label3,text3,nil];
            break;
        default:
            array = [NSArray arrayWithObjects:image4,label4,text4,nil];
            break;
    }
    return array;
}




@end
