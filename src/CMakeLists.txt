vala_precompile(C_SOURCES
		curl-easy.vala
		curl-curlerror.vala
		curl-receiver.vala
	PACKAGES
		posix
	CUSTOM_VAPIS
		native-curl.vapi
	GENERATE_VAPI
		vala-curl
)

add_library(vala-curl SHARED ${C_SOURCES})
target_link_libraries(vala-curl
	${GLIB_LIBRARIES}
	${GOBJECT_LIBRARIES}
	${CURL_LIBRARIES}
)

install(
	TARGETS
		vala-curl
	LIBRARY DESTINATION lib
)

install(
	FILES
		${CMAKE_CURRENT_BINARY_DIR}/vala-curl.vapi
	DESTINATION
		share/vala/vapi/
)

install(
	FILES
		${CMAKE_CURRENT_BINARY_DIR}/vala-curl.h
	DESTINATION
		include/
)
