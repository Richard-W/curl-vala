CFLAGS=`pkg-config gobject-2.0 --cflags --libs` `pkg-config curl-vala --cflags --libs`

all: fetch-website fetch-website-stream

fetch-website: fetch-website.vala
	valac fetch-website.vala --pkg curl-vala -C
	gcc fetch-website.c -o fetch-website ${CFLAGS}

fetch-website: fetch-website-stream.vala
	valac fetch-website-stream.vala --pkg curl-vala -C
	gcc fetch-website-stream.c -o fetch-website-stream ${CFLAGS}
