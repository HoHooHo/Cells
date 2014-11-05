#pragma once

#include "../Utils/CellMacro.h"

NS_CELL_BEGIN

enum DOWNLOAD_STATE
{
	DOWNLOAD_STATE_INIT,
	DOWNLOAD_STATE_DOWNLOADING,
	DOWNLOAD_STATE_DOWNLOADING_FINISH,
	DOWNLOAD_STATE_ERROR
};

class DownloadWatcher
{
private:
	volatile double _now ;
	volatile double _total ;

	DOWNLOAD_STATE _state ;

public:
	DownloadWatcher() ;
	virtual ~DownloadWatcher() ;

	void setProgress(double now, double total) ;
	float getProgress() ;

	void setDownloadState(DOWNLOAD_STATE state) ;
	DOWNLOAD_STATE getDownloadState() ;
};

NS_CELL_END