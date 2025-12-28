cmake_minimum_required(VERSION 3.20)

# --------- App target ---------
set(TARGET app.elf)

set(LINKER_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/linker/app.ld)

file(GLOB STARTUP_ASM
    ${CMAKE_CURRENT_LIST_DIR}/Core/Startup/*.s
    ${CMAKE_CURRENT_LIST_DIR}/Core/Startup/*.S
)

file(GLOB_RECURSE SRC_C
    ${CMAKE_CURRENT_LIST_DIR}/Core/Src/*.c
)

add_executable(${TARGET}
    ${STARTUP_ASM}
    ${SRC_C}
)

target_include_directories(${TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/Core/Inc
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/CMSIS/Include
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/CMSIS/Device/ST/STM32F4xx/Include
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc
    ${CMAKE_CURRENT_LIST_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy
)

target_compile_definitions(${TARGET} PRIVATE STM32F446xx)

target_compile_options(${TARGET} PRIVATE ${COMMON_COMPILE_FLAGS})

target_link_options(${TARGET} PRIVATE
    ${COMMON_LINK_FLAGS}
    -T ${LINKER_SCRIPT}
    -Wl,-Map=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/app.map
    -Wl,--print-memory-usage
)

add_custom_command(TARGET ${TARGET} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:${TARGET}>
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/app.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${TARGET}>
)
