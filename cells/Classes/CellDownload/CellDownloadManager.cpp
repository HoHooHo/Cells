/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellDownloadManager.h"
#include "Utils/DirUtil.h"

const float SCHEDULE_INTERVAL = 0.01f ;

CellDownloadManager::CellDownloadManager(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount)
{
	init(urlVector, srcRoot, desRoot, randomValue, workThreadCount) ;
}

CellDownloadManager::CellDownloadManager(const std::string& url, int urlCount, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount)
{
	std::vector<std::string> urlVector ;

	for (int i = 0; i < urlCount; i++)
	{
		urlVector.push_back(url) ;
	}

	init(urlVector, srcRoot, desRoot, randomValue, workThreadCount) ;
}

CellDownloadManager::~CellDownloadManager()
{
	cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(CellDownloadManager::scheduleUpdate), this) ;
	delete _workCenter ;
	delete _config ;
}

void CellDownloadManager::init(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount)
{
	_failedIdxFile = "" ;
	_observer = nullptr ;
	_errorObserver = nullptr ;
	_idxErrorObserver = nullptr ;
	_restartObserver = nullptr ;
	_forceUpdateObserver = nullptr ;
	_autoDownload = false ;
	_state = WORK_STATE_00_NONE ;
	_stateTag = WORK_STATE_00_NONE ;
	_bRet = 0 ;
	_nowCount = 0 ;
	_totalCount = 0 ;
	_nowSize = 0.0 ;
	_totalSize = 0.0 ;
	_restartKeyWord = "";

	NS_CELL::DirUtil::getInstance()->setRoot(srcRoot, desRoot);

	_config = new NS_CELL::DownloadConig(urlVector, srcRoot, desRoot, randomValue) ;
	_workCenter = new NS_CELL::CellWorkCenter(_config, workThreadCount) ;
	_workCenter->registerObserver(CELL_CHECK_OBSERVER_CREATER(CellDownloadManager::onChecking, this),
								  CELL_CHECK_OBSERVER_CREATER(CellDownloadManager::onAllCheckedFinish, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onDownloading, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onAllDownloadedFinish, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onDownloadError, this),
								  CELL_DOWNLOAD_IDX_ERR_OBSERVER_CREATER(CellDownloadManager::onDownloadIdxError, this),
								  CELL_FORCE_UPDATE_OBSERVER_CREATER(CellDownloadManager::onForceUpdate, this)
								) ;
	cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(CellDownloadManager::scheduleUpdate), this, SCHEDULE_INTERVAL, kRepeatForever, 0, false) ;
}

void CellDownloadManager::onForceUpdate(const std::string& newVersion)
{
	if (_forceUpdateObserver)
	{
		_forceUpdateObserver(newVersion) ;
	}
}

void CellDownloadManager::onChecking(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_02_CHECKING ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = nowSize ;
	//CELL_LOG("CellDownloadManager::onChecking   %d / %d", nowCount, totalCount) ;
}

void CellDownloadManager::onAllCheckedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_03_CHECK_FINISH ;
	if ( !cell )
	{
		return ;
	}
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = 0 ;
	_totalSize = totalSize ;

	//CELL_LOG("CellDownloadManager::onAllCheckedFinish   %d / %d", nowCount, totalCount) ;
}

void CellDownloadManager::onDownloading(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_05_DOWNLOADING ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = totalSize ;
	//CELL_LOG("CellDownloadManager::onDownloading   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;
	if (_restartKeyWord.size() > 0 && _restartObserver && _fileName.find(_restartKeyWord) != std::string::npos)
	{
		_restartObserver() ;
	}
}

void CellDownloadManager::onDownloadError(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_06_DOWNLOAD_ERROR ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = totalSize ;
	//CELL_LOG("CellDownloadManager::onDownloadError   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;

	_failedFiles.push_back(_fileName) ;
	/*if (_errorObserver)
	{
	_errorObserver(_fileName) ;
	}*/
}

