//
//  ISTAppDelegate.m
//  ImageSharingTest
//
//  Created by Gleb on 26/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import "ISTAppDelegate.h"

@implementation ISTAppDelegate

- (IBAction)chooseImage:(id)sender {
	NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanCreateDirectories:NO];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setAllowedFileTypes:@[@"jpg", @"jpeg", @"gif", @"png", @"tiff", @"tif"]];
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result == NSOKButton) {
			NSURL *url = [openPanel URLs][0];
			self.imagePath = [url path];
		}
	}];
}

#pragma mark - Actions

// shares NSImage from the image view => GIF animation is lost
- (IBAction)shareImage:(id)sender {
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[self.imageView.image]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

// copies image raw data determining image type from file extension => GIF animation is lost
- (IBAction)copyImage:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	NSData *imageData = [self getImageData];
	NSString *ext = [self.imagePath pathExtension];
	NSString *uti = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)ext, NULL);
	[pasteboard declareTypes:@[uti] owner:nil];
	[pasteboard setData:imageData forType:uti];
}

// shares using file URL => GIF animation is preserved, but a file is necessary
- (IBAction)shareUsingFileURL:(id)sender {
	NSURL *fileURL = [NSURL fileURLWithPath:self.imagePath];
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[fileURL]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

// shares using attachment to an attributed string => GIF animation is lost
- (IBAction)shareUsingAttachment:(id)sender {
	NSAttributedString *attributedString = [self getImageAsAttachment];
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[attributedString]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

#pragma mark - Implementation

- (NSData *)getImageData {
	return [NSData dataWithContentsOfFile:self.imagePath];
}

- (NSAttributedString *)getImageAsAttachment {
	NSData *imageData = [self getImageData];
	NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:imageData];
	[fileWrapper setPreferredFilename:[self.imagePath lastPathComponent]];
	NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
	NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
	return str;
}

@end
