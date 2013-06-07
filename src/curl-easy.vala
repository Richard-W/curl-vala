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

		[CCode(cname="curl_easy_start")]
		public void perform() throws CurlError {
			int res = curl_easy_perform(this.handle);
			if(res != 0)
				throw new CurlError.PERFORM_FAILED(curl_easy_strerror(res));
		}

		public void set_url(string url) {
			curl_easy_setopt(this.handle, CURLOPT_URL, url);
		}

		public void set_followlocation(bool val) {
			curl_easy_setopt(this.handle, CURLOPT_FOLLOWLOCATION, val);
		}

		public void set_receiver(Receiver receiver) {
			curl_easy_setopt(this.handle, CURLOPT_WRITEFUNCTION, receiver.write_function);
		}
	}
}
