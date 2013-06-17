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
		private Receiver receiver;
		private Sender sender;
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

		/** This sets a Receiver object where data received from curl will be stored */
		public void set_receiver(Receiver receiver) {
			this.receiver = receiver;
			this.handle.setopt(Option.WRITEFUNCTION, write_function);
			this.handle.setopt(Option.FILE, receiver.get_data_struct());
		}

		/** This sets a Sender object where data you want to send is stored */
		public void set_sender(Sender sender) {
			this.sender = sender;
			this.handle.setopt(Option.READFUNCTION, read_function);
			this.handle.setopt(Option.INFILE, sender.get_data_struct());
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
		public void set_mail_rcpt(string[] rcpts) {
			this.rcpt_slist = null;
			foreach(string rcpt in rcpts) {
				this.rcpt_slist = Native.Curl.SList.append((owned)this.rcpt_slist, rcpt);
			}
			this.handle.setopt(Option.MAIL_RCPT, this.rcpt_slist);
		}
	}
}
