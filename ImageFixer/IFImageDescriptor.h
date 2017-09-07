//
//  IFImageDescriptor.h
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFImageDescriptor : NSObject

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSDictionary *metadata;

+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)imageDescriptorWithPath:(NSString *)path andMetadata:(NSDictionary *)metadata;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPath:(NSString *)path andMetadata:(NSDictionary *)metadata;

@end
