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


+ (void)requireThat:(BOOL)condition format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    if (!condition) {
        [NSException raise:@"TFOptionsKit exception" format:format arguments:args];
    }
    va_end(args);
}


- (void)clearAllOptions
{
    self.options = nil;
}


- (NSDictionary *)copyOfCurrentState
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.options];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}


+ (NSDictionary *)mergeDictionary:(NSDictionary *)baseDictionary
                   withDictionary:(NSDictionary *)extensionDictionary
{
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:baseDictionary];
    [extensionDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL isDict = [obj isKindOfClass:[NSDictionary class]];
        BOOL hasValue = resultDictionary[key] != nil;
        id setObj = obj;
        
        if (hasValue && isDict) {
            BOOL hasDict = [baseDictionary[key] isKindOfClass:[NSDictionary class]];
            
            if ( hasDict ) {
                NSDictionary *extendedChildDictionary =
                [self mergeDictionary:baseDictionary[key] withDictionary:obj];
                
                setObj = extendedChildDictionary;
            }
        }
        
        resultDictionary[key] = setObj;
    }];
    
    return resultDictionary;
    
}

- (void)setDefaultOptionsPath:(NSString *)defaultPath
{
    self.options = [[NSDictionary alloc] initWithContentsOfFile:defaultPath];

    [TFOptionsKit requireThat:self.options != nil format:@"Defaults file at `%@` not found.", defaultPath];
}


- (void)loadOptionsOverrideFromPath:(NSString *)overridesPath
{
    NSDictionary *dictToMerge = [[NSDictionary alloc] initWithContentsOfFile:overridesPath];
    
    [TFOptionsKit requireThat:dictToMerge != nil format:@"Override file at `%@` not found.", overridesPath];
    
    self.options = [TFOptionsKit mergeDictionary:self.options withDictionary:dictToMerge];
}


- (void)loadInfoPlistOverridesFromKey:(NSString *)settingsKey
{
    NSDictionary *dictToMerge = [[NSBundle mainBundle] infoDictionary][settingsKey];
    
    [TFOptionsKit requireThat:dictToMerge != nil format:@"Could not find `%@` key in Info.plist", settingsKey];
    
    self.options = [TFOptionsKit mergeDictionary:self.options withDictionary:dictToMerge];
}


- (NSDictionary *)optionsFromNamespace:(NSString *)namespace
{
    NSDictionary *options = self.options;
    
    if (namespace.length) {
        NSArray *components = [namespace componentsSeparatedByString:@"/"];
        for (NSString *path in components) {
            if ([options isKindOfClass:[NSDictionary class]]) {
                options = options[path];
            }
            else {
                options = nil;
                break;
            }
        }
    }
    
    return options;
}


+ (BOOL)validate:(id)object class:(Class)klass
{
    BOOL validated = (object != nil && [object isKindOfClass:klass]);
    
    [TFOptionsKit
     requireThat:(validated || object == nil)
     format:@"Object %@ is not of the expected class", object, NSStringFromClass(klass)];
    
    return validated;
}


#pragma mark - Options

- (id)objectForOption:(NSString *)key
            namespace:(NSString *)namespace
         defaultValue:(id)defaultValue
{
    id object = [self optionsFromNamespace:namespace][key];
    
    [TFOptionsKit
     requireThat:(object != nil || defaultValue != nil)
     format:@"Key `%@%@%@` not found, no default value provided", namespace ? : @"", namespace ? @"/" : @"", key];

    return object ? : defaultValue;
}


- (NSArray *)arrayForOption:(NSString *)key
                  namespace:(NSString *)namespace
               defaultValue:(NSArray *)defaultValue
{
    id object = [self objectForOption:key
                            namespace:namespace
                         defaultValue:defaultValue];
    
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
    NSString *hexColor = [self stringForOption:key namespace:namespace defaultValue:@""];
    
    if (hexColor != nil && ![hexColor isEqualToString:@""]) {
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if ([hexColor length] == 6) {
            hexColor = [hexColor stringByAppendingString:@"FF"];
        }
        
        unsigned int rgbHexValue;
        
        NSScanner *scanner = [NSScanner scannerWithString:hexColor];
        BOOL successful = [scanner scanHexInt:&rgbHexValue];

        [TFOptionsKit
         requireThat:(successful || defaultValue != nil)
         format:@"No valid color found on key path: `%@%@%@` and defaultValue is not set", namespace ? : @"", namespace ? @"/" : @"", key];
        
        return UIColorFromRGBA(rgbHexValue);
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
           defaultValue:(NSNumber *)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:defaultValue] floatValue];
}

- (double)doubleForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(NSNumber *)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:defaultValue] doubleValue];
}


- (NSInteger)intForOption:(NSString *)key
                namespace:(NSString *)namespace
             defaultValue:(NSNumber *)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:defaultValue] integerValue];
}


- (NSUInteger)uintForOption:(NSString *)key
                  namespace:(NSString *)namespace
               defaultValue:(NSNumber *)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:defaultValue] unsignedIntegerValue];
}


- (BOOL)boolForOption:(NSString *)key
            namespace:(NSString *)namespace
         defaultValue:(NSNumber *)defaultValue
{
    return [[self numberForOption:key namespace:namespace defaultValue:defaultValue] boolValue];
}


- (BOOL)optionExists:(NSString *)key
           namespace:(NSString *)ns
{
    NSDictionary *options = [self optionsFromNamespace:ns];
    return options[key] ? YES : NO;
}

@end
