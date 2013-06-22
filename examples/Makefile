all: fetch-website fetch-website-stream send-mail

%: %.vala
	valac $< --pkg curl-vala
