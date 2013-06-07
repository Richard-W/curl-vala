[CCode(cheader_filename="curl/curl.h",lower_case_cprefix="",cprefix="")]
namespace Native.Curl {
	/* Types */

	[SimpleType]
	public struct CURL {}

	/* Functions */

	public CURL* curl_easy_init();
	public void curl_easy_cleanup(CURL* handle);
}
