//
//  TFOptionsKit.m
//  TFOptionsKit
//
//  The MIT License (MIT)
//
//  Created by Mikael Grön on 2015-04-08.
//  Copyright (c) 2015 The Farm (http://thefarm.se/). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

#import "TFOptionsKit.h"

#ifndef UIColorFromRGBA
#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbaValue & 0xFF))/255.0]
#endif

@interface TFOptionsKit()

@property (strong, nonatomic) NSDictionary *defaults;
@property (strong, nonatomic) NSDictionary *options;

@end

@implementation TFOptionsKit

+ (instancetype)sharedOptions
{
    static dispatch_once_t once;
    static id sharedOptions;
    dispatch_once(&once, ^{
        sharedOptions = [[self alloc] init];
    });
    return sharedOptions;
}


- (void)clearAllOptions
{
    self.options = [NSDictionary dictionary];
    self.defaults = [NSDictionary dictionary];
}


- (void)setDefaultOptionsPath:(NSString *)defaultPath
{
    self.defaults = [[NSDictionary alloc] initWithContentsOfFile:defaultPath];
}


- (void)loadOptionsOverrideFromPath:(NSString *)overridesPath
{
    NSMutableDictionary *originalOptions = [self.options mutableCopy] ? : [NSMutableDictionary dictionary];
    NSDictionary *options = [[NSDictionary alloc] initWithContentsOfFile:overridesPath];
    
    if (options) {
        [originalOptions addEntriesFromDictionary:options];
        self.options = originalOptions;
    }
}


- (void)loadInfoPlistOverridesFromKey:(NSString *)settingsKey
{
    NSMutableDictionary *originalOptions = [self.options mutableCopy] ? : [NSMutableDictionary dictionary];
    NSDictionary *options = [[NSBundle mainBundle] infoDictionary][settingsKey];
    
    if (options) {
        [originalOptions addEntriesFromDictionary:options];
        self.options = originalOptions;
    }
}


- (NSDictionary *)options:(NSDictionary *)options
            fromNamespace:(NSString *)namespace
{
    NSArray *components = [namespace componentsSeparatedByString:@"/"];
    for (NSString *path in components) {
        options = options[path];
    }
    return options;
}


+ (BOOL)validate:(id)object class:(Class)klass
{
    return object && [object isKindOfClass:klass];
}

#pragma mark - Options

- (id)objectForOption:(NSString *)key
            namespace:(NSString *)namespace
         defaultValue:(id)defaultValue
{
    return [self options:self.options fromNamespace:namespace][key] ? :
             [self options:self.defaults fromNamespace:namespace][key] ? :
               defaultValue;
}


- (NSArray *)arrayForOption:(NSString *)key
                  namespace:(NSString *)namespace
               defaultValue:(NSArray *)defaultValue
{
    id object = [self objectForOption:key namespace:namespace defaultValue:defaultValue];
    if ([TFOptionsKit validate:object class:[NSArray class]]) {
        return object;
    }
    return defaultValue;
}


- (NSDictionary *)dictForOption:(NSString *)key
                      namespace:(NSString *)namespace
                   defaultValue:(NSDictionary *)defaultValue
{
    id object = [self objectForOption:key namespace:namespace defaultValue:defaultValue];
    if ([TFOptionsKit validate:object class:[NSDictionary class]]) {
        return object;
    }
    return defaultValue;
}


- (NSString *)stringForOption:(NSString *)key
                    namespace:(NSString *)namespace
                 defaultValue:(NSString *)defaultValue
{
    id object = [self objectForOption:key namespace:namespace defaultValue:defaultValue];
    if ([TFOptionsKit validate:object class:[NSString class]]) {
        return object;
    }
    return defaultValue;
}


- (NSNumber *)numberForOption:(NSString *)key
                    namespace:(NSString *)namespace
                 defaultValue:(NSNumber *)defaultValue
{
    id object = [self objectForOption:key namespace:namespace defaultValue:defaultValue];
    if ([TFOptionsKit validate:object class:[NSNumber class]]) {
        return object;
    }
    return defaultValue;
}

