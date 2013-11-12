//
//  EDEditVC.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "EDEditVC.h"

@interface EDEditVC ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, readonly, getter=isEditingDate) BOOL editingDate;
@end

@implementation EDEditVC

{
    BOOL _hasDeterminedWhetherEditingDate;
    BOOL _editingDate;
}

///////////////////////////////////////////////////////////////////////////////////
//VIEW LIFECYCLE
///////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    // Set the title to the user-visible name of the field.
    self.title = self.editedFieldName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure the user interface according to state.
    if (self.editingDate) {
        
        self.textField.hidden = YES;
        self.datePicker.hidden = NO;
        NSDate *date = [self.editedObject valueForKey:self.editedFieldKey];
        if (date == nil) {
            date = [NSDate date];
        }
        self.datePicker.date = date;
    }
    else {
        
        self.textField.hidden = NO;
        self.datePicker.hidden = YES;
        self.textField.text = [self.editedObject valueForKey:self.editedFieldKey];
        self.textField.placeholder = self.title;
        [self.textField becomeFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////
//SAVE AND CANCEL OPERATIONS
///////////////////////////////////////////////////////////////////////////////////

- (IBAction)save:(id)sender
{
    // Set the action name for the undo operation.
    NSUndoManager * undoManager = [[self.editedObject managedObjectContext] undoManager];
    [undoManager setActionName:[NSString stringWithFormat:@"%@", self.editedFieldName]];
    
    // Pass current value to the edited object, then pop.
    if (self.editingDate) {
        [self.editedObject setValue:self.datePicker.date forKey:self.editedFieldKey];
    }
    else {
        [self.editedObject setValue:self.textField.text forKey:self.editedFieldKey];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender
{
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Manage whether editing a date

- (void)setEditedFieldKey:(NSString *)editedFieldKey
{
    if (![_editedFieldKey isEqualToString:editedFieldKey]) {
        _hasDeterminedWhetherEditingDate = NO;
        _editedFieldKey = editedFieldKey;
    }
}


- (BOOL)isEditingDate
{
    if (_hasDeterminedWhetherEditingDate == YES) {
        return _editingDate;
    }
    
    NSEntityDescription *entity = [self.editedObject entity];
    NSAttributeDescription *attribute = [entity attributesByName][self.editedFieldKey];
    NSString *attributeClassName = [attribute attributeValueClassName];
    
    if ([attributeClassName isEqualToString:@"NSDate"]) {
        _editingDate = YES;
    }
    else {
        _editingDate = NO;
    }
    
    _hasDeterminedWhetherEditingDate = YES;
    return _editingDate;
}





@end
