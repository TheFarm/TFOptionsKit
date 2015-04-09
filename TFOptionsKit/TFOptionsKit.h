//
//  TFOptionsKit.h
//  TFOptionsKit
//
//  Created by Mikael Grön on 2015-04-08.
//  Copyright (c) 2015 The Farm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for TFOptionsKit.
FOUNDATION_EXPORT double TFOptionsKitVersionNumber;

//! Project version string for TFOptionsKit.
FOUNDATION_EXPORT const unsigned char TFOptionsKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TFOptionsKit/PublicHeader.h>

@interface TFOptionsKit : NSObject

+ (instancetype)sharedOptions;

- (void)useFileWithPath:(NSString*)optionsPath;
- (id)objectForOption:(NSString *)optionKey default:(id)defaultValue;
- (NSArray *)arrayForOption:(NSString *)optionKey default:(NSArray *)defaultValue;
- (NSDictionary *)dictForOption:(NSString *)optionKey default:(NSDictionary *)defaultValue;
- (NSString *)stringForOption:(NSString *)optionKey default:(NSString *)defaultValue;
- (NSNumber *)numberForOption:(NSString *)optionKey default:(NSNumber *)defaultValue;
- (NSDate *)dateForOption:(NSString *)optionKey default:(NSDate *)defaultValue;
- (UIColor *)colorForOption:(NSString *)optionKey default:(UIColor*)defaultValue;
- (CGFloat)floatForOption:(NSString *)optionKey default:(CGFloat)defaultValue;
- (NSInteger)intForOption:(NSString *)optionKey default:(NSInteger)defaultValue;
- (BOOL)boolForOption:(NSString *)optionKey default:(BOOL)defaultValue;

@end

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