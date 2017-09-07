//
//  IFDateCreatedFixer.m
//  ImageFixer
//
//  Created by Hunter Lang on 6/12/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import "IFDateCreatedFixer.h"
#import "IFImageDescriptor.h"

static NSString *KEY_EXIF = @"{Exif}";
static NSString *KEY_EXIF_DATE_TIME_DIGITIZED = @"DateTimeDigitized";
static NSString *KEY_EXIF_DATE_TIME_ORIGINAL = @"DateTimeOriginal";
static NSString *DATE_TIME_FORMAT_EXIF = @"yyyy:MM:dd HH:mm:ss";

static NSString *KEY_IPTC = @"{IPTC}";
static NSString *KEY_IPTC_DATE_CREATED = @"DateCreated";
static NSString *KEY_IPTC_DIGITAL_CREATION_TIME = @"DigitalCreationTime";
static NSString *KEY_IPTC_DIGITAL_CREATION_DATE = @"DigitalCreationDate";
static NSString *KEY_IPTC_TIME_CREATED = @"TimeCreated";
static NSString *DATE_FORMAT_IPTC = @"YYYYMMdd";
static NSString *TIME_FORMAT_IPTC = @"HHmmss";

static NSString *KEY_TIFF = @"{TIFF}";
static NSString *KEY_DATE_TIME_TIFF = @"DateTime";

@implementation IFDateCreatedFixer

+ (NSArray *)fixDateCreatedOnMetadatas:(NSArray *)metadatas {
    
    NSMutableArray *completedMetadatas = [NSMutableArray array];
    int offset = 0;
    NSDate *currentTime = [NSDate date];
    for (IFImageDescriptor *descriptor in metadatas) {
        NSString *path = [descriptor path];
        NSDictionary *metadata = [descriptor metadata];
        metadata = [self updateMetadata:metadata withDate:[currentTime dateByAddingTimeInterval:offset]];
        [completedMetadatas addObject:[IFImageDescriptor imageDescriptorWithPath:path andMetadata:metadata]];
        ++offset;
    }
    
    return completedMetadatas;
}

+ (NSDictionary *)updateMetadata:(NSDictionary *)metadata withDate:(NSDate *)date {
    NSMutableDictionary *mutableMetadata = [metadata mutableCopy];
    
    [self updateExifMetadata:mutableMetadata withDate:date];
    [self updateIPTCMetadata:mutableMetadata withDate:date];
    [self updateTIFFMetadata:mutableMetadata withDate:date];
    
    return mutableMetadata;
}

+ (void)updateExifMetadata:(NSMutableDictionary *)metadata withDate:(NSDate *)date {
    NSString *dateString = [self formatDate:date usingFormat:DATE_TIME_FORMAT_EXIF];
    NSMutableDictionary *exif = [[metadata objectForKey:KEY_EXIF] mutableCopy];
    if (!exif) {
        exif = [NSMutableDictionary dictionary];
    }
    
    [exif setValue:dateString forKey:KEY_EXIF_DATE_TIME_DIGITIZED];
    [exif setValue:dateString forKey:KEY_EXIF_DATE_TIME_ORIGINAL];
    
    [metadata setObject:exif forKey:KEY_EXIF];
}

+ (void)updateIPTCMetadata:(NSMutableDictionary *)metadata withDate:(NSDate *)date {
    NSString *dateString = [self formatDate:date usingFormat:DATE_FORMAT_IPTC];
    NSString *timeString = [self formatDate:date usingFormat:TIME_FORMAT_IPTC];
    NSMutableDictionary *IPTC = [[metadata objectForKey:KEY_IPTC] mutableCopy];
    if (!IPTC) {
        IPTC = [NSMutableDictionary dictionary];
    }
    
    [IPTC setValue:dateString forKey:KEY_IPTC_DATE_CREATED];
    [IPTC setValue:dateString forKey:KEY_IPTC_DIGITAL_CREATION_DATE];
    [IPTC setValue:timeString forKey:KEY_IPTC_DIGITAL_CREATION_TIME];
    [IPTC setValue:timeString forKey:KEY_IPTC_TIME_CREATED];
    
    [metadata setValue:IPTC forKey:KEY_IPTC];
}

+ (void)updateTIFFMetadata:(NSMutableDictionary *)metadata withDate:(NSDate *)date {
    NSString *dateTimeString = [self formatDate:date usingFormat:DATE_TIME_FORMAT_EXIF]; // Yes I know this is Exif, TIFF is the same format
    NSMutableDictionary *tiff = [[metadata objectForKey:KEY_TIFF] mutableCopy];
    if (!tiff) {
        tiff = [NSMutableDictionary dictionary];
    }
    
    [tiff setValue:dateTimeString forKey:KEY_DATE_TIME_TIFF];
    
    [metadata setValue:tiff forKey:KEY_TIFF];
}

+ (NSString *)formatDate:(NSDate *)date usingFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

@end
