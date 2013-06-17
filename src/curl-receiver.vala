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
[CCode(lower_case_cprefix="vcurl_",cprefix="VCURL_")]
namespace Curl {
	public class Receiver : Object {
		private ReceiverData* data;

		public Receiver() {
			/* Initialize the data-struct */
			this.data = (ReceiverData*) malloc(sizeof(ReceiverData));
			this.data->len = 0;
			this.data->buffer = null;
		}
		~Receiver() {
			if(this.data->buffer != null)
				free(this.data->buffer);
			free(this.data);
		}

		/** Returns the received data after a perform */
		public string get_string() {
			var builder = new StringBuilder();
			builder.append((string)((char*)(this.data->buffer)));
			return builder.str;
		}

		/** Returns a void-pointer used for the internal callback-function */
		public void* get_data_struct() {
			return (void*)this.data;
		}
	}

	/** This struct holds the data received by curl */
	private struct ReceiverData {
		size_t len;
		void* buffer;
	}

	/**
	 * This function implements a prototype defined in libcurl and is used as some
	 * kind of data sink. It would have been better to implement it as a method of Receiver,
	 * but the signature of methods is changed by the vala-compiler. It appends the self-param
	 * for obvious reasons.
	 *
	 * It would have been possible to make the data-pointer a reference to the Receiver object,
	 * but using a struct we can make the internals of this messy operation nearly opaque for
	 * users (except for the get_data_struct()-method).
	 */
	private size_t write_function(void* buf, size_t size, size_t nmemb, void *data) {
		size_t bytes = size * nmemb;
		ReceiverData* rdata= (ReceiverData*) data;

		rdata->buffer = realloc(rdata->buffer, rdata->len + bytes);
	 
		Posix.memcpy((void*)(((char*)rdata->buffer)+rdata->len), buf, bytes);

		rdata->len += bytes;
		return bytes;
	}
}
