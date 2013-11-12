//
//  EDDetailVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "Drink.h"

@interface EDDetailVC : UITableViewController
@property (nonatomic, strong) Drink *drink;

@end


// These methods are used by the AddViewController, so are declared here, but they are private to these classes.

@interface EDDetailVC (Private)

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
@end
