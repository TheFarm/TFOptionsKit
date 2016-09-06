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
3. Create a .plist (Root key must be a dictionary) representing your options.
4. Register the .plist with TFOptionsKit ```NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"NameOfYourPlist" ofType:@"plist"]; 
[[TFOptionsKit sharedOptions] setDefaultOptionsPath:pathToFile];```
5. Use the appropriate macro to load your data
```
if (TF_boolOption(nil, @"My boolean", NO)) {
  NSLog(@"Yes, it's true! %@", TF_stringOption(nil, @"Text for true", @"There's no text stored"));
}
```
## Macros
They all take three parameters: namespace, key and default.
```
NSString* loadedValue = TF_stringOption(nil, @”The key for my data”, @”No, default loaded”);
NSLog(@”Did the option load correctly? %@”, loadedValue);
```

## Namespaces
You might want to organize your data with nested dictionaries but still have easy access to it,
here's where namespaces comes in. 

For example, given the following dictionary structure:
```
@{
  @"Root": @{
    @"Sub": @{
      @"Key": @"Value",
      @"Another key": @"Another value",
    }
  }
}
```
To reach the ```@"Key"``` part without resorting to something like: ```TF_dictOption(nil, @"Root", nil)[@"Sub"][@"Key"];``` and thus losing the **defaultValue** feature you can access the ```@"Key"``` part this way ```TF_stringOption(@"Root/Sub", @"Key", @"A default string if all else fails");```. All sub dictionaries are delimited by ```/```. This makes organizing your option .plist files easier.

Making namespace constants is recommended if you have multiple nested values, for example:
```
static NSString *const kYourNamespace = @"Root/Sub";

NSString *loadedValue = TF_stringOption(kYourNamespace, @"Key", nil);

...
elsewhere in your code
...

NSString *anotherString = TF_stringOption(kYourNamespace, @"Another key", nil);
```

Available macros in short:
* **TF_option**
* **TF_arrayOption**
* **TF_dictOption**
* **TF_stringOption**
* **TF_numberOption**
* **TF_colorOption**
* **TF_floatOption**
* **TF_doubleOption**
* **TF_intOption**
* **TF_uintOption**
* **TF_boolOption**

### TF_option
Any kind of object

### TF_arrayOption
Returns an NSArray of any data stored in an array in the plist.

### TF_dictOption
Returns an NSDictionary with all things in a dictionary from the plist.

### TF_stringOption
A string. NSString to be exact.

### TF_numberOption
NSNumber object.

### TF_colorOption
This type of option wants a string value consisting of a hexadecimal color code.
Returns an UIColor object

### TF_floatOption
Requires an NSNumber compatible plist field. The data is converted to float using ```[number floatValue]```

### TF_doubleOption
Requires an NSNumber compatible plist field. The data is converted to double using ```[number doubleValue]```

### TF_intOption
Requires an NSNumber compatible plist field. The data is converted to NSInteger using ```[number integerValue]```

### TF_uintOption
Requires an NSNumber compatible plist field. The data is converted to NSUInteger using ```[number unsignedIntegerValue]```

### TF_boolValue
Returns ```[number boolValue]``` on a number field from the plist.

## Licence

**TFOptionsKit** is licensed under the terms of the MIT License. Please see the LICENSE file for full details.
