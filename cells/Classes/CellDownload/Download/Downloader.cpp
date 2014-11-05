#include "Downloader.h"
#include <assert.h>

NS_CELL_BEGIN

const double BYTES_TO_FLUSH  = 1024 * 512 ;
static char s_curl_error_buffer[CURL_ERROR_SIZE] ;

Downloader::Downloader()
	:_curlHandle(nullptr)
	,_fp(nullptr)
{
	_curlHandle = curl_easy_init() ;

	init() ;
}

Downloader::~Downloader()
{
	curl_easy_cleanup(_curlHandle) ;
}

size_t Downloader::download_data(void* buffer, size_t size, size_t nmemb, void* context)
{
	Downloader* handle = static_cast<Downloader*> (context) ;
	assert(handle && handle->_fp) ;
	size_t s = fwrite(buffer, size, nmemb, handle->_fp) ;
	if ( (size * nmemb) >= BYTES_TO_FLUSH )
	{
		fflush(handle->_fp) ;
	}
	return s  ;
}

int Downloader::download_progress(void *context, double dlTotal, double dlNow, double upTotal, double upNow)
{
	Downloader* handle = static_cast<Downloader*> (context) ;

	return 0 ;
}

void Downloader::init()
{
	assert(_curlHandle) ;

	//curl_easy_setopt(_curlHandle, CURLOPT_URL, "www.baidu.com") ;

	curl_easy_setopt(_curlHandle, CURLOPT_CONNECTTIMEOUT, 50L) ;
	curl_easy_setopt(_curlHandle, CURLOPT_TIMEOUT, 100L) ;

	curl_easy_setopt(_curlHandle, CURLOPT_NOSIGNAL, 1L) ;

	curl_easy_setopt(_curlHandle, CURLOPT_WRITEFUNCTION, Downloader::download_data) ;
	curl_easy_setopt(_curlHandle, CURLOPT_WRITEDATA, this) ;

	curl_easy_setopt(_curlHandle, CURLOPT_NOPROGRESS, false) ;
	curl_easy_setopt(_curlHandle, CURLOPT_PROGRESSFUNCTION, Downloader::download_progress) ;
	curl_easy_setopt(_curlHandle, CURLOPT_PROGRESSDATA, this) ;

	curl_easy_setopt(_curlHandle, CURLOPT_ERRORBUFFER, s_curl_error_buffer) ;

}

bool Downloader::download(const char* url, FILE* fp, bool brokenResume)
{
	assert(fp) ;
	_fp = fp ;

	curl_easy_setopt(_curlHandle, CURLOPT_URL, url) ;

	if (brokenResume)
	{
		fseek(fp, 0, SEEK_END);
		size_t rangeBegin = (size_t)ftell(fp);

		std::stringstream rangeStr ;
		rangeStr<<rangeBegin ;
		rangeStr<<std::string("-") ;
		curl_easy_setopt(_curlHandle, CURLOPT_RANGE, rangeStr.str().c_str()) ;
	}

	CURLcode responseCode = curl_easy_perform(_curlHandle) ;

	int responseInfo = 0 ;
	if (responseCode == CURLE_OK)
	{
		responseCode = curl_easy_getinfo(_curlHandle, CURLINFO_RESPONSE_CODE, &responseInfo) ;
	}

	//CELL_LOG("download finish curl returned responseCode=%d responseInfo=%d\n", responseCode, responseInfo) ;

	if ( CURLE_OK == responseCode && responseInfo < 300 )
	{
		return true ;
	}

	switch(responseCode)
	{
	case CURLE_COULDNT_RESOLVE_PROXY:
	case CURLE_URL_MALFORMAT:
	case CURLE_COULDNT_RESOLVE_HOST:
	case CURLE_COULDNT_CONNECT:
	case CURLE_REMOTE_ACCESS_DENIED:
	case CURLE_FTP_WEIRD_SERVER_REPLY:
	case CURLE_FTP_WEIRD_PASS_REPLY:
	case CURLE_FTP_WEIRD_PASV_REPLY:
	case CURLE_FTP_CANT_GET_HOST:
	case CURLE_FTP_WEIRD_227_FORMAT:
	case CURLE_FTP_USER_PASSWORD_INCORRECT:
	case CURLE_FTP_PRET_FAILED:
	case CURLE_HTTP_POST_ERROR:
	case CURLE_FAILED_INIT:
	case CURLE_SEND_ERROR:
	case CURLE_RECV_ERROR:
	case CURLE_LOGIN_DENIED:
	case CURLE_AGAIN:
		CELL_LOG("curl returned connect error: %d\n", responseCode) ;
		break;
	case CURLE_HTTP_RETURNED_ERROR:
	case CURLE_REMOTE_FILE_NOT_FOUND:
		CELL_LOG("curl returned file not exist error: %d\n", responseCode) ;
		break;
	case CURLE_OPERATION_TIMEOUTED:
		CELL_LOG("curl returned timeout error: %d\n", responseCode) ;
		break;
	case CURLE_OK:
		if ( responseInfo == 404 )
		{
			CELL_LOG("curl download: file not exist error: %d\n", responseInfo) ;
		}
		else
		{

			CELL_LOG("curl download: server response error code: %d\n", responseInfo) ;
		}
		break;
	default:
		CELL_LOG("curl returned fatal error: %d\n", responseCode) ;
	}

	CELL_LOG(s_curl_error_buffer) ;
	return false ;
}

NS_CELL_END