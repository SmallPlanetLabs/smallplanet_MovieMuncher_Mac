//
//  SPMuncher.h
//  MovieMuncher
//

#import <Foundation/Foundation.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@interface SPMuncher : NSObject

+ (NSImage *) getAlphaMaskFromImage:(NSImage *)img;
+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie;
+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose;
+ (void) convertMovie:(QTMovie *)inputMovie toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose displayName:(NSString*)display;
+ (void) convertImages:(NSArray *)inputFilenames toMovie:(QTMovie*)outputMovie verbose:(BOOL)verbose displayName:(NSString*)display;

@end
