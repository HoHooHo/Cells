#pragma once
#include "curl/curl.h"
#include "../Utils/CellMacro.h"

NS_CELL_BEGIN

class Downloader
{
private:
	CURL* _curlHandle ;
	FILE* _fp ;

public:
	Downloader() ;
	virtual ~Downloader() ;

	bool download(const char* url, FILE* fp, bool brokenResume) ;

private:
	static size_t download_data(void* buffer, size_t size, size_t nmemb, void* context);
	static int download_progress(void *ctx, double dlTotal, double dlNow, double upTotal, double upNow);

	void init() ;
};

NS_CELL_END