#include "CellDownloadManager.h"

const float SCHEDULE_INTERVAL = 0.25 ;

CellDownloadManager::CellDownloadManager(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, int workThreadCount)
{
	init(urlVector, srcRoot, desRoot, workThreadCount) ;
}

CellDownloadManager::CellDownloadManager(const std::string& url, int urlCount, const std::string& srcRoot, const std::string& desRoot, int workThreadCount)
{
	std::vector<std::string> urlVector ;

	for (int i = 0; i < urlCount; i++)
	{
		urlVector.push_back(url) ;
	}

	init(urlVector, srcRoot, desRoot, workThreadCount) ;
}

CellDownloadManager::~CellDownloadManager()
{
	cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(CellDownloadManager::scheduleUpdate), this) ;
	delete _workCenter ;
	delete _config ;
}

void CellDownloadManager::init(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, int workThreadCount)
{
	_observer = nullptr ;
	_autoDownload = false ;
	_state = WORK_STATE_00_READY_CHECK ;
	_bRet = 0 ;
	_nowCount = 0 ;
	_totalCount = 0 ;
	_nowSize = 0.0 ;
	_totalSize = 0.0 ;
	_config = new NS_CELL::DownloadConig(urlVector, srcRoot, desRoot) ;
	_workCenter = new NS_CELL::CellWorkCenter(_config, workThreadCount) ;
	_workCenter->registerObserver(CELL_CHECK_OBSERVER_CREATER(CellDownloadManager::onChecking, this),
								  CELL_CHECK_OBSERVER_CREATER(CellDownloadManager::onAllCheckedFinish, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onDownloading, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onAllDownloadedFinish, this),
								  CELL_DOWNLOAD_OBSERVER_CREATER(CellDownloadManager::onDownloadError, this)
								) ;
	cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(CellDownloadManager::scheduleUpdate), this, SCHEDULE_INTERVAL, kRepeatForever, 0, false) ;
}

void CellDownloadManager::onChecking(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_01_CHECKING ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = 0 ;
	_totalSize = 0 ;
	//CELL_LOG("CellDownloadManager::onChecking   %d / %d", nowCount, totalCount) ;
}

void CellDownloadManager::onAllCheckedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_02_CHECK_FINISH ;
	if ( !cell )
	{
		return ;
	}
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = 0 ;
	_totalSize = 0 ;

	//CELL_LOG("CellDownloadManager::onAllCheckedFinish   %d / %d", nowCount, totalCount) ;
}

void CellDownloadManager::onDownloading(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_04_DOWNLOADING ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = totalSize ;
	//CELL_LOG("CellDownloadManager::onDownloading   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;
}

void CellDownloadManager::onDownloadError(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_05_DOWNLOAD_ERROR ;
	_fileName = cell->getName() ;
	_bRet = bRet ;
	_nowCount = nowCount ;
	_totalCount = totalCount ;
	_nowSize = nowSize ;
	_totalSize = totalSize ;
	//CELL_LOG("CellDownloadManager::onDownloadError   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;
}

void CellDownloadManager::onAllDownloadedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	_state = WORK_STATE_06_ALL_FINISH ;
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
	//CELL_LOG("CellDownloadManager::onAllDownloadedFinish   %d / %d    %lf.2 / %lf.2", nowCount, totalCount, nowSize, totalSize) ;
}

void CellDownloadManager::scheduleUpdate(float delta)
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	if (_observer && ( _state != WORK_STATE_00_READY_CHECK && _state != WORK_STATE_03_READY_DOWNLOAD && _state != WORK_STATE_07_WAIT) )
	{
		_observer(_state, _fileName, _bRet, _nowCount, _totalCount, _nowSize, _totalSize) ;
	}

	if (_state == WORK_STATE_02_CHECK_FINISH)
	{
		_state = WORK_STATE_03_READY_DOWNLOAD ;
	}else if (_state == WORK_STATE_03_READY_DOWNLOAD && _autoDownload)
	{
		postDownloadWork() ;
	}else if (_state == WORK_STATE_06_ALL_FINISH)
	{
		_state = WORK_STATE_07_WAIT ;
	}
}

void CellDownloadManager::registerObserver(const DownloadObserverFunctor& observer)
{
	_observer = observer ;
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
	if (_state == WORK_STATE_07_WAIT || _state == WORK_STATE_06_ALL_FINISH)
	{
		_state = WORK_STATE_00_READY_CHECK ;
	}
	_workCenter->postCheckWork(fileName, _state) ;
}

void CellDownloadManager::postDownloadWork()
{
	std::unique_lock<std::recursive_mutex> lock(_stateMutex) ;
	assert( (_state == WORK_STATE_03_READY_DOWNLOAD || _state == WORK_STATE_04_DOWNLOADING || _state == WORK_STATE_05_DOWNLOAD_ERROR), "STATE ERROR: please post check work!") ;
	_workCenter->postDownloadWork(_state) ;
}