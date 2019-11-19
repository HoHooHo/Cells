/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellWorkCenter.h"
#include <thread>
#include "../Utils/DirUtil.h"

NS_CELL_BEGIN

CellWorkCenter::CellWorkCenter(DownloadConig* config, int workThreadCount)
	:_config(config)
	,_workThreadCount(workThreadCount)
	,_cellHandler(nullptr)
	,_dowloader(nullptr)
	,_fp(nullptr)
	,_checkedCount(0)
	,_newNowCount(0)
	,_newTotalCount(0)
	,_newNowSize(0.0)
	,_newTotalSize(0.0)
	,_checkingObserver(nullptr)
	,_allCheckedObserver(nullptr)
	,_downloadingObserver(nullptr)
	,_allDownloadedObserver(nullptr)
	,_downloadErrorObserver(nullptr)
	,_downloadXMLErrorObserver(nullptr)
	,_forceUpdateObserver(nullptr)
{
	_dowloader = new Downloader() ;
}

CellWorkCenter::~CellWorkCenter()
{
	_downloadCells.clear() ;
	_downloadedErrorCells.clear() ;
	_checkedOkCells.clear() ;
	_downloadedOkCells.clear() ;

	unInitHandler() ;

	delete _dowloader ;

	_fileNames.clear() ;

	if (_fp)
	{
		fclose(_fp) ;
	}
}

void CellWorkCenter::onCheck(Cell* cell, bool bRet)
{
	//CELL_LOG("***   CellWorkCenter::onCheck   ***") ;

	if (_cellHandler->getCellsTotalCount() == 0)
	{
		onCheckFinish(nullptr, false, 0, 0) ;
		return;
	}

	_checkedCount++ ;
	//CELL_LOG("%d / %d", _checkedCount , _cellHandler->getCellsTotalCount() ) ;

	if ( bRet )
	{
		_downloadCells.push(cell) ;
		_newTotalSize += cell->getSize() ;
		_newTotalCount++ ;

		++_downloadCount[cell->getXMLName()] ;
	}else
	{
		_checkedOkCells.push(cell) ;
	}

	if (_checkingObserver)
	{
		_checkingObserver(cell, bRet, _checkedCount, _cellHandler->getCellsTotalCount(), _newTotalSize) ;
	}

	if (_checkedCount == _cellHandler->getCellsTotalCount())
	{
		onCheckFinish(cell, bRet, _checkedCount, _cellHandler->getCellsTotalCount()) ;
	}
}

void CellWorkCenter::onCheckFinish(Cell* cell, bool bRet, int nowCount, int totalCount)
{
	CELL_LOG("*** check finish  ***") ;
	if (cell)
	{
		renameHash(cell->getXMLName(), _downloadCount[cell->getXMLName()]) ;
	}

	if (_fileNames.empty())
	{
		if (_allCheckedObserver)
		{
			_allCheckedObserver(cell, bRet, nowCount, totalCount, _newTotalSize) ;
		}
	}else
	{
		doWork(_fileNames.pop()) ;
	}
}

void CellWorkCenter::onDownload(Cell* cell, bool bRet)
{
	//CELL_LOG("***   CellWorkCenter::onDownload   ***") ;
	_newNowCount++ ;
	_newNowSize += cell->getSize() ;

	//CELL_LOG("%lf.2 / %lf.2", _newNowSize , _newTotalSize ) ;
	//CELL_LOG("%d/ %d", _newNowCount , _newTotalCount ) ;

	if ( bRet )
	{
		_downloadedOkCells.push(cell) ;

		if (_downloadingObserver)
		{
			_downloadingObserver(cell, bRet, _newNowCount, _newTotalCount, _newNowSize, _newTotalSize) ;
		}

		if (renameHash(cell->getXMLName(), --_downloadCount[cell->getXMLName()]))
		{
			_downloadCount.erase(cell->getXMLName()) ;
		}
	}else
	{
		CELL_LOG("*****   DOWNLOAD ERROR: %s -- %s   *****", cell->getXMLName().c_str(), cell->getName().c_str()) ;
		_downloadedErrorCells.push(cell) ;

		if (_downloadErrorObserver)
		{
			_downloadErrorObserver(cell, bRet, _newNowCount, _newTotalCount, _newNowSize, _newTotalSize) ;
		}
	}

	if (_newNowCount == _newTotalCount && _newNowSize == _newTotalSize)
	{
		onDownloadFinish(cell, bRet, _newNowCount, _newTotalCount, _newNowSize, _newTotalSize) ;
	}
}

