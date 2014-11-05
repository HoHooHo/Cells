#pragma once

#include <stdio.h>
#include <thread>
#include <mutex>
#include <future>

#include "../Cell/Cell.h"
#include "../../Download/DownloadConig.h"
#include "../../Utils/CellMacro.h"
#include "../Cell/CellContainer.h"

NS_CELL_BEGIN

class CellWorker
{
public:
	CellWorker(DownloadConig* config) ;
	virtual ~CellWorker() ;

private:
	CellQueue<Cell*> _cells ;
	CellObserverFunctor _workObserver ;

private:
	bool _working ;
	std::thread* _workThread ;

	std::mutex _waitMutex ;
	std::condition_variable _waitCondition ;

protected:
	void create() ;
	void destroy() ;

private:
	void startThread() ;
	void finishThread() ;

	void workThread() ;

	void startWork() ;
	void finishWork(Cell* cell, bool bRet) ;

protected:
	DownloadConig* _config ;

	virtual bool doWork(Cell* cell) ;

public:
	void registerObserver(const CellObserverFunctor& workObserver) ;
	void postWork(Cell* cell) ;
	size_t workLoad() ;
};

NS_CELL_END