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
* **option** for any kind of object
* **arrayOption** for arrays
* **dictOption** for dictionaries
* **stringOption** for strings
* **numberOption** for number objects
* **floatOption** for floats
* **intOption** for integers
* **boolOption** for booleans

They all take two parameters: key and default.
```
NSString* loadedValue = stringOption(@"The key for my data", @"No, default loaded");
NSLog(@"Did the option load correctly? %@", loadedValue);
```

## Licence

**TFOptionsKit** is licensed under the terms of the MIT License. Please see the LICENSE file for full details.
