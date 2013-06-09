namespace Curl {
	public class Sender {
		private SenderData* data;

		public Sender(char[] data) {
			this.data = (SenderData*) malloc(sizeof(SenderData));
			this.data->len = data.length;
			this.data->buffer = malloc(this.data->len);
			Posix.memcpy(this.data->buffer, (void*)data, this.data->len);
		}
		~Sender() {
			if(this.data->len > 0)
				free(this.data->buffer);
			free((void*)this.data);
		}

		public void* get_data_struct() {
			return (void*)this.data;
		}
	}

	private struct SenderData {
		size_t len;
		size_t position;
		void* buffer;
	}

	private size_t read_function(void* ptr, size_t size, size_t nmemb, void* data) {
		SenderData* rdata = (SenderData*) data;
		size_t bytes = size * nmemb;

		if(rdata->position == rdata->len)
			return 0;

		size_t bytes_left = rdata->len - rdata->position;
		if(bytes_left < bytes)
			bytes = bytes_left;

		Posix.memcpy(ptr, (void*)(((char*)rdata->buffer)+rdata->position), bytes);
		rdata->position += bytes;

		return bytes;
	}
}
