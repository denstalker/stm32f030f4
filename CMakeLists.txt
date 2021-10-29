SET(CMAKE_TOOLCHAIN_FILE STM32F0xx.cmake)

set(PRJ_NAME FIRST_STM_LED)
set(MCU_FAMILY STM32F0xx)
set(MCU_LINE STM32F030x6)
set(MCU_LINKER_SCRIPT STM32F030F4Px_FLASH.ld)
set(STARTUP_ASM stm32f030x6)

cmake_minimum_required(VERSION 3.10)

project(${PRJ_NAME} C CXX ASM)

add_definitions(-D${MCU_LINE})
add_definitions(-DUSE_HAL_LIBRARY)

# file(GLOB_RECURSE USER_SOURCES Src/*.c)

file(GLOB_RECURSE USER_SOURCES Core/Src/*.c)
# file(GLOB_RECURSE SSD1306_SOURCES SSD1306/*.c)
file(GLOB_RECURSE HAL_SOURCES Drivers/${MCU_FAMILY}_HAL_Driver/Src/*.c)
file(GLOB_RECURSE CMSIS_SYSTEM Drivers/CMSIS/Device/ST/${MCU_FAMILY}/Source/Templates/system_${MCU_FAMILY}.c)
file(GLOB_RECURSE CMSIS_STARTUP Drivers/CMSIS/Device/ST/${MCU_FAMILY}/Source/Templates/gcc/startup_${STARTUP_ASM}.s)

set(SOURCE_FILES ${CMSIS_STARTUP} ${USER_SOURCES} ${HAL_SOURCES} ${CMSIS_SYSTEM} ${MCU_LINKER_SCRIPT})

include_directories(Drivers/CMSIS/Device/ST/STM32F0xx/Include)
include_directories(Drivers/CMSIS/Include)
include_directories(Drivers/STM32F0xx_HAL_Driver/Inc)
include_directories(Core/Inc)
# include_directories(SSD1306)

add_executable(${PROJECT_NAME}.elf ${SOURCE_FILES})

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.map")
set(HEX_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.bin)
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE} \nBuilding ${BIN_FILE}")
