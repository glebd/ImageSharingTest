//
//  ISTAppDelegate.h
//  ImageSharingTest
//
//  Created by Gleb on 26/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISTAppDelegate : NSObject <NSApplicationDelegate, NSSharingServicePickerDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;

@property (strong) NSString *imagePath;

- (IBAction)chooseImage:(id)sender;

- (IBAction)shareImage:(id)sender;
- (IBAction)copyImage:(id)sender;
- (IBAction)shareUsingFileURL:(id)sender;
- (IBAction)copyUsingFileURL:(id)sender;
- (IBAction)shareUsingAttributedString:(id)sender;
- (IBAction)copyUsingRTFD:(id)sender;

@end
