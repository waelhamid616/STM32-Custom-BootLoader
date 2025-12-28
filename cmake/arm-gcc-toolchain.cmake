# Tell CMake we are building for an embedded target, not Linux
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Use the ARM bare-metal toolchain
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Helper tools
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_SIZE arm-none-eabi-size)

# Prevent CMake from trying to run compiled executables during checks
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

