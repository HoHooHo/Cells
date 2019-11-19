/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellWorkerFactory.h"
#include "CellCheckWorker.h"
#include "CellDownloadWorker.h"
#include "../../MD5/QuickMD5.h"

NS_CELL_BEGIN
	
const int DEAULT_WORKER_NUM = 8 ;
const int SLEEP_DELTA = 100 ;
const int LOAD_BALANCE_PER = 5 ;
const int LOAD_BALANCE_COUNT = 3 ;

CellWorkerFactory::CellWorkerFactory(DownloadConig* config, int workerCount)
	:_workerCount(workerCount)
	,_config(config)
	,_dispatchThread(nullptr)
	,_running(false)
	,_checkObserver(nullptr)
	,_downloadObserver(nullptr)
{
	init() ;
	startThread() ;
}

CellWorkerFactory::~CellWorkerFactory()
{
	finishThread() ;

	for (auto worker : _checkWorkers)
	{
		delete worker ;
	}

	for (auto worker : _downloadWorkers)
	{
		delete worker ;
	}
	destroyCellQueue(_checkCells) ;
	destroyCellQueue(_downloadCells) ;

	destroyCellMap(_checkingCells) ;
	destroyCellMap(_downloadingCells) ;

	destroyCellQueue(_checkedCells) ;
	destroyCellQueue(_downloadedCells) ;

	destroyCellQueue(_checkErrorCells) ;
	destroyCellQueue(_downloadErrorCells) ;
}

void CellWorkerFactory::destroyCellQueue(CellQueue<Cell*>& cellQueue)
{
	/*while ( !cellQueue.empty() )
	{
		Cell* cell = cellQueue.pop() ;
		delete cell ;
	}*/
	cellQueue.clear() ;
}

void CellWorkerFactory::destroyCellMap(CellMap<std::string, Cell*>& cellMap)
{
	/*for(CellMap<std::string, Cell*>::iterator it = cellMap.begin(); it != cellMap.end();)
	{
		std::string s = it->first ;
		Cell* cell = it->second ;

		it = cellMap.erase(it) ;

		delete cell ;
	}*/
	cellMap.clear() ;
}

void CellWorkerFactory::init()
{
	QuickMD5::getInstance() ;
	for (int i = 0; i < _workerCount; i++)
	{
		CellCheckWorker* checkWork = new CellCheckWorker(_config) ;
		checkWork->registerObserver(CELL_OBSERVER_CREATER(CellWorkerFactory::onCheck, this)) ;
		_checkWorkers.push_back(checkWork) ;

		CellDownloadWorker* downloadWork = new CellDownloadWorker(_config) ;
		downloadWork->registerObserver(CELL_OBSERVER_CREATER(CellWorkerFactory::onDownload, this)) ;
		_downloadWorkers.push_back(downloadWork) ;
	}
}

void CellWorkerFactory::startThread()
{
	if (!_dispatchThread)
	{
		_running = true ;
		_dispatchThread = new std::thread(&CellWorkerFactory::tick, this) ;

		std::stringstream s ;
		s<<_dispatchThread->get_id() ;
		CELL_LOG(" ****    WorkerFactory thread : %s start    **** ", s.str().c_str()) ;
	}
}

void CellWorkerFactory::finishThread()
{
	if (_dispatchThread)
	{
		std::stringstream s ;
		s<<_dispatchThread->get_id() ;

		_running = false ;
		_dispatchThread->join() ;

		CELL_LOG(" ****    WorkerFactory thread : %s finish    **** ", s.str().c_str()) ;

		delete _dispatchThread ;
		_dispatchThread = nullptr ;
	}
}

void CellWorkerFactory::tick()
{
	while (_running)
	{
		dispatch() ;
		std::this_thread::sleep_for(std::chrono::milliseconds(SLEEP_DELTA)) ;
	}
}

void CellWorkerFactory::dispatch()
{
	dispatchResult() ;
	dispatchWork() ;
}

