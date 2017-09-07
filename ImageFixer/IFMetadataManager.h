//
//  IFMetadataManager.h
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFMetadataManager : NSObject

+ (NSDictionary *)getMetadataForURL:(NSURL *)url;
+ (void)saveMetadata:(NSDictionary *)metadata forURL:(NSURL *)url;

@end