void CellWorkCenter::onDownloadFinish(Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	CELL_LOG("*** download finish  ***") ;

	if (_fileNames.empty())
	{
		if (_allDownloadedObserver)
		{
			_allDownloadedObserver(cell, bRet, nowCount, totalCount, nowSize, totalSize) ;
		}
		renameAllHash() ;
	}else
	{
		doWork(_fileNames.pop()) ;
	}
}

void CellWorkCenter::initHandler()
{
	if ( !_cellHandler )
	{
		_cellHandler = new CellHandler(_config, _workThreadCount) ;
		_cellHandler->registerObserver( _forceUpdateObserver, CELL_OBSERVER_CREATER( CellWorkCenter::onCheck, this ), CELL_OBSERVER_CREATER( CellWorkCenter::onDownload, this ) ) ;
	}
}

void CellWorkCenter::unInitHandler()
{
	if (_cellHandler)
	{
		delete _cellHandler ;
		_cellHandler = nullptr ;
	}
}

bool CellWorkCenter::download(const std::string& file, const std::string& fileName)
{
	int times = 0 ;
	bool bRet = false ;
	for ( auto url : _config->getURL() )
	{
		if (times++ > 0)
		{
			CELL_LOG("***   Retry Donwload: Times = %d  File = %s   ***", times, fileName.c_str()) ;
		}

		startDownload(file) ;

		std::string fileURL = url + fileName + _config->getRandom() ;

		bRet = _dowloader->download(fileURL.c_str(), _fp, false) ;

		finishDownload(file) ;

		if (bRet)
		{
			_config->urlOpt(url) ;
			break ;
		}
	}

	return bRet ;
}

void CellWorkCenter::startDownload(const std::string& file)
{
	DirUtil::getInstance()->createDirByFileName(file) ;
	_fp = fopen(file.c_str(), "wb+") ;
}

void CellWorkCenter::finishDownload(const std::string& file)
{
	fclose(_fp) ;
	_fp = nullptr ;
}

bool CellWorkCenter::checkHashFile(const std::string& fileName)
{
	std::string desRoot = _config->getDesRoot() ;
	std::string hashFileName = fileName + MD5_SUFFIX ;
	std::string hashFile = desRoot + hashFileName ;
	std::string hashTempFile = hashFile + TEMP_SUFFIX ;

	bool update = true ;
	bool bRet = download(hashTempFile, hashFileName) ;
	if (bRet)
	{
		std::string hashFileStr = DirUtil::getInstance()->getStringFromFile(hashFile.c_str()) ;
		std::string hashFileTempStr = DirUtil::getInstance()->getStringFromFile(hashTempFile.c_str()) ;

		update = hashFileStr.compare(hashFileTempStr) != 0 ;
	}

	return update ;
}

bool CellWorkCenter::renameHash(const std::string& xmlName, int count)
{
	bool bRet = false ;
	if ( count == 0 )
	{
		std::string desRoot = _config->getDesRoot() ;
		std::string hashFileName = xmlName + MD5_SUFFIX ;
//		std::string hashFile = desRoot + hashFileName ;
		std::string hashTempFileName = hashFileName + TEMP_SUFFIX ;
		std::string tempFileName = xmlName + TEMP_SUFFIX ;

		if (DirUtil::getInstance()->isFileExist((desRoot + hashTempFileName).c_str()))
		{
			DirUtil::getInstance()->renameFile(desRoot, hashTempFileName, hashFileName) ;
			DirUtil::getInstance()->renameFile(desRoot, tempFileName, xmlName) ;
			bRet = true ;
		}
	}

	return bRet ;
}

