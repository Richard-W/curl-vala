all: fetch-website fetch-website-stream

%: %.vala
	valac $< --pkg curl-vala
