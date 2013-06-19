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

[CCode(lower_case_cprefix="vcurl_",cprefix="VCURL_")]
namespace Curl {
	public class Easy : Object {
		private EasyHandle handle;

		/* References to be sure the objects do not get freed prematurely */
		private OutputStream output_stream;
		private InputStream input_stream;
		private Native.Curl.SList rcpt_slist;

		public Easy() throws CurlError {
			this.handle = new EasyHandle();
		}

		/** Perform the transfer after options are set */
		public void perform() throws CurlError {
			Code res = this.handle.perform();
			if(res != Code.OK)
				throw new CurlError.PERFORM_FAILED(Global.strerror(res));
		}

		/**
		 * Set the URL of the service you want to contact
		 *
		 * Examples:
		 * http://www.example.org
		 * ftp://ftp.example.org
		 * imap://imap.example.org
		 */
		public void set_url(string url) {
			this.handle.setopt(Option.URL, url);
		}

		/** Whether curl follows location-headers in HTTP-answers */
		public void set_followlocation(bool val) {
			this.handle.setopt(Option.FOLLOWLOCATION, val);
		}

		/** This sets the output-stream that curl will write to */
		public void set_output_stream(OutputStream output_stream) {
			this.output_stream = output_stream;
			this.handle.setopt(Option.WRITEFUNCTION, write_function);
			this.handle.setopt(Option.FILE, (void*)output_stream);
		}

		/** This sets the input-stream that curl will read from */
		public void set_input_stream(InputStream input_stream) {
			this.input_stream = input_stream;
			this.handle.setopt(Option.READFUNCTION, read_function);
			this.handle.setopt(Option.INFILE, (void*)input_stream);
		}

		/** Whether SSL/TLS is required */
		public void set_ssl(bool val) {
			if(val)
				this.handle.setopt(Option.USE_SSL, UseSSL.ALL);
			else
				this.handle.setopt(Option.USE_SSL, UseSSL.NONE);
		}

		/** Set the Username */
		public void set_username(string username) {
			this.handle.setopt(Option.USERNAME, username);
		}

		/** Set the password */
		public void set_password(string password) {
			this.handle.setopt(Option.PASSWORD, password);
		}

		/** Set the mail-address of the sender */
		public void set_mail_from(string from) {
			this.handle.setopt(Option.MAIL_FROM, from);
		}

		/** Set the recipient mail addresses. */
		public void set_mail_rcpts(string[] rcpts) {
			this.rcpt_slist = null;
			foreach(string rcpt in rcpts) {
				this.rcpt_slist = Native.Curl.SList.append((owned)this.rcpt_slist, rcpt);
			}
			this.handle.setopt(Option.MAIL_RCPT, this.rcpt_slist);
		}
	}
}
