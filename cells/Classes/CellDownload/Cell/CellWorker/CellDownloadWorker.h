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
	void finishDownload(Cell* cell) ;

	bool needBrokenResume(Cell* cell) ;

protected:
	virtual bool doWork(Cell* cell) ;
};

NS_CELL_END