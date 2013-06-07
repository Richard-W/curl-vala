using Native.Curl;

namespace Curl {
	public class Easy : Object {
		private CURL* handle;

		public Easy() throws CurlError {
			this.handle = curl_easy_init();
			if(this.handle == null)
				throw new CurlError.INIT_FAILED("Initialization of CURL-handle failed");
		}
		~Easy() {
			curl_easy_cleanup(this.handle);
		}

		private string strerror(int num) {
			var builder = new StringBuilder();
			char* errptr = curl_easy_strerror(num);
			builder.append((string) errptr);
			curl_free(errptr);
			return builder.str;
		}

		public void perform() throws CurlError {
			int res = curl_easy_perform(this.handle);
			if(res != 0)
				throw new CurlError.PERFORM_FAILED(this.strerror(res));
		}
	}
}
