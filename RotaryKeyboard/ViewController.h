//
//  ViewController.h
//  RotaryKeyboard
//
//  Created by Kenneth Wigginton on 4/22/13.
//  Copyright (c) 2013 Ken Wigginton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryPickerView.h"

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) IBOutlet RotaryPickerView *rotaryPicker;
@property (nonatomic, retain) IBOutlet UITextView *textField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, retain) NSMutableString *wordBuffer;
-(IBAction) segButtonPushed:(id)sender;

@end
bool keyboardShown;
bool viewMoved;