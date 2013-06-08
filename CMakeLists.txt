cmake_minimum_required(VERSION 2.6)
project(vala-curl)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_MAINTENANCE 0)

set(VERSION_STRING "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_MAINTENANCE}")

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

configure_file(
	"${CMAKE_SOURCE_DIR}/vala-curl.pc.in"
	"${CMAKE_CURRENT_BINARY_DIR}/vala-curl.pc"
)

install(
	FILES
		${CMAKE_CURRENT_BINARY_DIR}/vala-curl.pc
	DESTINATION
		lib/pkgconfig/
)
