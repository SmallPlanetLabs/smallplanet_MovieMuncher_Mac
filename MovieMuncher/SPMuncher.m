//
//  SPMuncher.m
//  MovieMuncher
//
//  Created by JQ McHenry on 8/23/14.
//  Copyright (c) 2014 Rocco Bowling. All rights reserved.
//

#import "SPMuncher.h"
//#import "progressbar.h"

@implementation SPMuncher

+ (NSImage *) getAlphaMaskFromImage:(NSImage *)img {
    NSBitmapImageRep * bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                        pixelsWide:img.size.width
                                                                        pixelsHigh:img.size.height
                                                                     bitsPerSample:8
                                                                   samplesPerPixel:4
                                                                          hasAlpha:YES
                                                                          isPlanar:NO
                                                                    colorSpaceName:NSDeviceRGBColorSpace
                                                                      bitmapFormat:NSAlphaFirstBitmapFormat
                                                                       bytesPerRow:img.size.width * 4
                                                                      bitsPerPixel:32];
    
    
    NSGraphicsContext * context = [NSGraphicsContext graphicsContextWithBitmapImageRep: bitmap];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: context];
    [img drawInRect:NSMakeRect(0, 0, img.size.width, img.size.height)
           fromRect:NSMakeRect(0, 0, img.size.width, img.size.height)
          operation:NSCompositeCopy
           fraction:1.0f];
    [NSGraphicsContext restoreGraphicsState];
    
    // Now we manually walk the bits, copy the alpha to the r,b,g values
    unsigned char * bytePtr = [bitmap bitmapData];
    
    for(int x = 0; x < img.size.width; x++) {
        for(int y = 0; y < img.size.height; y++) {
            bytePtr[1] = bytePtr[0];
            bytePtr[2] = bytePtr[0];
            bytePtr[3] = bytePtr[0];
            bytePtr[0] = 255;
            bytePtr += 4;
        }
    }
    
    NSImage *maskImage = [[NSImage alloc] init];
    [maskImage addRepresentation:bitmap];
    return maskImage;
}

+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie {
    [self convertMovie:inputMovie toMovie:outputMovie verbose:NO];
}

+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose {
    [self convertMovie:inputMovie toMovie:outputMovie verbose:verbose displayName:@"Munch"];
}

+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose displayName:(NSString*)display {
    [outputMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
    
    // Run through this movie's images
    QTTime timeNow = [inputMovie currentTime];
    QTTime timeTotal = [inputMovie duration];
    int i = 0;
    long long max = timeTotal.timeValue;
//    progressbar *progress = NULL;
//    if (verbose) {
//        progress = progressbar_new((char *)[display cStringUsingEncoding:NSASCIIStringEncoding], (unsigned int)max);
//    }
    
    while (QTTimeCompare(timeNow, timeTotal) != NSOrderedSame) {
        i++;
        
        NSImage * frameImage = [inputMovie currentFrameImage];
        
        NSImage* combinedImage = [[NSImage alloc] initWithSize:NSMakeSize(frameImage.size.width*2,frameImage.size.height)];
        [combinedImage lockFocus];
        
        [frameImage drawInRect:NSMakeRect(0, 0, frameImage.size.width, frameImage.size.height)
                      fromRect:NSMakeRect(0, 0, frameImage.size.width, frameImage.size.height)
                     operation:NSCompositeCopy fraction:1.0f];
        
        NSImage * alphaImage = [self getAlphaMaskFromImage:frameImage];
        [alphaImage drawInRect:NSMakeRect(frameImage.size.width, 0, frameImage.size.width, frameImage.size.height)
                      fromRect:NSMakeRect(0, 0, frameImage.size.width, frameImage.size.height)
                     operation:NSCompositeCopy fraction:1.0f];
        
        [combinedImage unlockFocus];
        
        [outputMovie addImage:combinedImage
                  forDuration:QTMakeTime(600.0f/(12), 600.0f)
               withAttributes:@{QTAddImageCodecType: @"mp4v", QTAddImageCodecQuality: @(codecLosslessQuality)}];
        
        [inputMovie stepForward];
        timeNow = [inputMovie currentTime];
//        if (verbose) {
//            progressbar_update(progress, (unsigned int)timeNow.timeValue);
//        }
    }
//    if (verbose) {
//        progressbar_finish(progress);
//    }
}

+ (void) convertImages:(NSArray *)inputFilenames toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose displayName:(NSString*)display {
    [outputMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
    long long frameRate = 12;
    QTTime timeNow = QTMakeTime(0, frameRate);
    QTTime timeTotal = QTMakeTime(inputFilenames.count, frameRate);
    long long max = timeTotal.timeValue;
//    progressbar *progress = NULL;
//    if (verbose) {
//        progress = progressbar_new((char *)[display cStringUsingEncoding:NSASCIIStringEncoding], (unsigned int)max);
//    }

    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:inputFilenames.firstObject];
    NSInteger width = 0;
    NSInteger height = 0;
    for (NSImageRep * imageRep in imageReps) {
        if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    }
    NSSize size = NSMakeSize((CGFloat)width, (CGFloat)height);
    
    for (NSString *filename in inputFilenames) {
        
        NSImage* combinedImage = [[NSImage alloc] initWithSize:NSMakeSize(size.width*2,size.height)];
        [combinedImage lockFocus];
        
        NSImage * frameImage = [[NSImage alloc] initWithContentsOfFile:filename];
        frameImage.size = size;
        [frameImage drawInRect:NSMakeRect(0, 0, size.width, size.height)
                      fromRect:NSMakeRect(0, 0, size.width, size.height)
                     operation:NSCompositeCopy fraction:1.0f];
        
        NSImage * alphaImage = [self getAlphaMaskFromImage:frameImage];
        [alphaImage drawInRect:NSMakeRect(size.width, 0, size.width, size.height)
                      fromRect:NSMakeRect(0, 0, size.width, size.height)
                     operation:NSCompositeCopy fraction:1.0f];
        
        [combinedImage unlockFocus];
        
        [outputMovie addImage:combinedImage
                  forDuration:QTMakeTime(600.0f/frameRate, 600.0f)
               withAttributes:@{QTAddImageCodecType: @"mp4v", QTAddImageCodecQuality: @(codecLosslessQuality)}];
        
        timeNow.timeValue++;
//        if (verbose) {
//            progressbar_update(progress, (unsigned int)timeNow.timeValue);
//        }
    }
//    if (verbose) {
//        progressbar_finish(progress);
//    }
}



@end
