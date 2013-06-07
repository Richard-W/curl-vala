cmake_minimum_required(VERSION 2.6)
project(vala-curl)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
find_package(Vala REQUIRED)
include(UseVala)

find_package(PkgConfig REQUIRED)

find_package(Curl REQUIRED)

pkg_check_modules(GLIB glib-2.0 REQUIRED)
include_directories(${GLIB_INCLUDE_DIRS})
link_directories(${GLIB_LIBRARY_DIRS})

pkg_check_modules(GOBJECT gobject-2.0 REQUIRED)
include_directories(${GOBJECT_INCLUDE_DIRS})
link_directories(${GOBJECT_LIBRARY_DIRS})

add_subdirectory(src)
