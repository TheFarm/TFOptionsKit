# TFOptionsKit
A pod that enables you to define target specific options in your project

## Installation
Using Cocoapods, put this line in your Podfile and run pod install:
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
They all take two or three parameters: namespace and key or namspace, key and default.
```
NSString* loadedValue = TF_stringOptionValue(nil, @”The key for my data”, @”No, default loaded”);
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
To reach the ```@"Key"``` part without resorting to something like: ```TF_dictOptionValue(nil, @"Root", nil)[@"Sub"][@"Key"];``` and thus losing the **defaultValue** feature you can access the ```@"Key"``` part this way ```TF_stringOptionValue(@"Root/Sub", @"Key", @"A default string if all else fails");```. All sub dictionaries are delimited by ```/```. This makes organizing your option .plist files easier.

Making namespace constants is recommended if you have multiple nested values, for example:
```
static NSString *const kYourNamespace = @"Root/Sub";

NSString *loadedValue = TF_stringOption(kYourNamespace, @"Key");

...
elsewhere in your code
...

NSString *anotherString = TF_stringOption(kYourNamespace, @"Another key");
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
* Append ```Value``` to any of the above to supply a defaultValue if the namespace + key doesn't exist.

### TF_option(namespace, key)
Any kind of object

### TF_arrayOption(namespace, key)
Returns an NSArray of any data stored in an array in the plist.

### TF_dictOption(namespace, key)
Returns an NSDictionary with all things in a dictionary from the plist.

### TF_stringOption(namespace, key)
A string. NSString to be exact.

### TF_numberOption(namespace, key)
NSNumber object.

### TF_colorOption(namespace, key)
This type of option wants a string value consisting of a hexadecimal color code.
Returns an UIColor object

### TF_floatOption(namespace, key)
Requires an NSNumber compatible plist field. The data is converted to float using ```[number floatValue]```

### TF_doubleOption(namespace, key)
Requires an NSNumber compatible plist field. The data is converted to double using ```[number doubleValue]```

### TF_intOption(namespace, key)
Requires an NSNumber compatible plist field. The data is converted to NSInteger using ```[number integerValue]```

### TF_uintOption(namespace, key)
Requires an NSNumber compatible plist field. The data is converted to NSUInteger using ```[number unsignedIntegerValue]```

### TF_boolOption(namespace, key)
Requires an NSNumber compatible plist field. The data is converted to BOOL using ```[number boolValue]```

### TF_xxxxOptionValue(namespace, key, defaultValue)
Replace xxxx with any of the above. These macros also takes an optional ```defaultValue``` that will be returned if the key doesn't exist.

## Error handling
For development purposes this library will throw NSException under the following circumstances:

1. ```setDefaultOptionsPath:``` if the file isn't found
2. ```loadOptionsOverrideFromPath:``` if the file isn't found
3. ```loadInfoPlistOverridesFromKey:``` if the key isn't found in the targets Info.plist file.
4. If the ```namespace/key``` combination is not found and no defaultValue is supplied
5. If TFOptionsKit encounters an unexpected object type. For example you're trying to get a bool from a key where the plist contains a string.

## Multiple targets sharing the same code but different options

This is where this library comes to its own, the idea here is that you have a shared DefaultOptions.plist for all your targets, and override some of those values with a target specific Options.plist that you load via ```[[TFOptionsKit sharedOptions] loadOptionsOverridesFromPath:@"path/to/your/target specific overrides.plist"]``` method. The method will merge and/or overwrite any values previously loaded from the DefaultOptions.plist. Enabling you to reconfigure any value per target. 

## Licence

**TFOptionsKit** is licensed under the terms of the MIT License. Please see the LICENSE file for full details.
