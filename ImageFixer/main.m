//
//  main.m
//  ImageFixerCL
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IFMain.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"No folder path provided!");
            return 1;
        }
        const char *folderPathC = argv[1];
        NSString *folderPath = [NSString stringWithUTF8String:folderPathC];
        NSLog(@"ImageFixer starting with path: %@", folderPath);
        [IFMain fixMetadataForFolderPath:folderPath];
    }
    return 0;
}
