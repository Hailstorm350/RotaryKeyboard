//
//  RotaryPickerView.m
//  RotaryKeyboard
//
//  Created by Kenneth Wigginton on 4/22/13.
//  Copyright (c) 2013 Ken Wigginton. All rights reserved.
//

#import "RotaryPickerView.h"
#import "AppDelegate.h"

@implementation RotaryPickerView

@synthesize charViewArray, wordViewArray, moc;

bool isCaps, isSym;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(self.moc == nil)
            self.moc = [[AppDelegate sharedAppDelegate] managedObjectContext];
    }
    return self;
}

#pragma mark UIPickerView

//Refill the word array based on new selection or prefix parameter, Currently only does beginning letter
- (void) fetchWords:(NSString *) prefix{
//    char selChar = [prefix characterAtIndex:0];

    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    NSEntityDescription *testEntity=[NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.moc];
    [fetch setEntity:testEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"text BEGINSWITH[c] %@", prefix];
    [fetch setPredicate:predicate];
    
    NSError *fetchError=nil;
    self.wordViewArray = [NSMutableArray arrayWithArray:[self.moc executeFetchRequest:fetch error:&fetchError]];
    
    if (fetchError!=nil) {
        NSLog(@" fetchError=%@,details=%@",fetchError,fetchError.userInfo);
    }
    [self reloadAllComponents];
}

- (void)fillArray {
    
    //Fill char array
    NSMutableArray *toFill = [[NSMutableArray alloc] init];
    for(int i = 0; i < 26; i++){
        [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 97]];
    }
    self.charViewArray = toFill;

    [self fetchWords: @"a"];
}

- (void) toggleCaps{
    isCaps = !isCaps;
    
    NSMutableArray *toFill = [[NSMutableArray alloc] init];
    
    if(isCaps){
        //Fill char array
        toFill = [[NSMutableArray alloc] init];
        for(int i = 0; i < 26; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 65]];
        }
    }
    else{
        for(int i = 0; i < 26; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 97]];
        }
    }
    self.charViewArray = toFill;
    
    [self reloadComponent: 1];
}

- (void) toggleSym{
    isSym = !isSym;
    NSMutableArray *toFill = [[NSMutableArray alloc] init];
    if(isSym){
        for(int i = 0; i < 9; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 49]];
        }
        
        [toFill addObject: [NSString stringWithFormat:@"%c", (char)48]];
        
        for(int i = 0; i < 14; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 33]];
        }
        for(int i = 0; i < 7; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 58]];
        }
    }else{
        for(int i = 0; i < 26; i++){
            [toFill addObject: [NSString stringWithFormat:@"%c",(char) i + 97]];
        }
    }
    self.charViewArray = toFill;
    
    [self reloadComponent: 1];
    [self selectRow:0 inComponent:1 animated:YES];
}
#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
    if (component == 1) // Char Wheel
    {
        returnStr = [charViewArray objectAtIndex: row];
    }
    else                // Word Wheel
    {
        returnStr = [wordViewArray count] > 0 ? [[wordViewArray objectAtIndex:row] text] : @"";
    }
	
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth = 0.0; //TODO create conditional for left/right hand
    
	if (component == 1)
		componentWidth = 60.0;	// first column size is small to hold letters
	else
		componentWidth = 220.0;	// second column is wider to show words
    
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 1) //TODO create conditional for left/right hand
        
        return [charViewArray count];
    else{
        if([wordViewArray count] == 0)
            return 1;
        return [wordViewArray count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
//{
//    [self selectRow:row inComponent:component animated:animated];
//}

@end
