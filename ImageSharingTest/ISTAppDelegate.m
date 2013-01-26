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

// share NSImage from the image view
- (IBAction)shareImage:(id)sender {
	NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[self.imageView.image]];
	picker.delegate = self;
	[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

- (IBAction)shareUsingTempFile:(id)sender {

}

@end
