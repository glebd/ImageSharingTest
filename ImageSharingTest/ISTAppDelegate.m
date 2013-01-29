//
//  ISTAppDelegate.m
//  ImageSharingTest
//
//  Created by Gleb on 26/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import "ISTAppDelegate.h"
#import "ISTImage.h"

@implementation ISTAppDelegate

#pragma mark - Lifecycle

- (void)awakeFromNib {
	[self.shareImageButton sendActionOn:NSLeftMouseDownMask];
	[self.shareFileURLButton sendActionOn:NSLeftMouseDownMask];
	[self.shareNSAttributedStringButton sendActionOn:NSLeftMouseDownMask];
	[self.shareISTImageButton sendActionOn:NSLeftMouseDownMask];
	[self.sharePasteboardItemButton sendActionOn:NSLeftMouseDownMask];
}

#pragma mark - Actions

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

// shares NSImage from the image view => GIF animation is lost
- (IBAction)shareImage:(id)sender {
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[self.imageView.image]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

// copies image raw data to pasteboard, determining image type from file extension => GIF animation is lost
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

// copies file URL to pasteboard => GIF animation is preserved
- (IBAction)copyUsingFileURL:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	NSURL *fileURL = [NSURL fileURLWithPath:self.imagePath];
	[pasteboard declareTypes:@[NSFilenamesPboardType] owner:nil];
	[pasteboard writeObjects:@[fileURL]];
}

// shares using attachment to an attributed string => GIF animation is lost
- (IBAction)shareUsingAttributedString:(id)sender {
	NSAttributedString *attributedString = [self getImageAsAttachment];
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[attributedString]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

- (IBAction)shareUsingISTImage:(id)sender {
	ISTImage *image = [[ISTImage alloc] initWithFilePath:self.imagePath];
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[image]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

// copy custom class image data as RFTD => animation is preserved
- (IBAction)copyUsingISTImage:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	ISTImage *image = [[ISTImage alloc] initWithFilePath:self.imagePath];
	// Declare custom pasteboard data type that we own
	[pasteboard declareTypes:@[kISTImagePasteboardType] owner:nil];
	// use ISTImage's support for <NSPasteboardWriting> protocol
	if (![pasteboard writeObjects:@[image]]) {
		NSBeep();
		NSLog(@"Unable to write %@ to pasteboard", image);
	}
}

- (IBAction)shareUsingNSPasteboardItem:(id)sender {
}

- (IBAction)copyUsingNSPasteboardItem:(id)sender {
}

// copies data using attributed string with image attachment as RTFD => animation is preserved
- (IBAction)copyUsingRTFD:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	NSAttributedString *attributedString = [self getImageAsAttachment];
	NSData *data = [attributedString RTFDFromRange:NSMakeRange(0, [attributedString length]) documentAttributes:nil];
	[pasteboard declareTypes:@[NSRTFDPboardType] owner:nil];
	[pasteboard setData:data forType:NSRTFDPboardType];
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
