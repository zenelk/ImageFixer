//
//  IFMetadataManager.m
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import "IFMetadataManager.h"

@interface IFMetadataManager()

@end

@implementation IFMetadataManager

+ (NSDictionary *)getMetadataForURL:(NSURL *)url {
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    NSDictionary *properties = (__bridge_transfer NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    return properties;
}

+ (void)saveMetadata:(NSDictionary *)metadata forURL:(NSURL *)url {
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    CFStringRef imageSourceType = CGImageSourceGetType(source);
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, imageSourceType, 1, NULL);
    if (!destination) {
        @throw [NSException exceptionWithName:@"DestinationCreationException" reason:@"Could not create image destination" userInfo:nil];
    }
    
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef) metadata);
    
    BOOL success = CGImageDestinationFinalize(destination);
    CFRelease(source);
    CFRelease(destination);
    
    if (!success) {
        @throw [NSException exceptionWithName:@"DestinationFinalizeException" reason:@"Could not finalize the destination" userInfo:nil];
    }
    
    [data writeToFile:[url path] atomically:YES];
}

@end
