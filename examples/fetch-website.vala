int main(string[] args) {
	if(args.length != 2) {
		stderr.printf("usage: %s www.example.org\n".printf(args[0]));
		return 1;
	}

	var curl = new Curl.Easy();

	curl.set_url("http://%s".printf(args[1]));
	curl.set_followlocation(true);

	try {
		curl.perform();
	} catch(Curl.CurlError e) {
		stderr.printf("failed: %s\n".printf(e.message));
		return 1;
	}
	return 0;
}
