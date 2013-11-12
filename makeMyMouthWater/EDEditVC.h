//
//  EDEditVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EDEditVC : UIViewController

@property (nonatomic, strong) NSManagedObject *editedObject;
@property (nonatomic, strong) NSString *editedFieldKey;
@property (nonatomic, strong) NSString *editedFieldName;
@end
