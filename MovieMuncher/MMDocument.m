//
//  MMDocument.m
//  MovieMuncher
//
//  Created by Rocco Bowling on 8/20/14.
//  Copyright (c) 2014 Rocco Bowling. All rights reserved.
//

#import "MMDocument.h"
#import "SPMuncher.h"

@implementation MMDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSError * error;
    QTMovie * inputMovie = [[QTMovie alloc] initWithData:data error:&error];
    QTMovie * outputMovie = [[QTMovie alloc] initToWritableFile:@"/tmp/Combined.mov" error:NULL];
    
    if(error != NULL){
        NSLog(@"error loading .mov: %@", [error localizedDescription]);
        return NO;
    }
    
    [SPMuncher convertMovie:inputMovie toMovie:outputMovie];
    
    NSString * fileName = [[[self fileName] lastPathComponent] stringByDeletingPathExtension];
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    long returnCode = [savePanel runModalForDirectory:NSHomeDirectory() file:[NSString stringWithFormat:@"%@.alpha.mov", fileName]];
    NSString * path = [savePanel filename];
    
    if (returnCode == NSOKButton)
    {
        [outputMovie writeToFile:path
                     withAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], QTMovieFlatten, NULL]];
    }
        
    return NO;
}

@end
