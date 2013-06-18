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
	private size_t write_function(void* buf, size_t size, size_t nmemb, void *data) {
		size_t bytes = size * nmemb;
		OutputStream stream = (OutputStream) data;

		uint8[] buffer = new uint8[bytes];
		Posix.memcpy((void*)buffer, buf, bytes);

		size_t bytes_written;
		try {
			bytes_written = stream.write(buffer, null);
		} catch(IOError e) {
			stderr.printf("IOError in write_function: %s\n", e.message);
			return 0;
		}

		return bytes_written;
	}
}
