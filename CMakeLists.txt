cmake_minimum_required(VERSION 2.6)
project(curl-vala)

option(INSTALL_HEADERS "Install header, vapi and pkgconfig files" ON)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_MAINTENANCE 0)

set(VERSION_STRING "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_MAINTENANCE}")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
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

pkg_check_modules(GIO gio-2.0 REQUIRED)
include_directories(${GIO_INCLUDE_DIRS})
link_directories(${GIO_LIBRARY_DIRS})

vala_precompile(C_SOURCES
		src/curl-easy.vala
		src/curl-curlerror.vala
		src/curl-write-function.vala
		src/curl-read-function.vala
		src/curl-functions.vala
	PACKAGES
		posix
		gio-2.0
	CUSTOM_VAPIS
		src/libcurl.vapi
	GENERATE_VAPI
		curl-vala
	OPTIONS
		-g
)

add_library(curl-vala SHARED ${C_SOURCES})
target_link_libraries(curl-vala
	${GLIB_LIBRARIES}
	${GOBJECT_LIBRARIES}
	${CURL_LIBRARIES}
	${GIO_LIBRARIES}
)

install(
	TARGETS
		curl-vala
	LIBRARY DESTINATION lib
)

if(INSTALL_HEADERS)
	install(
		FILES
			${CMAKE_CURRENT_SOURCE_DIR}/curl-vala.deps
			${CMAKE_CURRENT_BINARY_DIR}/curl-vala.vapi
		DESTINATION
			share/vala/vapi/
	)

	install(
		FILES
			${CMAKE_CURRENT_BINARY_DIR}/curl-vala.h
		DESTINATION
			include/
	)

	configure_file(
		"${CMAKE_CURRENT_SOURCE_DIR}/curl-vala.pc.in"
		"${CMAKE_CURRENT_BINARY_DIR}/curl-vala.pc"
	)

	install(
		FILES
			${CMAKE_CURRENT_BINARY_DIR}/curl-vala.pc
		DESTINATION
			lib/pkgconfig/
	)
endif(INSTALL_HEADERS)
