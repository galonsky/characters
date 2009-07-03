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
	
	for(Character *thisObj in array)
	{
		NSLog(@"%@", thisObj);
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
	[charField setStringValue:[[array objectAtIndex:index] valueForKey:@"characters"]];
}

- (IBAction)incorrect:(id)sender
{
	[charField setStringValue:@""];
	[self next];
}
- (IBAction)correct:(id)sender
{
	[charField setStringValue:@""];
	[array removeObjectAtIndex:index];
	if([array count] == 0)
	{
		[pinyinField setStringValue:@"Complete"];
	}
	else [self next];
}

@end
