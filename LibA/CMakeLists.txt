cmake_minimum_required(VERSION 3.15)
# Make sure we can find our custom CMake modules
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_SOURCE_DIR}/cmake" "${CMAKE_BINARY_DIR}")
list(INSERT CMAKE_PREFIX_PATH 0 "${CMAKE_BINARY_DIR}/conan" "${CMAKE_BINARY_DIR}")

include(MyConan)

project(LibA CXX)

if(CMAKE_ENABLE_CONAN)
    # Only call conan if we are being built from CMake and not from conan
    conan_cmake_autodetect(settings)
    conan_cmake_install(PATH_OR_REFERENCE ${CMAKE_SOURCE_DIR}
            BUILD missing
            OPTIONS ${CONAN_RUN_OPTIONS}
            SETTINGS ${settings})
endif(CMAKE_ENABLE_CONAN)

find_package(Poco REQUIRED Foundation Util)

file(GLOB HEADERS src/*.h)
file(GLOB SOURCES src/*.cpp)
file(GLOB_RECURSE PUBLIC_HEADERS include/*.h ${CMAKE_CURRENT_BINARY_DIR}/include/*.h)
#message(WARNING "Bla: ${CMAKE_CURRENT_SOURCE_DIR}")
add_library(LibA STATIC ${SOURCES} ${HEADERS} ${PUBLIC_HEADERS})
target_include_directories(LibA
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

target_link_libraries(LibA PUBLIC Poco::Util)

#set_target_properties(LibA PROPERTIES PUBLIC_HEADER "include/LibA.h")
install(TARGETS LibA)
