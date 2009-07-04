//
//  MyDocument.m
//  Characters
//
//  Created by Alex Galonsky on 7/2/09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        // initialization code
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
}

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
	[savePanel setCanSelectHiddenExtension:NO];
	return YES;
}

@end
