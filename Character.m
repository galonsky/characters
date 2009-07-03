//
//  Character.m
//  Characters
//
//  Created by Alex Galonsky on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Character.h"


@implementation Character

@synthesize pinyin;
@synthesize characters;

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, %@", pinyin, characters];
}

@end
