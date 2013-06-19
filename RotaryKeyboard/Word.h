//
//  Word.h
//  RotaryKeyboard
//
//  Created by Kenneth Wigginton on 5/6/13.
//  Copyright (c) 2013 Ken Wigginton. All rights reserved.
//


#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSNumber *rank;

@end
