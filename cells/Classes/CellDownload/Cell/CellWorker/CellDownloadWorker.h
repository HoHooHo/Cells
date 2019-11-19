/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once

#include "../../Utils/CellMacro.h"
#include "CellWorker.h"
#include "../../Download/DownloadWatcher.h"
#include "../../Download/Downloader.h"

NS_CELL_BEGIN

class CellDownloadWorker : public CellWorker
{
private:
	FILE* _fp ;
	std::string _desFileName ;
	std::string _desFileNameTemp ;

private:
	Downloader* _dowloader ;
	//DownloadWatcher* _watcher ;

	std::mutex _createDirMutex ;

public:
	CellDownloadWorker(DownloadConig* config) ;
	virtual ~CellDownloadWorker() ;

private:
	void saveMD5File(const char* file, std::string md5) ;
	void removeMD5File(const char* file) ;

	void startDownload(Cell* cell, bool brokenResume) ;
	void finishDownload(Cell* cell, bool result) ;

	bool needBrokenResume(Cell* cell) ;

protected:
	virtual bool doWork(Cell* cell) ;
};

NS_CELL_END