//
//  ISTImage.h
//  ImageSharingTest
//
//  Created by Gleb on 27/01/2013.
//  Copyright (c) 2013 PixelEspresso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISTImage : NSObject <NSPasteboardWriting>

@property (strong) NSString *filePath;
@property (strong) NSData *imageData;

- (instancetype)initWithFilePath:(NSString *)filePath;
- (void)copyToPasteboard:(NSPasteboard *)pasteboard;
- (NSData *)getDataAsRTFD;

@end

extern NSString *kISTImagePasteboardType;
