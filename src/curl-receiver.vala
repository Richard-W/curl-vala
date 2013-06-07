namespace Curl {
	public class Receiver : Object {
		private char* buffer = null;
		size_t buflen = 0;

		public Receiver() {}
		~Receiver() {
			free(this.buffer);
		}

		public size_t write_function(void* buf, size_t size, size_t nmemb, void *userptr) {
			size_t bytes = size * nmemb;
			this.buffer = realloc(this.buffer, this.buflen + bytes);

			for(int i = 0; i < bytes; i++) {
				stdout.printf("i: %d\nbytes: %d\n\n", i, (int)bytes);
				*(this.buffer + buflen + i) = *((char*)buf + i);
			}

			this.buflen += bytes;
			return bytes;
		}

		public string get_string() {
			var builder = new StringBuilder();
			builder.append((string)buffer);
			return builder.str;
		}
	}
}
