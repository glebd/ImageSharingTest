//
//  ISTImage.m
//  ImageSharingTest
//
//  Created by Gleb on 27/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import "ISTImage.h"

NSString *kISTImagePasteboardType = @"com.pixelespresso.ISTImage";

@implementation ISTImage

#pragma mark - Lifecycle

- (instancetype)initWithFilePath:(NSString *)filePath {
	self = [super init];
	if (!self) return nil;
	_filePath = filePath;
	_imageData = [NSData dataWithContentsOfFile:filePath];
	return self;
}

#pragma mark - <NSPasteboardWriting>

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
	return nil;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
	return nil;
}

#pragma mark - API

- (void)copyToPasteboard:(NSPasteboard *)pasteboard {
	[pasteboard declareTypes:@[(NSString *)kUTTypeFlatRTFD] owner:nil];
	[pasteboard setData:[self getDataAsRTFD] forType:(NSString *)kUTTypeFlatRTFD];
}

- (NSData *)getDataAsRTFD {
	NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:self.imageData];
	[fileWrapper setPreferredFilename:[self.filePath lastPathComponent]];
	NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
	NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
	NSData *data = [str RTFDFromRange:NSMakeRange(0, [str length]) documentAttributes:nil];
	return data;
}

@end
