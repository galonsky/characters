//
//  Character.h
//  Characters
//
//  Created by Alex Galonsky on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Character : NSObject {
	NSString *pinyin;
	NSString *characters;
}
@property(readwrite, assign) NSString *pinyin;
@property(readwrite, assign) NSString *characters;
- (NSString *)description;

@end
