/*
 * This file is part of the vala-curl project.
 * 
 * Copyright 2013 Richard Wiedenhöft <richard.wiedenhoeft@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Native.Curl;

namespace Curl {
	public class Easy : Object {
		private CURL* handle;

		//Mainly for reference so the receiver and the sender are not freed
		private Receiver receiver;
		private Sender sender;

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
				throw new CurlError.PERFORM_FAILED((string)curl_easy_strerror(res));
		}

		public void set_url(string url) {
			curl_easy_setopt(this.handle, CURLOPT_URL, url);
		}

		public void set_followlocation(bool val) {
			curl_easy_setopt(this.handle, CURLOPT_FOLLOWLOCATION, val);
		}

		public void set_receiver(Receiver receiver) {
			this.receiver = receiver;
			curl_easy_setopt(this.handle, CURLOPT_WRITEFUNCTION, write_function);
			curl_easy_setopt(this.handle, CURLOPT_FILE, receiver.get_data_struct());
		}

		public void set_sender(Sender sender) {
			this.sender = sender;
			curl_easy_setopt(this.handle, CURLOPT_READFUNCTION, read_function);
			curl_easy_setopt(this.handle, CURLOPT_INFILE, sender.get_data_struct());
		}

		public void set_ssl(bool val) {
			if(val)
				curl_easy_setopt(this.handle, CURLOPT_USE_SSL, (long)CURLUSESSL_ALL);
			else
				curl_easy_setopt(this.handle, CURLOPT_USE_SSL, (long)CURLUSESSL_NONE);
		}

		public void set_username(string username) {
			curl_easy_setopt(this.handle, CURLOPT_USERNAME, username);
		}

		public void set_password(string password) {
			curl_easy_setopt(this.handle, CURLOPT_PASSWORD, password);
		}

		public void set_mail_from(string from) {
			curl_easy_setopt(this.handle, CURLOPT_MAIL_FROM, from);
		}

		public void set_mail_rcpt(string rcpt) {
			curl_easy_setopt(this.handle, CURLOPT_MAIL_RCPT, rcpt);
		}
	}
}
