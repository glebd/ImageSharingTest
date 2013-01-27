//
//  ISTImage.m
//  ImageSharingTest
//
//  Created by Gleb on 27/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import "ISTImage.h"

@implementation ISTImage

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
	return nil;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
	return nil;
}

@end
