############################
# Aishiteru
###########################

###########################
# cmake settings
###########################


cmake_minimum_required(VERSION 3.7 FATAL_ERROR)

# In-source build are disable

if ("${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
    message(FATAL_ERROR
        "CMake generation is not possible within the source directory!"
        "\n Remove the CMakeCache.txt file and try again from another folder, e.g.:"
        "\n "
        "\n rm CMakeCache.txt"
        "\n mkdir build"
        "\n cd build"
        "\n cmake .."
    )
endif()

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}")

# Use solution folders.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGET_FOLDER "CMake Targets")

############################################################################

# Project Setting
project(aishiteru C CXX)
# Get version with component from version files
# Check for CXX standard to use


# Get version with components from VERSION file.
file(STRINGS "VERSION" VERSION_PLAIN)
string(REGEX REPLACE "^([^.]*)\\..*" "\\1" VERSION_MAJOR ${VERSION_PLAIN})
string(REGEX REPLACE "^[^.]*\\.([^.]*)\\..*" "\\1" VERSION_MINOR ${VERSION_PLAIN})
string(REGEX REPLACE "^[^.]*\\.[^.]*\\.([0-9]*).*" "\\1" VERSION_PATCH ${VERSION_PLAIN})
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git)
    execute_process(COMMAND git --git-dir ${CMAKE_CURRENT_SOURCE_DIR}/.git describe --abbrev=4
        OUTPUT_VARIABLE GIT_REV)
        string(REGEX REPLACE "\n$" "" PACKAGE_VERSION "${GIT_REV}")
endif()
if(NOT PACKAGE_VERSION)
    set(PACKAGE_VERSION ${VERSION_PLAIN})
endif()

# Provide also same macro names as autoconf (see configure.ac).
set(GENERIC_MAJOR_VERSION ${VERSION_MAJOR})
set(GENERIC_MINOR_VERSION ${VERSION_MINOR})
set(GENERIC_MICRO_VERSION ${VERSION_PATCH})


###############################################################################
#
# options
#
###############################################################################

message( "Menyetel aishiteru versi ${PACKAGE_VERSION}...")

include(CheckCXXCompilerFlag)


get_property(known_features GLOBAL PROPERTY CMAKE_CXX_KNOWN_FEATURES)
if (cxx_std_17 IN_LIST known_features)
  set(CMAKE_CXX_STANDARD 17)
  message(STATUS "Your CXX standard is 17")
elseif (cxx_std_14 IN_LIST known_features)
  message(STATUS "Your CXX standard is 14")
  set(CMAKE_CXX_STANDARD 14)
else() # minimum standard required
  message(STATUS "Your CXX standard is 11")
  set(CMAKE_CXX_STANDARD 11)
endif()

# Avoid using experimental c++1y (c++1z) standard even if the compiler announces cxx14 (cxx17)
# in CMAKE_CXX_KNOWN_FEATURES and CMAKE_CXX_COMPILE_FEATURES
# It is the case of clang 3.9, 4.0 (announces c++1z) and gcc 4.8 (announces c++1y)
if ("${CMAKE_CXX17_STANDARD_COMPILE_OPTION}" STREQUAL "-std=c++1z")
  set(CMAKE_CXX_STANDARD 14)
endif()
if ("${CMAKE_CXX14_STANDARD_COMPILE_OPTION}" STREQUAL "-std=c++1y")
  set(CMAKE_CXX_STANDARD 11)
endif()

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)



###########################
# LIBRARY aishiteru
###########################

set(LIBRARY_TYPE SHARED)
if(STATIC)
  set(LIBRARY_TYPE)
endif()

file(GLOB aishiteru_src
  src/dict/*.cpp
  
  )

list(APPEND arch_files
  src/arch/*.cpp

  )

add_library(libaishiteru ${aishiteru_src})

################################
# AISHITERU executable program #
################################
get_target_property(aishiteru_NAME libaishiteru NAME)
get_target_property(aishiteru_VERSION libaishiteru VERSION)
get_target_property(aishiteru_OUTPUT_NAME libaishiteru OUTPUT_NAME)



file(GLOB aishiteru_hdr
  src/arch/*.h
  src/dict/*.h
  )
set(aishiteru_src ${aishiteru_src}
  src/api/baseapi.cpp
  src/api/capi.cpp
)

set(aishiterumain_src src/api/aishiterumain.cpp)

add_executable(aishiteru ${aishiterumain_src})


##########################################
# Uninstall Target
###########################################
