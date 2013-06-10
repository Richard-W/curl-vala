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
namespace Curl {
	public class Receiver : Object {
		private ReceiverData* data;

		public Receiver() {
			this.data = (ReceiverData*) malloc(sizeof(ReceiverData));
			this.data->len = 0;
			this.data->buffer = null;
		}
		~Receiver() {
			if(this.data->buffer != null)
				free(this.data->buffer);
			free(this.data);
		}


		public string get_string() {
			var builder = new StringBuilder();
			builder.append((string)((char*)(this.data->buffer)));
			return builder.str;
		}

		public void* get_data_struct() {
			return (void*)this.data;
		}
	}

	private struct ReceiverData {
		size_t len;
		void* buffer;
	}

	private size_t write_function(void* buf, size_t size, size_t nmemb, void *data) {
		size_t bytes = size * nmemb;
		ReceiverData* rdata= (ReceiverData*) data;

		rdata->buffer = realloc(rdata->buffer, rdata->len + bytes);
	 
		Posix.memcpy((void*)(((char*)rdata->buffer)+rdata->len), buf, bytes);

		rdata->len += bytes;
		return bytes;
	}
}
