//
//  IFMain.m
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import "IFMain.h"
#import "IFMetadataManager.h"
#import "IFDateCreatedFixer.h"
#import "IFImageDescriptor.h"

@implementation NSFileManager (DirectoryExtension)

- (BOOL)fileIsDirectoryAtPath:(NSString *)path {
    BOOL outBool;
    [self fileExistsAtPath:path isDirectory:&outBool];
    return outBool;
}

@end

@implementation IFMain

+ (void)fixMetadataForFolderPath:(NSString *)folderPath {
    NSArray *files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *path1 = obj1;
        NSString *path2 = obj2;
        
        return [path1 compare:path2];
    }];
    
    NSMutableArray *metadatas = [NSMutableArray array];
    
    for (NSString *filename in files) {
        if ([[self excludeNames] containsObject:filename]) {
            NSLog(@"Skipping %@ as it is in the exclude list", filename);
            continue;
        }
        NSString *path = [folderPath stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileIsDirectoryAtPath:path]) {
            NSLog(@"Skipping folder %@", filename);
            continue;
        }
        NSDictionary *metadata = [IFMetadataManager getMetadataForURL:[NSURL fileURLWithPath:path]];
        [metadatas addObject:[IFImageDescriptor imageDescriptorWithPath:path andMetadata:metadata]];
        NSLog(@"Got metadata for path: %@", path);
    }
    
    NSArray *fixedMetadatas = [IFDateCreatedFixer fixDateCreatedOnMetadatas:metadatas];
    
    for (IFImageDescriptor *descriptor in fixedMetadatas) {
        NSString *path = [descriptor path];
        NSDictionary *metadata = [descriptor metadata];
        [IFMetadataManager saveMetadata:metadata forURL:[NSURL fileURLWithPath:path]];
        NSLog(@"Saved metdata for path: %@", path);
        NSLog(@"Remaining: %d", (int)([fixedMetadatas count] - [fixedMetadatas indexOfObject:descriptor] - 1));
    }
    
    for (IFImageDescriptor *descriptor in metadatas) {
        NSString *path = [descriptor path];
        NSDictionary *metadata = [IFMetadataManager getMetadataForURL:[NSURL fileURLWithPath:path]];
        if ([metadata isEqual:[descriptor metadata]]) {
            NSLog(@"No change for path %@", path);
        }
    }
    
}

+ (NSArray *)excludeNames {
    return @[ @".DS_Store" ];
}

@end