void CellDownloadManager::onDownloadIdxError(const std::string& fileName)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_failedIdxFile = fileName ;

	/*if (_idxErrorObserver)
	{
	_idxErrorObserver(fileName) ;
	}*/
}

void CellDownloadManager::onAllDownloadedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_07_ALL_FINISH ;
	if ( !cell )
	{
		return ;
	}
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = totalSize ;
	cocos2d::FileUtils::getInstance()->purgeCachedEntries() ;
	//CELL_LOG("CellDownloadManager::onAllDownloadedFinish   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;
}

bool CellDownloadManager::ignoreObserver()
{
	bool ignore = false ;
	if( (_state == WORK_STATE_00_NONE || _state == WORK_STATE_01_READY_CHECK || _state == WORK_STATE_04_READY_DOWNLOAD || _state == WORK_STATE_08_WAIT) )
	{
		ignore = _stateTag == _state ;
		_stateTag = _state ;
	}

	return ignore ;
}

//通过主线程回调结果，由于子线程在不停更新，所以不是每个文件的结果都能产生回调
void CellDownloadManager::scheduleUpdate(float delta)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;

	if (!_failedIdxFile.empty() && _idxErrorObserver)
	{
		_idxErrorObserver(_failedIdxFile) ;
		return ;
	}

	if (_errorObserver)
	{
		for (std::string fileName : _failedFiles)
		{
			_errorObserver(fileName) ;
		}

		_failedFiles.clear() ;
	}

	bool ignore = ignoreObserver() ;
	if (_observer && !ignore)
	{
		_observer(_state, _fileName, _bRet, _nowCount, _totalCount, _nowSize, _totalSize) ;
	}

	if (_state == WORK_STATE_03_CHECK_FINISH)
	{
		_state = _totalSize > 0.0f ? WORK_STATE_04_READY_DOWNLOAD : WORK_STATE_08_WAIT ;
	}else if (_state == WORK_STATE_04_READY_DOWNLOAD && _autoDownload && !ignore)
	{
		//_state = WORK_STATE_04_DOWNLOADING ;
		postDownloadWork() ;
	}else if (_state == WORK_STATE_07_ALL_FINISH)
	{
		_state = WORK_STATE_08_WAIT ;
	}
}

void CellDownloadManager::registerObserver(const DownloadObserverFunctor& observer)
{
	_observer = observer ;
}

void CellDownloadManager::registerErrorObserver(const DownloadErrorObserverFunctor& observer)
{
	_errorObserver = observer ;
}

void CellDownloadManager::registerIdxErrorObserver(const DownloadErrorObserverFunctor& observer)
{
	_idxErrorObserver = observer ;
}

void CellDownloadManager::registerRestartObserver(const DownloadRestartObserverFunctor& observer)
{
	_restartObserver = observer ;
}

void CellDownloadManager::registerForceUpdateObserver(const DownloadForceUpdateObserverFunctor& observer)
{
	_forceUpdateObserver = observer ;
}

int CellDownloadManager::getWorkThreadCount()
{
	if (_workCenter)
	{
		return _workCenter->getWorkThreadCount() ;
	}

	return 0 ;
}

void CellDownloadManager::postWork(const char* fileName)
{
	_autoDownload = true ;
	postCheckWork(fileName) ;
}

void CellDownloadManager::postCheckWork(const char* fileName)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	if ( _state == WORK_STATE_00_NONE || _state == WORK_STATE_08_WAIT || _state == WORK_STATE_07_ALL_FINISH)
	{
		_state = WORK_STATE_01_READY_CHECK ;
	}
	_workCenter->postCheckWork(fileName, _state) ;
}

void CellDownloadManager::postDownloadWork()
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	assert(_state == WORK_STATE_04_READY_DOWNLOAD || _state == WORK_STATE_05_DOWNLOADING || _state == WORK_STATE_06_DOWNLOAD_ERROR) ;
	_workCenter->postDownloadWork(_state) ;
}