void CellWorkCenter::renameAllHash()
{
	for (std::unordered_map<std::string, int>::iterator it = _downloadCount.begin(); it != _downloadCount.end(); ++it)
	{
		renameHash(it->first, it->second) ;
	}
}

void CellWorkCenter::doWork(const std::string& fileName)
{
	bool update = checkHashFile(fileName) ;

	if (update)
	{
		std::string desRoot = _config->getDesRoot() ;
		/*
		std::string basename = fileName ;

		size_t found = fileName.find_last_of(".");

		if (std::string::npos != found)
		{
			basename = fileName.substr(0, found);
		}

		std::string zipname = basename + ".zip" ;
		std::string zipfile = desRoot + zipname ;
		*/

		std::string file = desRoot + fileName ;
		std::string tempFile = file + TEMP_SUFFIX ;

		_downloadCount.insert(std::make_pair(fileName, 0)) ;

		//bool bRet = download(zipfile, zipname) ;
		//bRet = bRet && DirUtil::getInstance()->decompress(zipfile) ;

		//if (!bRet)
		//{
			bool bRet = download(tempFile, fileName) ;
		//}

		if (bRet)
		{
			initHandler() ;
			_cellHandler->postCheckWork(_config, fileName.c_str()) ;
		}else
		{
			if (_downloadXMLErrorObserver)
			{
				_downloadXMLErrorObserver(fileName) ;
			}
		}
	}else
	{
		CELL_LOG(" check finish & have not update! ") ;

		this->onCheckFinish(nullptr, false, 0, 0) ;
	}
}

void CellWorkCenter::registerObserver(const CellCheckObserverFunctor& checkingObserver, 
									  const CellCheckObserverFunctor& allCheckedObserver, 
									  const CellDownloadObserverFunctor& downloadingObserver, 
									  const CellDownloadObserverFunctor& allDownloadedObserver, 
									  const CellDownloadObserverFunctor& downloadErrorObserver, 
									  const DownloadErrorObserverFunctor& downloadXMLErrorObserver,
									  const DownloadForceUpdateObserverFunctor& forceUpdateObserver
									  )
{
	_checkingObserver = checkingObserver ;
	_allCheckedObserver = allCheckedObserver ;

	_downloadingObserver = downloadingObserver ;
	_allDownloadedObserver = allDownloadedObserver ;
	_downloadErrorObserver = downloadErrorObserver ;
	_downloadXMLErrorObserver = downloadXMLErrorObserver ;

	_forceUpdateObserver = forceUpdateObserver ;
}

int CellWorkCenter::getWorkThreadCount()
{
	if (_cellHandler)
	{
		return _workThreadCount ;
	}

	return 0 ;
}

void CellWorkCenter::postCheckWork(const char* fileName, WORK_STATE workState)
{
	_fileNames.push(fileName) ;
	if (workState == WORK_STATE_01_READY_CHECK || workState == WORK_STATE_03_CHECK_FINISH || workState == WORK_STATE_04_READY_DOWNLOAD)
	{
		doWork(_fileNames.pop()) ;
	}
}

void CellWorkCenter::postDownloadWork(WORK_STATE workState)
{
	CELL_LOG("***  file_count: %d  ***  file_size: %lf  ***", _newTotalCount , _newTotalSize ) ;
	if (workState == WORK_STATE_04_READY_DOWNLOAD && _downloadCells.empty())
	{
		this->onDownloadFinish(nullptr, true, 0, 0, 0, 0) ;
	}else 
	{
		_cellHandler->postDownloadWork(_downloadCells) ;
	}
}

NS_CELL_END