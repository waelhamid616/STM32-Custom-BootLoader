cmake_minimum_required(VERSION 3.20)

# Parent project: coordinates all firmware builds
project(custom_bootloader C ASM)

# Where you stored CMSIS/HAL packs
set(STM32_PACKS_DIR
    "${CMAKE_CURRENT_LIST_DIR}/packs"
    CACHE PATH "STM32 vendor packs directory"
)

# Put build outputs in a consistent place (build directory)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out)

# ------------ MCU SETTINGS (shared by bootloader + app) ------------
set(MCU_CPU cortex-m4)
set(MCU_FPU fpv4-sp-d16) # supports single-precision floats not double / 16 fp reg 
set(MCU_FLOAT_ABI hard)  # use the FPU registers for function args and ret values 

# Common flags used by BOTH targets
set(COMMON_COMPILE_FLAGS
    -mcpu=${MCU_CPU}
    -mthumb
    -mfpu=${MCU_FPU}
    -mfloat-abi=${MCU_FLOAT_ABI}
    -ffunction-sections # put each function in its own elf/ enables linker to delete unsued code  
    -fdata-sections  # put each gloabal/static in its own section/ enables linker to delete unsused code
    -Wall -Wextra
)

set(COMMON_LINK_FLAGS
    -mcpu=${MCU_CPU}
    -mthumb
    -mfpu=${MCU_FPU}
    -mfloat-abi=${MCU_FLOAT_ABI}
    -Wl,--gc-sections # to delete unsued code 
)

# Define the MCU symbol so the STM32 headers include the right device registers
add_compile_definitions(STM32F446xx)

# ------------ Build firmware targets ------------
add_subdirectory(firmware/bootloader)
add_subdirectory(firmware/app)

