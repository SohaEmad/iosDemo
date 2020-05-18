cmake_minimum_required(VERSION 3.15)
project(c__DemoApp)

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
