//
//  AppController.m
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "Character.h"
#import "NSMutableArray_Shuffling.h"
static NSMutableDictionary *charPin;

@implementation AppController
- (id)init
{
	[super init];
	array = [[NSMutableArray alloc] init];
	[self setTheTable];
	return self;
}
- (IBAction)addCharacter:(id)sender
{
	[self translate];
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
	if([[charController arrangedObjects] count] != 0)
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
			[newChar release];
		}
		srandom(time(NULL));
		[array shuffle];
		index = 0;
		[start setTitle:@"Restart"];
		[reveal setEnabled:YES];
		[correct setEnabled:YES];
		[incorrect setEnabled:YES];
		[success setHidden:YES];
		[self display];
	}
	else
	{
		[pinyinField setStringValue:@"No data"];
		[reveal setEnabled:NO];
		[correct setEnabled:NO];
		[incorrect setEnabled:NO];
	}

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
		[correct setEnabled:NO];
		[incorrect setEnabled:NO];
		[start setTitle:@"Start"];
		[pinyinField setStringValue:@""];
		[success setHidden:NO];
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
	NSString *string = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL];
	NSArray *lines = [string componentsSeparatedByString:@"\n"];
	for(int i = 0; i < [lines count] - 1; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		NSArray *parts = [line componentsSeparatedByString:@";"];
		
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
	[open beginForDirectory:@"/Users/Alex/Desktop/csv/" file:nil types:nil modelessDelegate:self didEndSelector:@selector(filePanelDidEnd:returnCode:contextInfo:) contextInfo:NULL];	
}

- (void)filePanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	NSArray *files = [sheet filenames];
	[self processCSV:[files objectAtIndex:0]];
}

- (void)setTheTable
{
	if(charPin == NULL)
	{
		
		charPin = [[NSMutableDictionary alloc] init];
		NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Resources/new.u8"];
		
		NSData *data = [NSData dataWithContentsOfFile:path];
		NSString *file = [NSString stringWithUTF8String:[data bytes]];
		
		NSArray *lines = [file componentsSeparatedByString:@"\n"];
		
		for(NSString *line in lines)
		{
			//NSLog(@"%@", line);
			NSArray *parts = [line componentsSeparatedByString:@"["];
			NSString *chars = [[parts objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *pinyin = [[[parts objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
			[charPin setObject:pinyin forKey:chars];
		}
	}
}
- (void)translate
{
	
	for(NSManagedObject *obj in [charController arrangedObjects])
	{
		if([[obj valueForKey:@"pinyin"] isEqualTo:@""] || [obj valueForKey:@"pinyin"] == NULL)
		{
			[obj setValue:[charPin objectForKey:[obj valueForKey:@"characters"]] forKey:@"pinyin"];
		}
	}
}
@end
