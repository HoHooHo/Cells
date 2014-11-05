#include "CellDownloadWorker.h"
#include "../../Utils/DirUtil.h"

NS_CELL_BEGIN

CellDownloadWorker::CellDownloadWorker(DownloadConig* config)
	:CellWorker(config)
	,_fp(nullptr)
	,_dowloader(nullptr)
{
	_dowloader = new Downloader() ;

	create() ;
}

CellDownloadWorker::~CellDownloadWorker()
{
	destroy() ;

	delete _dowloader ;

	if (_fp)
	{
		fclose(_fp) ;
	}
}

bool CellDownloadWorker::doWork(Cell* cell)
{
	bool bRet = false ;
	if (cell)
	{
		int times = 0 ;
		for ( auto url : _config->getURL() )
		{
			if (times++ > 0)
			{
				CELL_LOG("***   Retry Donwload: Times = %d  File = %s   ***", times, cell->getName().c_str()) ;
			}

			bool brokenResume = needBrokenResume(cell) ;

			startDownload(cell, brokenResume) ;

			std::string fitlURL = url + cell->getName() ;

			bRet = _dowloader->download(fitlURL.c_str(), _fp, brokenResume) ;

			finishDownload(cell) ;

			if (bRet)
			{
				break ;
			}
		}
	}

	return bRet ;
}

void CellDownloadWorker::saveMD5File(const char* file, std::string md5)
{
	if ( !md5.empty() )
	{
		FILE* fp = fopen(file, "w+") ;
		if (fp)
		{
			fprintf(fp, "%s", md5.c_str()) ;
		}

		fclose(fp) ;
	}
}

void CellDownloadWorker::removeMD5File(const char* file)
{
	DirUtil::getInstance()->removeFile(file) ;
}

void CellDownloadWorker::startDownload(Cell* cell, bool brokenResume)
{
	std::string name = cell->getName() ;
	std::string md5Name = cell->getMD5Name() ;

	std::string desRoot = _config->getDesRoot() ;

	std::string file = desRoot + name ;
	std::string md5File = desRoot + md5Name ;

	_createDirMutex.lock() ;
	DirUtil::getInstance()->createDirByFileName(file) ;
	_createDirMutex.unlock() ;

	if ( !brokenResume )
	{
		saveMD5File(md5File.c_str(), cell->getMD5()) ;
	}

	_fp = brokenResume ?
		fopen(file.c_str(), "ab+") :
		fopen(file.c_str(), "wb+") ;
}

void CellDownloadWorker::finishDownload(Cell* cell)
{
	fclose(_fp) ;
	_fp = nullptr ;

	std::string md5Name = cell->getMD5Name() ;
	std::string desRoot = _config->getDesRoot() ;
	std::string md5File = desRoot + md5Name ;

	removeMD5File(md5File.c_str()) ;
}


bool CellDownloadWorker::needBrokenResume(Cell* cell)
{
	bool brokenResume = false ;
	std::string md5Name = cell->getMD5Name() ;
	std::string desRoot = _config->getDesRoot() ;

	std::string md5File = desRoot + md5Name ;
	if (DirUtil::getInstance()->isFileExist(md5File.c_str()))
	{
		std::string brokenMD5 = DirUtil::getInstance()->getStringFromFile(md5File.c_str()) ;
		if (cell->getMD5().compare(brokenMD5) == 0)
		{
			brokenResume = true ;
		}
	}

	return brokenResume ;
}


NS_CELL_END