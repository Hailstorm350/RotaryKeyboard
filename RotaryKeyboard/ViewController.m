//
//  ViewController.m
//  RotaryKeyboard
//
//  Created by Kenneth Wigginton on 4/22/13.
//  Copyright (c) 2013 Ken Wigginton. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize rotaryPicker, label, wordBuffer;

/* LOGIC */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if(component == 1){
        NSString * sel = [rotaryPicker.charViewArray objectAtIndex:row] ; //TODO use cache of recently typed letters
                                                                        // Before Space
        if([wordBuffer length] <= 0)
            [self.rotaryPicker fetchWords:sel];
        [self.rotaryPicker reloadAllComponents];
    }
}

- (IBAction)segButtonPushed:(id)sender{
    UISegmentedControl *segControl = sender;
    switch (segControl.selectedSegmentIndex){
        case 0: //Caps
            [self.rotaryPicker toggleCaps];
            break;
        case 1: //123
            [self.rotaryPicker toggleSym];
            break;
        case 2: //Space
            [label setText:[NSString stringWithFormat:@"%@%c",label.text, ' ']];
            [wordBuffer setString:@""];
            break;
        case 3: //DEL
            self.wordBuffer = [NSMutableString stringWithString:[self.wordBuffer substringToIndex:wordBuffer.length-2]];
            [label setText: [label.text substringToIndex:label.text.length-2] ];
            //TODO Look backward, load into wordBuffer what exists before encountering space delimiter
            break;
        case 4: //Enter
            [label setText:[NSString stringWithFormat:@"%@%@",label.text, @"\n"]];
            [wordBuffer setString:@""];
            break;
    }
}

- (void) selectChar:(id)sender{
    NSString *temp = [rotaryPicker.charViewArray objectAtIndex:[rotaryPicker selectedRowInComponent:1]];
    
    [label setText:[NSString stringWithFormat:@"%@%@",label.text, temp]];
    [wordBuffer appendString:temp];
    
    if ([wordBuffer length] > 0)
        [self.rotaryPicker fetchWords:wordBuffer];
}

- (void) selectWord:(id)sender{
    if([rotaryPicker.wordViewArray count] > 0 ){
        NSString *temp = [[rotaryPicker.wordViewArray objectAtIndex:[rotaryPicker selectedRowInComponent:0]] text];
        
        NSRange strRange = {[wordBuffer length], [temp length]-[wordBuffer length]};
        strRange = [temp rangeOfComposedCharacterSequencesForRange:strRange];
        temp = [temp substringWithRange:strRange];
        
        [label setText:[NSString stringWithFormat:@"%@%@ ",label.text, temp]];
        
        [self.rotaryPicker selectRow:0 inComponent:0 animated:YES];
    }
}

- (void) tapGestureReceived:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint tapCoord = [gestureRecognizer locationInView:gestureRecognizer.view];
    if(tapCoord.y > 62 && tapCoord.y < 103){ //Specify clicks only valid in blue selector bar
        if(tapCoord.x > 20 && tapCoord.x < 238) //Left section
            [self selectWord:gestureRecognizer.view];
        if(tapCoord.x > 243 && tapCoord.x < 298) //Right section
            [self selectChar:gestureRecognizer.view];
    }
}

/* SETUP */
// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
                                   screenRect.size.height-117,
                                   size.width,
                                   162.0);
	return pickerRect;
}

- (void)createPicker
{
    rotaryPicker = [[RotaryPickerView alloc] initWithFrame:CGRectZero];
	[rotaryPicker fillArray];
	
	rotaryPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	CGSize pickerSize = [rotaryPicker sizeThatFits:CGSizeZero];
	rotaryPicker.frame = [self pickerFrameWithSize:pickerSize];
    
	rotaryPicker.showsSelectionIndicator = YES;	// note this is default to NO
	
	// this view controller is the data source and delegate
	rotaryPicker.delegate = self;
	rotaryPicker.dataSource = self;
	
    // Add gesture recognizer to select row upon tap.
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReceived:)];
    gest.cancelsTouchesInView = NO;
    [rotaryPicker addGestureRecognizer:gest];
    
    // Init the wordBuffer
    wordBuffer = [[NSMutableString alloc] init];
    
	// add this picker to our view controller, initially hidden
	rotaryPicker.hidden = NO;
	[self.view addSubview:rotaryPicker];
    [self.rotaryPicker selectRow:0 inComponent:1 animated:YES];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [rotaryPicker pickerView:pickerView titleForRow:row forComponent:component];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [rotaryPicker pickerView:pickerView numberOfRowsInComponent:component];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return [rotaryPicker numberOfComponentsInPickerView:pickerView];
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return [rotaryPicker pickerView:pickerView widthForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return [rotaryPicker pickerView:pickerView rowHeightForComponent:component];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createPicker];
}


- (void)viewWillAppear:(BOOL)animated
{	
	// for aesthetic reasons (the background is black), make the nav bar black for this particular page
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	// match the status bar with the nav bar
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
