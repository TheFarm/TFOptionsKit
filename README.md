# TFOptionsKit
A pod that enables you to define target specific options in your project

## Installation
Using cocoapods, put this line in your Podfile and run pod install:
```
pod 'TFOptionsKit', :git => 'https://github.com/TheFarm/TFOptionsKit.git'
```


## Getting started
1. Create a dictionary plist file with some data in it.
2. ```#import "TFOptionsKit.h"``` in your .m file.
3. Use the appropriate macro to load your data
```
if (boolOption(@"My boolean", NO)) {
  NSLog(@"Yes, it's true! %@", stringOption(@"Text for true", @"There's no text stored"));
}
```
## Macros
They all take two parameters: key and default.
```
NSString* loadedValue = stringOption(@”The key for my data”, @”No, default loaded”);
NSLog(@”Did the option load correctly? %@”, loadedValue);
```

Available macros in short:
* **option**
* **arrayOption**
* **dictOption**
* **stringOption**
* **numberOption**
* **colorOption**
* **floatOption**
* **intOption**
* **boolOption**

### option
Any kind of object

### arrayOption
Returns an NSArray of any data stored in an array in the plist.

### dictOption
Returns an NSDictionary with all things in a dictionary from the plist.

### stringOption
A string. NSString to be exact.

### numberOption
NSNumber object.

### colorOption
This type of option wants a string value consisting of a hexadecimal color code.
Returns an UIColor object

### floatOption
Requires an NSNumber compatible plist field. The data is converted to CGFloat using ```[number floatValue]```

### intOption
Takes an NSNumber and returns ```[number floatValue]```

### boolValue
Returns ```[number boolValue]``` on a number field from the plist.

## Licence

**TFOptionsKit** is licensed under the terms of the MIT License. Please see the LICENSE file for full details.