- (UIColor *)colorForOption:(NSString *)key
                  namespace:(NSString *)namespace
               defaultValue:(UIColor *)defaultValue
{
    NSString *hexColor = [self stringForOption:key namespace:namespace defaultValue:nil];
    
    if (hexColor != nil && ![hexColor isEqualToString:@""]) {
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if ([hexColor length] == 6) {
            hexColor = [hexColor stringByAppendingString:@"FF"];
        }
        
        unsigned int rgbHexValue;
        
        NSScanner *scanner = [NSScanner scannerWithString:hexColor];
        BOOL successful = [scanner scanHexInt:&rgbHexValue];
        
        if (successful) {
            return UIColorFromRGBA(rgbHexValue);
        }
    }
    
    return defaultValue;
}

- (NSDate *)dateForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(NSDate *)defaultValue
{
    id object = [self objectForOption:key namespace:namespace defaultValue:defaultValue];
    if ([TFOptionsKit validate:object class:[NSDate class]]) {
        return object;
    }
    return nil;
}


- (float)floatForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(float)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:@(defaultValue)] floatValue];
}

- (double)doubleForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(double)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:@(defaultValue)] doubleValue];
}


- (NSInteger)intForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(NSInteger)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:@(defaultValue)] integerValue];
}


- (NSUInteger)uintForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(NSUInteger)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:@(defaultValue)] unsignedIntegerValue];
}


- (BOOL)boolForOption:(NSString *)key
            namespace:(NSString *)namespace
         defaultValue:(BOOL)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:@(defaultValue)] boolValue];
}


#pragma mark - DEPRECATED

- (id)objectForOption:(NSString *)optionKey
              default:(id)defaultValue
{
    if ([self.options objectForKey:optionKey] != nil) {
        return [self.options objectForKey:optionKey];
    } else {
        return defaultValue;
    }
}


- (NSArray *)arrayForOption:(NSString *)optionKey
                    default:(NSArray *)defaultValue
{
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSDictionary *)dictForOption:(NSString *)optionKey
                        default:(NSDictionary *)defaultValue
{
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSString *)stringForOption:(NSString *)optionKey
                      default:(NSString *)defaultValue
{
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (NSNumber *)numberForOption:(NSString *)optionKey
                      default:(NSNumber *)defaultValue
{
    id object = [self objectForOption:optionKey default:defaultValue];
    if (object && [object isKindOfClass:[NSNumber class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (UIColor *)colorForOption:(NSString *)optionKey
                    default:(UIColor *)defaultValue
{
    NSString *hexColor = [self stringForOption:optionKey default:nil];

    if (hexColor != nil && ![hexColor isEqualToString:@""]) {
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if ([hexColor length] == 6) {
            hexColor = [hexColor stringByAppendingString:@"FF"];
        }
        
        unsigned int rgbHexValue;
        
        NSScanner *scanner = [NSScanner scannerWithString:hexColor];
        BOOL successful = [scanner scanHexInt:&rgbHexValue];
        
        if (successful) {
            defaultValue = UIColorFromRGBA(rgbHexValue);
        }
    }
    return defaultValue;
}


- (NSDate *)dateForOption:(NSString *)optionKey
                  default:(NSDate *)defaultValue
{
    id object = [self objectForOption:optionKey
                              default:defaultValue];
    if (object && [object isKindOfClass:[NSDate class]]) {
        return object;
    } else {
        return defaultValue;
    }
}


- (CGFloat)floatForOption:(NSString *)optionKey
                  default:(CGFloat)defaultValue
{
    return [[self numberForOption:optionKey
                          default:@(defaultValue)] floatValue];
}


- (NSInteger)intForOption:(NSString *)optionKey
                  default:(NSInteger)defaultValue
{
    return [[self numberForOption:optionKey
                          default:@(defaultValue)] integerValue];
}


- (BOOL)boolForOption:(NSString *)optionKey
              default:(BOOL)defaultValue
{
    return [[self numberForOption:optionKey
                          default:@(defaultValue)] boolValue];
}

@end
