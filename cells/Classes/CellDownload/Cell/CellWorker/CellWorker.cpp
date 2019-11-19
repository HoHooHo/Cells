/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellWorker.h"

NS_CELL_BEGIN

CellWorker::CellWorker(DownloadConig* config)
	:_working(false)
	,_workThread(nullptr)
	,_config(config)
	,_workObserver(nullptr)
{
}

CellWorker::~CellWorker()
{
}

void CellWorker::startThread()
{
	if (!_workThread)
	{
		_working = true ;
		_workThread = new std::thread(&CellWorker::workThread, this) ;

		std::stringstream s ;
		s<<_workThread->get_id() ;
		CELL_LOG(" ****    work thread : %s start    **** ", s.str().c_str()) ;
	}
}

void CellWorker::finishThread()
{
	if (_workThread)
	{
		std::stringstream s ;
		s<<_workThread->get_id() ;

		_working = false ;
		startWork() ;
		_workThread->join() ;

		CELL_LOG(" ****    work thread : %s finish    **** ", s.str().c_str()) ;

		delete _workThread ;

		_workThread = nullptr ;
	}
}

void CellWorker::create()
{
	startThread() ;
}

void CellWorker::destroy()
{
	finishThread() ;

	_cells.clear() ;
}

void CellWorker::workThread()
{
	while(true)
	{
		while ( _working && _cells.empty() )
		{
			std::unique_lock<std::mutex> lk(_waitMutex) ;
			_waitCondition.wait(lk) ;
		}

		if ( !_working )
		{
			break ;
		}


		Cell* cell = _cells.pop() ;
		bool bRet = doWork(cell) ;
		finishWork(cell, bRet) ;
	}
}

bool CellWorker::doWork(Cell* cell)
{
	CELL_LOG("**** CellWorker::doWork ****") ;
	return false ;
}

void CellWorker::startWork()
{
	_waitCondition.notify_one() ;
}

void CellWorker::finishWork(Cell* cell, bool bRet)
{
	//CELL_LOG("**** CellWorker::finishWork ****") ;
	if (_workObserver)
	{
		_workObserver(cell, bRet) ;
	}
}

void CellWorker::registerObserver(const CellObserverFunctor& workObserver)
{
	_workObserver = workObserver ;
}

void CellWorker::postWork(Cell* cell)
{
	_cells.push(cell) ;
	startWork() ;
}

size_t CellWorker::workLoad()
{
	return _cells.size() ;
}

NS_CELL_END