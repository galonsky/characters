//
//  AppController.m
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (IBAction)addCharacter:(id)sender
{
	NSManagedObjectContext *context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	NSManagedObject *newChar = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
	[charController addObject:newChar];
	[charController rearrangeObjects];
	NSArray *a = [charController arrangedObjects];
	int row = [a indexOfObjectIdenticalTo:newChar];
	[tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (IBAction)reveal:(id)sender
{
	
}

@end
