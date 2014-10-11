//
//  main.m
//  munch
//
//  Created by Quinn McHenry on 8/23/14.
//  Copyright (c) 2014 Rocco Bowling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMuncher.h"
#include "unistd.h"

#define OUTFILE(infile) [[[infile lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"_alpha.mov"]

static BOOL verbose = false;

void process(NSString *infile, NSString *outfile) {
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:infile];
    QTMovie *inputMovie = [[QTMovie alloc] initWithData:data error:&error];
    QTMovie *outputMovie = [[QTMovie alloc] initToWritableFile:@"/tmp/Combined.mov" error:NULL];
    
    if(error != NULL) {
        NSLog(@"error loading .mov: %@", [error localizedDescription]);
        return;
    }
    
    NSString *display = [infile lastPathComponent];
    [SPMuncher convertMovie:inputMovie toMovie:outputMovie verbose:verbose displayName:display];
    
    [outputMovie writeToFile:outfile
              withAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], QTMovieFlatten, NULL]];
}

void processPNGs(NSArray *infiles, NSString *outfile) {
    QTMovie *outputMovie = [[QTMovie alloc] initToWritableFile:@"/tmp/Combined.mov" error:NULL];
    
    NSString *display = [[infiles firstObject] lastPathComponent];
    [SPMuncher convertImages:infiles toMovie:outputMovie verbose:verbose displayName:display];
    
    [outputMovie writeToFile:outfile
              withAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], QTMovieFlatten, NULL]];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *infile, *outfile;

        NSMutableArray *args = [[[NSProcessInfo processInfo] arguments] mutableCopy];
        [args removeObjectAtIndex:0]; // lose the executable and path
        if ([args containsObject:@"-v"]) {
            verbose = true;
            [args removeObject:@"-v"];
        }
        if ([args containsObject:@"-o"]) {
            NSInteger index = [args indexOfObject:@"-o"];
            if ([args count] > index+1) {
                outfile = [args objectAtIndex:index+1];
                [args removeObjectAtIndex:index+1];
            }
            [args removeObjectAtIndex:index];
        }
        if ([args count] == 0 || [args containsObject:@"-h"]) {
            printf("Usage: munch [-v] [-o outfile] infile ...\n");
            printf("  -h\t\tthis helpful stuff\n");
//            printf("  -v\t\t\tverbose\n");
            printf("  -o outfile\t\tprocess single infile\n");
            printf("  infile1 infile2...\tprocess multiple files, outfile = infile_alpha.ext\n");
            printf("    if infiles are .mov, each will be processed\n");
            printf("    if infiles are .png, all will be processed into one .mov\n");
            return NO;
        }
        if ([args count] == 1) {
            infile = args[0];
            if (!outfile) {
                outfile = OUTFILE(infile);
            }
            process(infile, outfile);
        } else {
            NSString *first = [args firstObject];
            if ([[first lowercaseString] hasSuffix:@"png"]) {
                processPNGs(args, (outfile ?: OUTFILE(first)));
            } else {
                for (int i=0; i<[args count]; i++) {
                    process(args[i], OUTFILE(args[i]));
                }
            }
        }
        
    }
    return 0;
}
