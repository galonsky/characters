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
}
- (IBAction)addCharacter:(id)sender;

@end
