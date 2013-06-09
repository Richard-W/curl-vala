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
