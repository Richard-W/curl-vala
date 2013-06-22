int main(string[] args) {
	if(args.length != 7) {
		stderr.printf("usage: %s smtp-server smtp-port smtp-user smtp-password from to\n".printf(args[0]));
		return 1;
	}

	var curl = new Curl.Easy();

	curl.set_url("smtp://%s:%s".printf(args[1], args[2]));
	curl.set_username(args[3]);
	curl.set_password(args[4]);
	curl.set_mail_from(args[5]);
	curl.set_mail_rcpts({args[6]});
	curl.set_ssl(true);

	var ostream = new DataOutputStream(curl.get_output_stream());

	try {
		string line;
		while((line = stdin.read_line()) != null) {
			ostream.put_string("%s\n".printf(line));
		}
	} catch(Error e) {
		stderr.printf("error: %s\n", e.message);
	}

	try {
		curl.perform();
	} catch(Error e) {
		stderr.printf("error sending mail: %s\n", e.message);
	}

	return 0;
}
