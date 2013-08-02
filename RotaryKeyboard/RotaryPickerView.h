//
//  RotaryPickerView.h
//  RotaryKeyboard
//
//  Created by Kenneth Wigginton on 4/22/13.
//  Copyright (c) 2013 Ken Wigginton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RotaryPickerView : UIPickerView

@property (nonatomic, retain) NSMutableArray *charViewArray;
@property (nonatomic, retain) NSMutableArray *wordViewArray;
@property (nonatomic, retain) NSManagedObjectContext* moc;

- (void) fillArray;
- (void) toggleCaps;
- (void) toggleSym;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (NSString *) pickerView: (UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void) fetchWords:(NSString *) prefix;
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end

