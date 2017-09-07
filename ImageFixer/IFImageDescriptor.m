//
//  IFImageDescriptor.m
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import "IFImageDescriptor.h"

@implementation IFImageDescriptor

+ (instancetype)imageDescriptorWithPath:(NSString *)path andMetadata:(NSDictionary *)metadata {
    return [[IFImageDescriptor alloc] initWithPath:path andMetadata:metadata];
}

- (instancetype)initWithPath:(NSString *)path andMetadata:(NSDictionary *)metadata {
    if (self = [super init]) {
        _path = path;
        _metadata = metadata;
    }
    return self;
}

@end
