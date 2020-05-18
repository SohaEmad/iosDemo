# integrate C++ code in IOS framework

we will start from the very begining by a simple C++ addition project with header file
the programe in it's simplest form should include:
1. add.h
2. main.cpp that include add.h

```c++
#include <iostream>
#include "add.h"
int main() {

    std::cout << "Hello, World!" << std::endl;
    return 0;
}

 int add::addnum(int num1, int num2){
    return num1 + num2;
}
```
the only code we will port to ios is the one with library signature so we can't call main() function only addnum(int , int).

now to build the static library that will encabsulate method implemenatation. you can use one of two approaches

1. using Clion

open C++ project in Clione which should provide you with CMakeLists.txt file, if not exist create one.

the content of the cmake file define the nature of the project build output.

```
cmake_minimum_required(VERSION 3.15)
project(<project_name>)

set(CMAKE_CXX_STANDARD 17)

set(add_LIBRARY_FOR_SIMULATION AddSim)

execute_process(COMMAND bash -c "sysctl -n hw.ncpu | tr -d '\n'"
        OUTPUT_VARIABLE CORECOUNT)
set(CMAKE_BUILD_PARALLEL_LEVEL "${CORECOUNT}")
set(CXX_FLAGS "-Wall")
set(CMAKE_CXX_FLAGS "${CXX_FLAGS}")
set(CMAKE_IOS_INSTALL_COMBINED YES)
set(CMAKE_OSX_DEVELOPMENT_TARGET 10.4)
set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf")
set(CMAKE_SYSTEM_NAME IOS)

#for ios emulator
execute_process(COMMAND bash -c "xcrun --sdk iphonesimulator --show-sdk-platform-version | tr -d '\n' "   OUTPUT_VARIABLE IPHONE_SIMULATOR_VERSION)
execute_process(COMMAND bash -c " xcrun --sdk iphonesimulator --show-sdk-path | sed 's/iPhoneSimulator${IPHONE_SIMULATOR_VERSION}/iPhoneSimulator/g' | tr -d '\n'"
        OUTPUT_VARIABLE IPHONE_SIMULATOR_DIR)
set(CMAKE_OSX_SYSROOT ${IPHONE_SIMULATOR_DIR})
set(CMAKE_OSX_ARCHITECTURES "x86_64;i386")
add_library(${add_LIBRARY_FOR_SIMULATION} STATIC main.cpp add.h)
```

using this code should produce a file libAddSim.a in cmake-build-debug folder.

- to start next step we need add.h (header library) and libAddSim.a files.
- the only edit we need to do before start integration step is to rename LibAddSim.a to lAddSim.a as this the name convention required by ios for static lib

on the ios side
in the framework we will need to add add.h (header library) in the framework directory and add lAddSim.a

![alt text](https://github.com/SohaEmad/iosDemo/blob/master/images/addLib.png?raw=true)

now we need to create objective-C header and .mm wrapper


```
#import <Foundation/Foundation.h>

@interface <wrapperHeaderName>: NSObject

- (int)addtestobj:(int) num1
             num2:(int) num2;
@end
```
wrapper.mm file should import the two headers

```
#import "add.h"
#import "addwrapperheader.h"

@implementation <wrapperHeaderName>: NSObject

  add <objectName> = add();

- (int)addtestobj:(int) num1
             num2:(int) num2{
   return  <objectName>.addnum( num1, num2); // call function encabsulated functions

}
@end

```

all .h files should be public insteade of project in <frameworkname.framework>

![alt text](https://github.com/SohaEmad/iosDemo/blob/master/images/publicLib2.png?raw=true)

![alt text](https://github.com/SohaEmad/iosDemo/blob/master/images/publicLib.png?raw=true)

add the following line at the end of the <frameworkname>.h file
```#include "addwrapperheader.h"
```
import framework to any single view ios app that will expose all functions clarified in addwrapperheader.h

and we can use the function through an object of the wrapperclass

```
testwrapperheader().addtestobj(12,num2:3);
```
![output](https://github.com/SohaEmad/iosDemo/blob/master/images/output.png?raw=true)
