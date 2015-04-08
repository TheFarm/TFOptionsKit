//
//  TFOptionsKitTests.m
//  TFOptionsKitTests
//
//  Created by Mikael Grön on 2015-04-08.
//  Copyright (c) 2015 The Farm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TFOptionsKit.h"

@interface TFOptionsKitTests : XCTestCase

@end

@implementation TFOptionsKitTests

- (void)setUp {
    [super setUp];
    NSString *pathToTestData = [[NSBundle bundleForClass:[self class] ] pathForResource:@"testValues" ofType:@"plist"];
    [[TFOptionsKit sharedOptions] useFileWithPath:pathToTestData];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testArray {
    NSArray *array = arrayOption(@"Array test", @[@"Wrong"]);
    XCTAssert(array && [array isKindOfClass:[NSArray class]]);
    XCTAssert([array count] > 1);
    XCTAssert([array[0] isEqualToString:@"Value 1"]);
    XCTAssert([array[1] isEqualToString:@"Value 2"]);
    
    NSArray *defaultArray = arrayOption(@"Array that doesn't exist", @[@"Correct"]);
    XCTAssert(defaultArray && [defaultArray isKindOfClass:[NSArray class]]);
    XCTAssert([defaultArray[0] isEqualToString:@"Correct"]);
}


- (void)testDictionary {
    NSDictionary *dict = dictOption(@"Dictionary test", @{@"Wrong": @"Value"});
    XCTAssert(dict && [dict isKindOfClass:[NSDictionary class]]);
    XCTAssert([[dict objectForKey:@"first"] isEqualToString:@"Value 1"]);
    XCTAssert([[dict objectForKey:@"second"] isEqualToString:@"Value 2"]);
    
    NSDictionary *defaultDict = dictOption(@"Dict that doesn't exist", @{@"Value": @"is correct"});
    XCTAssert(defaultDict && [defaultDict isKindOfClass:[NSDictionary class]]);
    XCTAssert([[defaultDict objectForKey:@"Value"] isEqualToString:@"is correct"]);
}


- (void)testString {
    NSString *string = stringOption(@"String test", @"Wrong");
    XCTAssert(string && [string isEqualToString:@"The string"]);
}


- (void)testNumber {
    NSNumber *number = numberOption(@"Number test 1", @42);
    XCTAssert(number && [number isEqualToNumber:@31337]);
}


- (void)testDate2 {
    NSDate *date = dateOption(@"Date test", [NSDate date]);
    XCTAssert(date && [date timeIntervalSince1970] == 1428480000);
}


- (void)testInteger {
    
    NSInteger integerValue = intOption(@"Number test 1", 42);
    XCTAssert(integerValue == 31337);
    
    NSInteger otherIntegerValue = intOption(@"No integer here", 42);
    XCTAssert(otherIntegerValue == 42);
    
}


- (void)testFloat {
    
    CGFloat floatValue = floatOption(@"Number test 2", 3.5);
    NSLog(@"Float value: %f", floatValue);
    XCTAssert(floatValue == 31.337f);
    
    CGFloat otherFloatValue = floatOption(@"Nonexistant float", 42.42);
    XCTAssert(otherFloatValue == 42.42f);
    
}


- (void)testBool {
    
    BOOL loadedValue = boolOption(@"Boolean test 1", NO);
    XCTAssert(loadedValue == YES);
    
    loadedValue = boolOption(@"Boolean test 2", YES);
    XCTAssert(loadedValue == NO);
    
    BOOL defaultValue = boolOption(@"No bool here!", NO);
    XCTAssert(defaultValue == NO);
    
    defaultValue = boolOption(@"No bool here either!", YES);
    XCTAssert(defaultValue == YES);
    
}

@end
