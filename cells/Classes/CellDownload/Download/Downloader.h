/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include "curl/curl.h"
#include "../Utils/CellMacro.h"

NS_CELL_BEGIN

class Downloader
{
private:
	CURL* _curlHandle ;
	FILE* _fp ;

	long _connectTimeOut, _readTimeOut ;

public:
	Downloader(long connectTimeOut = 5L, long readTimeOut = 30L) ;
	virtual ~Downloader() ;

	bool download(const char* url, FILE* fp, bool brokenResume) ;

	void reset() ;

private:
	static size_t download_data(void* buffer, size_t size, size_t nmemb, void* context);
	static int download_progress(void *ctx, double dlTotal, double dlNow, double upTotal, double upNow);

	void init() ;
};

NS_CELL_END