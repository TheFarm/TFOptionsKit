//
//  TFOptionsKit.m
//  TFOptionsKit
//
//  Created by Mikael Grön on 2015-04-08.
//  Copyright (c) 2015 The Farm. All rights reserved.
//

#import "TFOptionsKit.h"

@interface TFOptionsKit()
@property (strong, nonatomic) NSDictionary *options;
@end

@implementation TFOptionsKit

+ (instancetype)sharedOptions {
    static dispatch_once_t once;
    static id sharedOptions;
    dispatch_once(&once, ^{
        sharedOptions = [[self alloc] init];
    });
    return sharedOptions;
}


- (instancetype)init {
    if (self = [super init]) {
        self.options = @{};
    }
    return self;
}


- (void)useFileWithPath:(NSString*)optionsPath {
    self.options = [[NSDictionary alloc] initWithContentsOfFile:optionsPath];
}


- (id)objectForOption:(NSString *)optionKey default:(id)defaultValue {
    if ([self.options objectForKey:optionKey] != nil) {
        return [self.options objectForKey:optionKey];
    } else {
        return defaultValue;
    }
}

- (NSArray *)arrayForOption:(NSString *)optionKey default:(NSArray *)defaultValue {
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSDictionary *)dictForOption:(NSString *)optionKey default:(NSDictionary *)defaultValue {
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return defaultValue;
    }
}



- (NSString *)stringForOption:(NSString *)optionKey default:(NSString *)defaultValue {
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSNumber *)numberForOption:(NSString *)optionKey default:(NSNumber *)defaultValue {
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSNumber class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSDate *)dateForOption:(NSString *)optionKey default:(NSDate *)defaultValue {
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSDate class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (CGFloat)floatForOption:(NSString *)optionKey default:(CGFloat)defaultValue {
    return [[self numberForOption:optionKey default:@(defaultValue)] floatValue];
}


- (NSInteger)intForOption:(NSString *)optionKey default:(NSInteger)defaultValue {
    return [[self numberForOption:optionKey default:@(defaultValue)] integerValue];
}


- (BOOL)boolForOption:(NSString *)optionKey default:(BOOL)defaultValue {
    return [[self numberForOption:optionKey default:@(defaultValue)] boolValue];
}


@end
