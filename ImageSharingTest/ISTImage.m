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
	NSString *typeIdentifier = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassNSPboardType, (__bridge CFStringRef)NSRTFDPboardType, NULL);
	NSArray *types = @[typeIdentifier];
	NSLog(@"Called %s, returning types: %@", __PRETTY_FUNCTION__, types);
	return types;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
	NSLog(@"Called %s", __PRETTY_FUNCTION__);
	return [self getDataAsRTFD];
}

#pragma mark - <NSPasteboardReading>

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
	NSString *typeIdentifier = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassNSPboardType, (__bridge CFStringRef)NSRTFDPboardType, NULL);
	NSArray *types = @[typeIdentifier];
	NSLog(@"Called %s, returning types: %@", __PRETTY_FUNCTION__, types);
	return types;
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

- (NSPasteboardItem *)pasteboardItem {
	NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
	[item setData:[self getDataAsRTFD] forType:(NSString *)kUTTypeFlatRTFD];
	return item;
}

@end
