int main(string[] args) {
	if(args.length != 2) {
		stderr.printf("usage: %s www.example.org".printf(args[0]));
		return 1;
	}

	var curl = new Curl.Easy();

	curl.set_url("http://%s".printf(args[1]));
	curl.set_followlocation(true);

	//Define stream that curl will write to
	var mostream = new MemoryOutputStream(null, GLib.realloc, GLib.free);
	curl.set_output_stream(mostream);

	try {
		curl.perform();
	} catch(Curl.CurlError e) {
		stderr.printf("failed: %s\n", e.message);
		return 1;
	}
	
	try {
		mostream.close();
	} catch(Error e) {
		stderr.printf("failed: %s\n", e.message);
	}

	//Steal the data from the output stream and wrap it into a input stream 
	//to read from
	var mistream = new MemoryInputStream.from_data(mostream.steal_data(), GLib.free);
	var istream = new DataInputStream(mistream);

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
