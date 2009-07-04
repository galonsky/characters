//
//  AppController.m
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "Character.h"

@implementation AppController
- (id)init
{
	[super init];
	array = [[NSMutableArray alloc] init];
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

- (IBAction)start:(id)sender
{
	[array removeAllObjects];
	[progress setIntValue:0];
	NSArray *constantArray;
	constantArray = [charController arrangedObjects];
	for(NSManagedObject *obj in constantArray)
	{
		NSString *pinyin = [obj valueForKey:@"pinyin"];
		NSString *characters = [obj valueForKey:@"characters"];
		Character *newChar = [[Character alloc] init];
		[newChar setValue:pinyin forKey:@"pinyin"];
		[newChar setValue:characters forKey:@"characters"];
		
		[array addObject:newChar];
	}
	
	index = 0;
	[self display];

}
- (void)next
{
	index++;
	if(index >= [array count]) index = 0;
	[self display];
}

- (void)display
{
	[pinyinField setStringValue:[[array objectAtIndex:index] valueForKey:@"pinyin"]];
}

- (IBAction)reveal:(id)sender
{
	[reveal setEnabled:NO];
	[charField setStringValue:[[array objectAtIndex:index] valueForKey:@"characters"]];
}

- (IBAction)incorrect:(id)sender
{
	[reveal setEnabled:YES];
	[self updateProgress];
	[charField setStringValue:@""];
	[self next];
}
- (IBAction)correct:(id)sender
{
	[charField setStringValue:@""];
	[array removeObjectAtIndex:index];
	[self updateProgress];
	if([array count] == 0)
	{
		[reveal setEnabled:NO];
		[pinyinField setStringValue:@"Complete"];
	}
	else 
	{
		[reveal setEnabled:YES];
		[self next];
	}
	
}
- (void)updateProgress
{
	NSNumber *total = [NSNumber numberWithUnsignedInt:[[charController arrangedObjects] count]];
	NSNumber *left = [NSNumber numberWithUnsignedInt:[array count]];
	float percentage = (1 - [left floatValue] / [total floatValue]) * 100;
	[progress setFloatValue:percentage];
	NSLog(@"%f", percentage);
}
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}
- (void)processCSV:(NSString *)file
{
	NSData *data = [NSData dataWithContentsOfFile:file];
	NSString *string = [NSString stringWithUTF8String:[data bytes]];
	NSArray *lines = [string componentsSeparatedByString:@"\n"];
	for(int i = 0; i < [lines count] - 1; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		//NSLog(@"%@", line);
		NSArray *parts = [line componentsSeparatedByString:@";"];
		NSLog(@"%@, %@", [parts objectAtIndex:1], [parts objectAtIndex:2]);
		
		NSManagedObjectContext *context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
		NSManagedObject *newChar = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
		[newChar setValue:[parts objectAtIndex:1] forKey:@"pinyin"];
		[newChar setValue:[parts objectAtIndex:2] forKey:@"characters"];
		[charController addObject:newChar];
	}
}

- (IBAction)showPanel:(id)sender
{
	NSOpenPanel *open = [NSOpenPanel openPanel];
	[open beginForDirectory:nil file:nil types:nil modelessDelegate:self didEndSelector:@selector(filePanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];	
}

- (void)filePanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	NSArray *files = [sheet filenames];
	[self processCSV:[files objectAtIndex:0]];
}

@end
