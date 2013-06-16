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

		//Mainly for reference so the receiver and the sender are not freed
		private Receiver receiver;
		private Sender sender;

		public Easy() throws CurlError {
			this.handle = new EasyHandle();
		}

		public void perform() throws CurlError {
			Code res = this.handle.perform();
			if(res != Code.OK)
				throw new CurlError.PERFORM_FAILED(Global.strerror(res));
		}

		public void set_url(string url) {
			this.handle.setopt(Option.URL, url);
		}

		public void set_followlocation(bool val) {
			this.handle.setopt(Option.FOLLOWLOCATION, val);
		}

		public void set_receiver(Receiver receiver) {
			this.receiver = receiver;
			this.handle.setopt(Option.WRITEFUNCTION, write_function);
			this.handle.setopt(Option.FILE, receiver.get_data_struct());
		}

		public void set_sender(Sender sender) {
			this.sender = sender;
			this.handle.setopt(Option.READFUNCTION, read_function);
			this.handle.setopt(Option.INFILE, sender.get_data_struct());
		}

		public void set_ssl(bool val) {
			if(val)
				this.handle.setopt(Option.USE_SSL, UseSSL.ALL);
			else
				this.handle.setopt(Option.USE_SSL, UseSSL.NONE);
		}

		public void set_username(string username) {
			this.handle.setopt(Option.USERNAME, username);
		}

		public void set_password(string password) {
			this.handle.setopt(Option.PASSWORD, password);
		}

		public void set_mail_from(string from) {
			this.handle.setopt(Option.MAIL_FROM, from);
		}

		public void set_mail_rcpt(string[] rcpts) {
			Native.Curl.slist* slist = null;
			foreach(string rcpt in rcpts) {
				slist = Native.Curl.slist_append(slist, rcpt.to_utf8());
			}
			this.handle.setopt(Option.MAIL_RCPT, slist);
		}
	}
}
