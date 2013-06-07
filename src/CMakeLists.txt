vala_precompile(C_SOURCES
		curl-easy.vala
		curl-curlerror.vala
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
