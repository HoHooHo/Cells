/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellDownloadWorker.h"
#include "../../Utils/DirUtil.h"
#include "../../MD5/QuickMD5.h"

NS_CELL_BEGIN

CellDownloadWorker::CellDownloadWorker(DownloadConig* config)
	:CellWorker(config)
	,_fp(nullptr)
	,_desFileName("")
	,_dowloader(nullptr)
{
	_dowloader = new Downloader(5L, 60L) ;

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

			std::string cellName = cell->getName() ;

			std::string fileURL = url + cellName + "?md5=" + cell->getMD5() ;


			bRet = _dowloader->download(fileURL.c_str(), _fp, brokenResume) ;

			finishDownload(cell, bRet) ;

			//bRet = bRet && (cell->getMD5().compare(QuickMD5::getInstance()->MD5File(_desFileName.c_str())) == 0) ;

			if (bRet)
			{
				std::string dir = DirUtil::getInstance()->getDirByFileName(_desFileName) ;
				std::string fileName = DirUtil::getInstance()->getNameByFileName(_desFileName) ;
				std::string tempFileName = DirUtil::getInstance()->getNameByFileName(_desFileNameTemp) ;
				bRet = cell->getMD5().compare(QuickMD5::getInstance()->MD5File(_desFileNameTemp.c_str())) == 0 ;
				if (bRet)
				{
					DirUtil::getInstance()->renameFile(dir, tempFileName, fileName) ;
				}else
				{
					CELL_LOG("***   MD5 Faile    ***") ;
				}


				if ( bRet && cellName.substr(cellName.size() - 4) == ".zip" )
				{
					bRet = DirUtil::getInstance()->decompress(_desFileName) ;
					if (!bRet)
					{
						DirUtil::getInstance()->removeFile(_desFileName) ;
					}
				}
			}


			if (bRet)
			{
				break ;
			}else
			{
				_dowloader->reset() ;
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

	_desFileName = desRoot + name ;
	_desFileNameTemp = _desFileName + TEMP_SUFFIX ;

	std::string md5File = desRoot + md5Name ;

	_createDirMutex.lock() ;
	DirUtil::getInstance()->createDirByFileName(_desFileName) ;
	_createDirMutex.unlock() ;

	if ( !brokenResume )
	{
		saveMD5File(md5File.c_str(), cell->getMD5()) ;
	}

	_fp = brokenResume ?
		fopen(_desFileNameTemp.c_str(), "ab+") :
		fopen(_desFileNameTemp.c_str(), "wb+") ;
}

void CellDownloadWorker::finishDownload(Cell* cell, bool result)
{
	fclose(_fp) ;
	_fp = nullptr ;

	if (result)
	{

		std::string md5Name = cell->getMD5Name() ;
		std::string desRoot = _config->getDesRoot() ;
		std::string md5File = desRoot + md5Name ;

		removeMD5File(md5File.c_str()) ;
	}
}


bool CellDownloadWorker::needBrokenResume(Cell* cell)
{
	bool brokenResume = false ;
	std::string md5Name = cell->getMD5Name() ;
	std::string desRoot = _config->getDesRoot() ;

	std::string md5File = desRoot + md5Name ;
	std::string tempFile = desRoot + cell->getName() + TEMP_SUFFIX
	if (DirUtil::getInstance()->isFileExist(md5File.c_str(), true) && DirUtil::getInstance()->isFileExist(tempFile.c_str(), true))
	{
		std::string brokenMD5 = DirUtil::getInstance()->getStringFromFile(md5File.c_str()) ;

		if (cell->getMD5().compare(brokenMD5) == 0 && cocos2d::FileUtils::getInstance()->getFileSize(tempFile) < cell->getSize() )
		{
			brokenResume = true ;
		}
	}

	return brokenResume ;
}


NS_CELL_END