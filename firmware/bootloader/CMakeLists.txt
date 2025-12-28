cmake_minimum_required(VERSION 3.20)

# --------- Bootloader target ---------
set(TARGET bootloader.elf)

# Linker script (in this folder)
set(LINKER_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/linker/bootloader.ld)

# Startup assembly (CubeMX usually puts it in Core/Startup)
file(GLOB STARTUP_ASM
    ${CMAKE_CURRENT_LIST_DIR}/Core/Startup/*.s
    ${CMAKE_CURRENT_LIST_DIR}/Core/Startup/*.S
)

# C sources (CubeMX usually puts them in Core/Src)
file(GLOB_RECURSE SRC_C
    ${CMAKE_CURRENT_LIST_DIR}/Core/Src/*.c
)

add_executable(${TARGET}
    ${STARTUP_ASM}
    ${SRC_C}
)

# Include directories (CubeMX-style)
target_include_directories(${TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/Core/Inc
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/CMSIS/Include
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/CMSIS/Device/ST/STM32F4xx/Include
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy
)

# MCU define (matches your board)
target_compile_definitions(${TARGET} PRIVATE STM32F446xx)

# Use the shared flags from the parent CMakeLists.txt (must exist there)
target_compile_options(${TARGET} PRIVATE ${COMMON_COMPILE_FLAGS})

target_link_options(${TARGET} PRIVATE
    ${COMMON_LINK_FLAGS}
    -T ${LINKER_SCRIPT}
    -Wl,-Map=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/bootloader.map
    -Wl,--print-memory-usage
)

# Generate .bin after build
add_custom_command(TARGET ${TARGET} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:${TARGET}>
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/bootloader.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${TARGET}>
)
