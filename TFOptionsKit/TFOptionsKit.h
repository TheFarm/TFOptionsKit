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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

/* Returns a deep copy version of the entire current state.
   
   Use for debugging purposes only. */
- (nullable NSDictionary *)copyOfCurrentState;

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
    TF_option(@"Root/Sub", @"Key");
 
 It's recommended to use constants defining the namespace, like this:
    static NSString *const kYourNamespace = @"Root/Sub";
    TF_option(kYourNamespace, @"Key");
 
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
           defaultValue:(nullable NSNumber *)defaultValue;

/** Gets a double from the specified key
 
 Read the objectForOption documentation for more info
 */
- (double)doubleForOption:(nonnull NSString *)key
                namespace:(nullable NSString *)ns
             defaultValue:(nullable NSNumber *)defaultValue;

/** Gets a signed integer from the specified key
 
 Read the objectForOption documentation for more info
 */
- (NSInteger)intForOption:(nonnull NSString *)key
                namespace:(nullable NSString *)ns
             defaultValue:(nullable NSNumber *)defaultValue;

/** Gets a unsigned integer from the specified key
 
 Read the objectForOption documentation for more info
 */
- (NSUInteger)uintForOption:(nonnull NSString *)key
                  namespace:(nullable NSString *)ns
               defaultValue:(nullable NSNumber *)defaultValue;

/** Gets a bool from the specified key
 
 Read the objectForOption documentation for more info
 */
- (BOOL)boolForOption:(nonnull NSString *)key
            namespace:(nullable NSString *)ns
         defaultValue:(nullable NSNumber *)defaultValue;

/** Checks the existance of a specific namespace and key **/
- (BOOL)optionExists:(nonnull NSString *)key
           namespace:(nullable NSString *)ns;

@end

#ifndef TF_optionExists
#define TF_optionExists(_namespace, _key) [[TFOptionsKit sharedOptions] optionExists:_key namespace:_namespace]
#endif

#ifndef TF_option
#define TF_option(_namespace, _key) [[TFOptionsKit sharedOptions] objectForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_arrayOption
#define TF_arrayOption(_namespace, _key) [[TFOptionsKit sharedOptions] arrayForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_dictOption
#define TF_dictOption(_namespace, _key) [[TFOptionsKit sharedOptions] dictForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_stringOption
#define TF_stringOption(_namespace, _key) [[TFOptionsKit sharedOptions] stringForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_numberOption
#define TF_numberOption(_namespace, _key) [[TFOptionsKit sharedOptions] numberForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_dateOption
#define TF_dateOption(_namespace, _key) [[TFOptionsKit sharedOptions] dateForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_colorOption
#define TF_colorOption(_namespace, _key) [[TFOptionsKit sharedOptions] colorForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_floatOption
#define TF_floatOption(_namespace, _key) [[TFOptionsKit sharedOptions] floatForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_intOption
#define TF_intOption(_namespace, _key) [[TFOptionsKit sharedOptions] intForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_uintOption
#define TF_uintOption(_namespace, _key) [[TFOptionsKit sharedOptions] uintForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_boolOption
#define TF_boolOption(_namespace, _key) [[TFOptionsKit sharedOptions] boolForOption:_key namespace:_namespace defaultValue:nil]
#endif

#ifndef TF_optionValue
#define TF_optionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] objectForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_arrayOptionValue
#define TF_arrayOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] arrayForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_dictOptionValue
#define TF_dictOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] dictForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_stringOptionValue
#define TF_stringOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] stringForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_numberOptionValue
#define TF_numberOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] numberForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_dateOptionValue
#define TF_dateOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] dateForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_colorOptionValue
#define TF_colorOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] colorForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_floatOptionValue
#define TF_floatOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] floatForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_intOptionValue
#define TF_intOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] intForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_uintOptionValue
#define TF_uintOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] uintForOption:_key namespace:_namespace defaultValue:_default]
#endif

#ifndef TF_boolOptionValue
#define TF_boolOptionValue(_namespace, _key, _default) [[TFOptionsKit sharedOptions] boolForOption:_key namespace:_namespace defaultValue:_default]
#endif