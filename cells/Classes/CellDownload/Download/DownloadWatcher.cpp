/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "DownloadWatcher.h"
#include <stdio.h>
#include <stdlib.h>

NS_CELL_BEGIN

DownloadWatcher::DownloadWatcher()
	:_now(0)
	,_total(0)
	,_state(DOWNLOAD_STATE_INIT)
{

}

DownloadWatcher::~DownloadWatcher()
{

}

float DownloadWatcher::getProgress()
{

	switch (_state)
	{
	case DOWNLOAD_STATE_DOWNLOADING_FINISH:
		return 100.0 ;
	case DOWNLOAD_STATE_DOWNLOADING:
		if ( _total > 0 )
		{
			char s[16] = "" ;
			sprintf(s, "%.2", (_now / _total)) ;
			return atof(s);
		}
		break;
	}

	return 0.0 ;
}

void DownloadWatcher::setProgress(double now, double total)
{
	_now = now ;
	_total = total ;
}

void DownloadWatcher::setDownloadState(DOWNLOAD_STATE state)
{
	_state = state ;
	_now = 0 ;
	_total = 0 ;
}

NS_CELL_END