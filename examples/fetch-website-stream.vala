int main(string[] args) {
	if(args.length != 2) {
		stderr.printf("usage: %s www.example.org\n".printf(args[0]));
		return 1;
	}

	var curl = new Curl.Easy();

	curl.set_url("http://%s".printf(args[1]));
	curl.set_followlocation(true);
	var istream = new DataInputStream(curl.get_input_stream());

	try {
		curl.perform();
	} catch(Curl.CurlError e) {
		stderr.printf("failed: %s\n", e.message);
		return 1;
	}
	
	string line;
	try {
		while((line = istream.read_line()) != null) {
			stdout.printf("%s\n", line);
		}
	} catch(Error e) {
		stderr.printf("error reading from memory stream: %s\n", e.message);
	}

	return 0;
}
