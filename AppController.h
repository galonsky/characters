//
//  AppController.h
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  Hello World

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSTableView *tableView;
	IBOutlet NSArrayController *charController;
	IBOutlet NSTextField *pinyinField;
	IBOutlet NSTextField *charField;
	NSMutableArray *array;
	int index;
}
- (IBAction)addCharacter:(id)sender;
- (IBAction)reveal:(id)sender;
- (IBAction)correct:(id)sender;
- (IBAction)incorrect:(id)sender;
- (IBAction)start:(id)sender;
- (void)next;
- (void)display;
@end
