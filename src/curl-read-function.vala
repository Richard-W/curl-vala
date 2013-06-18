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
[CCode(lower_case_cprefix="vcurl",cprefix="VCURL_")]
namespace Curl {
	private size_t read_function(void* ptr, size_t size, size_t nmemb, void* data) {
		size_t bytes = size * nmemb;
		InputStream stream = (InputStream) data;

		uint8[] buffer = new uint8[bytes];
		size_t read_bytes;
		try {
			read_bytes = stream.read(buffer, null);
		} catch(IOError e) {
			stderr.printf("IOError in read_function: %s\n",e.message);
			return 0;
		}
		
		Posix.memcpy(ptr, (void*)buffer, read_bytes);

		return read_bytes;
	}
}
