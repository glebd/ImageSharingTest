//
//  ISTAppDelegate.h
//  ImageSharingTest
//
//  Created by Gleb on 26/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *shareUsingTempFileButton;

@property (strong) NSString *imagePath;

- (IBAction)chooseImage:(id)sender;

- (IBAction)shareUsingTempFile:(id)sender;

@end