void CellWorkerFactory::dispatchResult()
{
	dispatchCheckResult() ;
	dispatchDownloadResult() ;
}

void CellWorkerFactory::dispatchCheckResult()
{
	while ( !_checkedCells.empty() )
	{
		if (_checkObserver)
		{
			_checkObserver(_checkedCells.pop(), true) ;
		}
	}

	while ( !_checkErrorCells.empty() )
	{
		if (_checkObserver)
		{
			_checkObserver(_checkErrorCells.pop(), false) ;
		}
	}
}

void CellWorkerFactory::dispatchDownloadResult()
{
	while ( !_downloadedCells.empty() )
	{
		if (_downloadObserver)
		{
			_downloadObserver(_downloadedCells.pop(), true) ;
		}
	}
	while ( !_downloadErrorCells.empty() )
	{
		if (_downloadObserver)
		{
			_downloadObserver(_downloadErrorCells.pop(), false) ;
		}
	}
}

void CellWorkerFactory::dispatchWork()
{
	dispatchCheckWork() ;
	dispatchDownloadWork() ;
}

void CellWorkerFactory::dispatchCheckWork()
{
	loadBalanceDispatch(LOAD_BALANCE_COUNT, LOAD_BALANCE_PER, _checkWorkers, _checkCells, _checkingCells) ;
}

void CellWorkerFactory::dispatchDownloadWork()
{
	loadBalanceDispatch(LOAD_BALANCE_COUNT, LOAD_BALANCE_PER, _downloadWorkers, _downloadCells, _downloadingCells) ;
}

void CellWorkerFactory::onFinish(Cell* cell, bool bRet, 
								 CellMap<std::string, Cell*>& srcCells,
								 CellQueue<Cell*>& okDesCells, 
								 CellQueue<Cell*>& errorDesCells)
{
	srcCells.erase(cell->getName()) ;
	if (bRet)
	{
		okDesCells.push(cell) ;
	} 
	else
	{
		errorDesCells.push(cell) ;
	}
}

void CellWorkerFactory::onCheck(Cell* cell, bool bRet)
{
	//CELL_LOG("*** CellWorkerFactory::onCheck ***  %s",cell->getName().c_str()) ;

	onFinish(cell, bRet, _checkingCells, _checkedCells, _checkErrorCells) ;
}

void CellWorkerFactory::onDownload(Cell* cell, bool bRet)
{
	//CELL_LOG("*** CellWorkerFactory::onDownload ***  %s",cell->getName().c_str()) ;

	onFinish(cell, bRet, _downloadingCells, _downloadedCells, _downloadErrorCells) ;
}


void CellWorkerFactory::loadBalanceDispatch(int count, int per, std::vector<CellWorker*>& works, 
											CellQueue<Cell*>& srcCells, 
											CellMap<std::string, Cell*>& desCells)
{
	for (int i = 0; i < count; i++)
	{
		for (size_t j = 0; j < works.size(); j++)
		{
			CellWorker* work = works[j] ;
			for (size_t k = work->workLoad(); k < (i + 1) * per; k++)
			{
				if ( srcCells.empty() )
				{
					return ;
				}
				Cell* cell = srcCells.pop() ;
				desCells.insert(cell->getName(), cell) ;
				work->postWork(cell) ;
			}
		}
	}
}

void CellWorkerFactory::registerCheckObserver(const CellObserverFunctor& checkObserver)
{
	_checkObserver = checkObserver ;
}

void CellWorkerFactory::registerDownloadObserver(const CellObserverFunctor& downloadObserver)
{
	_downloadObserver = downloadObserver ;
}

void CellWorkerFactory::registerObserver(const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver)
{
	registerCheckObserver(checkObserver) ;
	registerDownloadObserver(downloadObserver) ;
}

void CellWorkerFactory::postCheckWork(Cell* cell)
{
	_checkCells.push(cell) ;
}

void CellWorkerFactory::postDownloadWork(Cell* cell)
{
	_downloadCells.push(cell) ;
}

NS_CELL_END