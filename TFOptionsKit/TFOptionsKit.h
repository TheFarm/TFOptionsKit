//
//  TFOptionsKit.h
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for TFOptionsKit.
FOUNDATION_EXPORT double TFOptionsKitVersionNumber;

//! Project version string for TFOptionsKit.
FOUNDATION_EXPORT const unsigned char TFOptionsKitVersionString[];


@interface TFOptionsKit : NSObject

/** The shared options instance */
+ (nullable instancetype)sharedOptions;

/** Set a default options .plist file to load values from.
 
 All values stored in the .plist will be loaded at call time, if the file exists.
 
 Usage:
 NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"plist"];
 [[TFOptionsKit sharedOptions] setDefaultOptionsPath:pathToFile];
 
 @param defaultPath Path of the .plist file
 */
- (void)setDefaultOptionsPath:(nonnull NSString *)defaultPath;

/** Loads and merges existing values into the overrides dictionary.
 
 All values stored in the .plist will be loaded at call time, if the file exists.
 These values overrides values with the same keys from the default .plist
 file loaded in - setDefaultOptionsPath:
 
 This method can be called multiple times and the resulting override dictionary is all
 unique keys from all .plist files loaded.
 
 Usage:
 NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"Overrides" ofType:@"plist"];
 [[TFOptionsKit sharedOptions] loadOptionsOverrideFromPath:pathToOverrides];
 
 @param overridesPath Path of the .plist file
 */
- (void)loadOptionsOverrideFromPath:(nonnull NSString *)overridesPath;

/** Loads and merges existing values from the project Info.plist file into the overrides dictionary.
 
 These values overrides values with the same keys from the default .plist
 file loaded in - setDefaultOptionsPath:
 
 This method can be called multiple times and the resulting override dictionary is all
 unique keys from all loaded keys from the project Info.plist file.
 
 Usage:
 [[TFOptionsKit sharedOptions] loadInfoPlistOverridesFromKey:@"Some Key in the Info.plist"];
 
 Important:
 The key must lead to a dictionary.
 
 @param settingsKey Key to the dictionary in the Info.plist file.
 */
- (void)loadInfoPlistOverridesFromKey:(nonnull NSString *)settingsKey;

/* Resets both default and overrides to empty keys and values. */
- (void)clearAllOptions;

/** Gets an object from the specified key and optional namespace
 
 The key represents a key in the dictionary containing all options.
 The namespace represents a path to sub dictionaries delimited by a slash.
 
 For example, given the following dictionary structure:
 @{
    @"Root": @{
        @"Sub": @{
            @"Key": @"Value"
        }
    }
 }
 
 To getting easier access to the @"Key" value, you use the following call:
    [[TFOptionsKit sharedOptions]
     objectForOption:@"Value"
     namespace:@"Root/Sub"
     defaultValue:nil];
 
 Or the macro:
    TF_option(@"Root/Sub", @"Key", nil);
 
 It's recommended to use constants defining the namespace, like this:
    static NSString *const kYourNamespace = @"Root/Sub";
    TF_option(kYourNamespace, @"Key", nil);
 
 Namespaces are of course optional.
 
 @param key the key in the dictionary containing the object
 @param namespace a slash delimited namespace sub path to the key.
 @param defaultValue the value to return if all else fails
 */
- (nullable id)objectForOption:(nonnull NSString *)key
                     namespace:(nullable NSString *)ns
                  defaultValue:(nullable id)defaultValue;

/** Gets an array from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable NSArray *)arrayForOption:(nonnull NSString *)key
                           namespace:(nullable NSString *)ns
                        defaultValue:(nullable NSArray *)defaultValue;

/** Gets an array from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable NSDictionary *)dictForOption:(nonnull NSString *)key
                               namespace:(nullable NSString *)ns
                            defaultValue:(nullable NSDictionary *)defaultValue;

/** Gets a dictionary from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable NSString *)stringForOption:(nonnull NSString *)key
                             namespace:(nullable NSString *)ns
                          defaultValue:(nullable NSString *)defaultValue;

/** Gets a number from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable NSNumber *)numberForOption:(nonnull NSString *)key
                             namespace:(nullable NSString *)ns
                          defaultValue:(nullable NSNumber *)defaultValue;

/** Gets an UIColor object from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable UIColor *)colorForOption:(nonnull NSString *)key
                           namespace:(nullable NSString *)ns
                        defaultValue:(nullable UIColor *)defaultValue;

/** Gets a NSDate object from the specified key
 
 Read the objectForOption documentation for more info
 */
- (nullable NSDate *)dateForOption:(nonnull NSString *)key
                         namespace:(nullable NSString *)ns
                      defaultValue:(nullable NSDate *)defaultValue;

/** Gets a float from the specified key
 
 Read the objectForOption documentation for more info
 */
