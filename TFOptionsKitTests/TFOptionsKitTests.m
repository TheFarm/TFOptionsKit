//
//  TFOptionsKitTests.m
//  TFOptionsKitTests
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
#import <XCTest/XCTest.h>
#import "TFOptionsKit.h"

@interface TFOptionsKitTests : XCTestCase

@end

@implementation TFOptionsKitTests

- (void)setUp
{
    [super setUp];
    NSString *pathToTestData = [[NSBundle bundleForClass:[self class] ] pathForResource:@"TestValues" ofType:@"plist"];
    NSString *pathToTestOverrides = [[NSBundle bundleForClass:[self class] ] pathForResource:@"Overrides" ofType:@"plist"];
    [[TFOptionsKit sharedOptions] setDefaultOptionsPath:pathToTestData];
    [[TFOptionsKit sharedOptions] loadOptionsOverrideFromPath:pathToTestOverrides];
}

- (void)tearDown
{
    [[TFOptionsKit sharedOptions] clearAllOptions];
    [super tearDown];
}

- (void)testArray
{
    NSArray *array = TF_arrayOption(nil, @"Array test", @[]);
    XCTAssert(array && [array isKindOfClass:[NSArray class]]);
    XCTAssert([array count] > 1);
    XCTAssert([array[0] isEqualToString:@"Value 1"]);
    XCTAssert([array[1] isEqualToString:@"Value 2"]);
}


- (void)testDictionary
{
    NSDictionary *dict = TF_dictOption(nil, @"Dictionary test", @{});
    XCTAssert(dict && [dict isKindOfClass:[NSDictionary class]]);
    XCTAssert([[dict objectForKey:@"first"] isEqualToString:@"Value 1"]);
    XCTAssert([[dict objectForKey:@"second"] isEqualToString:@"Value 2"]);
}


- (void)testString
{
    NSString *string = TF_stringOption(nil, @"String test", @"");
    XCTAssert(string && [string isEqualToString:@"The string"]);
}


- (void)testNumber
{
    NSNumber *number = TF_numberOption(nil, @"Number test 1", @0);
    XCTAssert(number && [number isEqualToNumber:@31337]);
}


- (void)testDate2
{
    NSDate *date = TF_dateOption(nil, @"Date test", [NSDate date]);
    XCTAssert(date && [date timeIntervalSince1970] == 1428480000);
}


- (void)testInteger
{
    
    NSInteger integerValue = TF_intOption(nil, @"Number test 1", 0);
    XCTAssert(integerValue == 31337);
    
    NSInteger otherIntegerValue = TF_intOption(nil, @"No integer here", 10);
    XCTAssert(otherIntegerValue == 10);
    
}


- (void)testFloat
{
    
    CGFloat floatValue = TF_floatOption(nil, @"Number test 2", 0.f);
    NSLog(@"Float value: %f", floatValue);
    XCTAssert(floatValue == 31.337f);
    
    CGFloat otherFloatValue = TF_floatOption(nil, @"Nonexistant float", 10.f);
    XCTAssert(otherFloatValue == 10.f);
    
}


- (void)testBool
{
    
    BOOL loadedValue = TF_boolOption(nil, @"Boolean test 1", NO);
    XCTAssert(loadedValue == YES);
    
    loadedValue = TF_boolOption(nil, @"Boolean test 2", YES);
    XCTAssert(loadedValue == NO);
    
    BOOL defaultValue = TF_boolOption(nil, @"No bool here!", YES);
    XCTAssert(defaultValue == YES);
}


- (void)testColor
{
    
    UIColor *loadedColor = TF_colorOption(nil, @"Color test", [UIColor blackColor]);
    NSLog(@"Color: %@", loadedColor);

    XCTAssert([loadedColor isEqual:[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1]]);
    
    UIColor *defaultColor = TF_colorOption(nil, @"This color doesn't exist", nil);
    XCTAssertNil(defaultColor);
}


- (void)testNamespace
{
    NSString *test = TF_stringOption(@"Namespace/Nested/Deep", @"Key test", @"Default");
    XCTAssertNotNil(test);
    XCTAssertEqual([test isEqualToString:@"Test"], YES);
}


- (void)testOverride
{
    BOOL test = TF_boolOption(nil, @"Value to override", NO);
    XCTAssertEqual(test, YES);
}

@end
