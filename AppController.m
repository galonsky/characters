//
//  AppController.m
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (id)init
{
	[super init];
	//NSNotificationCenter *nc;
//	nc = [NSNotificationCenter defaultCenter];
//	[nc addObserver:self
//		   selector:@selector(handleContentChange:)
//			   name:NSManagedObjectContextObjectsDidChangeNotification
//			 object:nil];
	return self;
}
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

- (void)handleContentChange:(NSNotification *)notification
{
	array = [charController arrangedObjects];
	NSLog(@"handle method called");
}
- (IBAction)start:(id)sender
{
	array = [charController arrangedObjects];
	for(NSManagedObject *obj in array)
	{
		[obj setValue:[NSNumber numberWithBool:NO] forKey:@"correct"];
	}
	NSLog(@"start method called");
	index = 0;
	[self display];
}
- (void)next
{
	index++;
	if(index >= [array count]) index = 0;
	NSManagedObject *thisObj = [array objectAtIndex:index];
	if([[thisObj valueForKey:@"correct"] isEqual:[NSNumber numberWithBool:YES]])
	{
		[self next];
		return;
	}
	[self display];
}

- (void)display
{
	NSLog(@"display method called");
	//NSLog(@"%@", [[array objectAtIndex:index] valueForKey:@"pinyin"]);
	[pinyinField setStringValue:[[array objectAtIndex:index] valueForKey:@"pinyin"]];
}

- (IBAction)reveal:(id)sender
{
	[charField setStringValue:[[array objectAtIndex:index] valueForKey:@"characters"]];
}

- (IBAction)incorrect:(id)sender
{
	[charField setStringValue:@""];
	[self next];
}
- (IBAction)correct:(id)sender
{
	NSManagedObject *thisObj = [array objectAtIndex:index];
	[thisObj setValue:[NSNumber numberWithBool:YES] forKey:@"correct"];
	[charField setStringValue:@""];
	[self next];
}

@end
