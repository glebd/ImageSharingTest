# ImageSharingTest

## What is it?

ImageSharingTest is a testbed app to try out different methods of sharing a GIF image using Mountain Lion's built-in sharing service picker with the goal of preserving the animation.

While developing my new app I discovered that sharing of an `NSImage` containing an animated GIF removes animation. It appeared that preserving animation is not a trivial task and doesn't happen automatically.

## Invoking the picker

The code is quite simple, really:

	- (IBAction)shareImage:(id)sender {
		NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[self.imageView.image]];
		picker.delegate = self;
		[picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
	}

The system displays a popup menu populated with available sharing services (Twitter, Messages, Facebook, and the like). When you choose a service, the system displays a UI to create a new post or message and attaches whatever you are sharing to it.

The objects being shared must adopt `NSPasteboardWriting` protocol.

## Sharing different objects

### NSImage

The obvious choice for sharing an image (that is possibly already displayed in an `NSImageView`) is to use an `NSImage`. But I found out that if you share an animated GIF image that way, the animation is lost.

For copying an image to pasteboard, you can read its contents, determine UTI from file extension, and put the data for that UTI on the pasteboard. This, too, will lose the animation.

### File URL

You can share a file URL and the system will share the file contents instead. This will preserve the animation but is not always convenient, as in the case of my app the image data is stored using Core Data, and I'd have to write a temporary file just to have it shared, which is silly.

Copying file URL to pasteboard as `NSFilenamesPboardType` also preserves animation.

### RTFD

I found a [snippet of code](https://github.com/BigZaphod/Chameleon/blob/master/UIKit/Classes/UIPasteboard.m) in [Chameleon](http://chameleonproject.org) that described how to use RTFD format to put a GIF image on the pasteboard.

However, when I add an `NSAttributedString` with a GIF attachment to `NSSharingServicePicker`, the shared image is not animated. I can't add the wrapper RTFD data to the picker, as it can only share objects that support `NSPasteboardWriting` protocol, and the RTFD is returned as `NSData`.

Copying RTFD data to pasteboard as `NSRTFDPboardType` works and preserves animation.

### Custom object

TODO

# About

## The app

The app targets Mac OS X Mountain Lion 10.8 and uses ARC.

## Me

I'm Gleb Dolgich, @glebd on Twitter and ADN. I program for Mac OS X and iOS in my spare time. My website is [PixelEspressoApps](http://pixelespressoapps.com).

# Licence

This code is public domain.