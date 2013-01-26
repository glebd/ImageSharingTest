//
//  ISTAppDelegate.m
//  ImageSharingTest
//
//  Created by Gleb on 26/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import "ISTAppDelegate.h"

@implementation ISTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

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

- (IBAction)shareUsingTempFile:(id)sender {

}

@end