- (float)floatForOption:(nonnull NSString *)key
              namespace:(nullable NSString *)ns
           defaultValue:(float)defaultValue;

/** Gets a double from the specified key
 
 Read the objectForOption documentation for more info
 */
- (double)doubleForOption:(nonnull NSString *)key
                namespace:(nullable NSString *)ns
             defaultValue:(double)defaultValue;

/** Gets a signed integer from the specified key
 
 Read the objectForOption documentation for more info
 */
- (NSInteger)intForOption:(nonnull NSString *)key
                namespace:(nullable NSString *)ns
             defaultValue:(NSInteger)defaultValue;

/** Gets a unsigned integer from the specified key
 
 Read the objectForOption documentation for more info
 */
- (NSUInteger)uintForOption:(nonnull NSString *)key
                  namespace:(nullable NSString *)ns
               defaultValue:(NSUInteger)defaultValue;

/** Gets a bool from the specified key
 
 Read the objectForOption documentation for more info
 */
- (BOOL)boolForOption:(nonnull NSString *)key
            namespace:(nullable NSString *)ns
         defaultValue:(BOOL)defaultValue;

#pragma mark - Deprecated methods

- (nullable id)objectForOption:(nonnull NSString *)optionKey
                       default:(nullable id)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable NSArray *)arrayForOption:(nonnull NSString *)optionKey
                             default:(nullable NSArray *)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable NSDictionary *)dictForOption:(nonnull NSString *)optionKey
                                 default:(nullable NSDictionary *)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable NSString *)stringForOption:(nonnull NSString *)optionKey
                               default:(nullable NSString *)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable NSNumber *)numberForOption:(nonnull NSString *)optionKey
                               default:(nullable NSNumber *)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable NSDate *)dateForOption:(nonnull NSString *)optionKey
                           default:(nullable NSDate *)defaultValue DEPRECATED_ATTRIBUTE;

- (nullable UIColor *)colorForOption:(nonnull NSString *)optionKey
                             default:(nullable UIColor*)defaultValue DEPRECATED_ATTRIBUTE;

- (CGFloat)floatForOption:(nonnull NSString *)optionKey
                  default:(CGFloat)defaultValue DEPRECATED_ATTRIBUTE;

- (NSInteger)intForOption:(nonnull NSString *)optionKey
                  default:(NSInteger)defaultValue DEPRECATED_ATTRIBUTE;

- (BOOL)boolForOption:(nonnull NSString *)optionKey
              default:(BOOL)defaultValue DEPRECATED_ATTRIBUTE;

@end

#ifndef TF_option
#define TF_option(_namespace, _key, _default) [[TFOptionsKit sharedOptions] objectForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_arrayOption
#define TF_arrayOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] arrayForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_dictOption
#define TF_dictOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] dictForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_stringOption
#define TF_stringOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] stringForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_numberOption
#define TF_numberOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] numberForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_dateOption
#define TF_dateOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] dateForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_colorOption
#define TF_colorOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] colorForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_floatOption
#define TF_floatOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] floatForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_intOption
#define TF_intOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] intForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_uintOption
#define TF_uintOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] uintForOption:_key namespace:_namespace defaultValue:_default]
#endif


#ifndef TF_boolOption
#define TF_boolOption(_namespace, _key, _default) [[TFOptionsKit sharedOptions] boolForOption:_key namespace:_namespace defaultValue:_default]
#endif


#pragma mark - DEPRECATED

#ifndef option
#define option(_key, _default) [[TFOptionsKit sharedOptions] objectForOption:_key default:_default]
#endif

#ifndef arrayOption
#define arrayOption(_key, _default) [[TFOptionsKit sharedOptions] arrayForOption:_key default:_default]
#endif

#ifndef dictOption
#define dictOption(_key, _default) [[TFOptionsKit sharedOptions] dictForOption:_key default:_default]
#endif

#ifndef stringOption
#define stringOption(_key, _default) [[TFOptionsKit sharedOptions] stringForOption:_key default:_default]
#endif

#ifndef numberOption
#define numberOption(_key, _default) [[TFOptionsKit sharedOptions] numberForOption:_key default:_default]
#endif

#ifndef dateOption
#define dateOption(_key, _default) [[TFOptionsKit sharedOptions] dateForOption:_key default:_default]
#endif

#ifndef colorOption
#define colorOption(_key, _default) [[TFOptionsKit sharedOptions] colorForOption:_key default:_default]
#endif

#ifndef floatOption
#define floatOption(_key, _default) [[TFOptionsKit sharedOptions] floatForOption:_key default:_default]
#endif

#ifndef intOption
#define intOption(_key, _default) [[TFOptionsKit sharedOptions] intForOption:_key default:_default]
#endif

#ifndef boolOption
#define boolOption(_key, _default) [[TFOptionsKit sharedOptions] boolForOption:_key default:_default]
#endif