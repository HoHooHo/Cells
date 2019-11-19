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
#include <thread>

NS_CELL_BEGIN

class CellWorkerFactory
{
private:
	std::vector<CellWorker*> _checkWorkers ;
	std::vector<CellWorker*> _downloadWorkers ;
	int _workerCount ;

	DownloadConig* _config ;

private:
	CellObserverFunctor _checkObserver ;
	CellObserverFunctor _downloadObserver ;

private:
	CellQueue<Cell*> _checkCells ;
	CellQueue<Cell*> _downloadCells ;

	CellMap<std::string, Cell*> _checkingCells ;
	CellMap<std::string, Cell*> _downloadingCells ;

	CellQueue<Cell*> _checkedCells ;
	CellQueue<Cell*> _downloadedCells ;

	CellQueue<Cell*> _checkErrorCells ;
	CellQueue<Cell*> _downloadErrorCells ;

private:
	std::thread* _dispatchThread ;
	bool _running ;

private:
	void destroyCellQueue(CellQueue<Cell*>& cellQueue) ;
	void destroyCellMap(CellMap<std::string, Cell*>& cellMap) ;

private:
	void startThread() ;
	void finishThread() ;

	void tick() ;
	void dispatch() ;

	void dispatchResult() ;
	void dispatchCheckResult() ;
	void dispatchDownloadResult() ;

	void dispatchWork() ;
	void dispatchCheckWork() ;
	void dispatchDownloadWork() ;

private:
	void onFinish(Cell* cell, bool bRet, 
				CellMap<std::string, Cell*>& srcCells,
				CellQueue<Cell*>& okDesCells, 
				CellQueue<Cell*>& errorDesCells) ;

	void onCheck(Cell* cell, bool bRet) ;
	void onDownload(Cell* cell, bool bRet) ;

private:
	void loadBalanceDispatch(int count, int per, std::vector<CellWorker*>& works, 
							CellQueue<Cell*>& srcCells, 
							CellMap<std::string, Cell*>& desCells) ;

public:
	CellWorkerFactory(DownloadConig* config, int workerCount) ;
	virtual ~CellWorkerFactory() ;

	void registerCheckObserver(const CellObserverFunctor& checkObserver) ;
	void registerDownloadObserver(const CellObserverFunctor& downloadObserver) ;
	void registerObserver(const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver) ;

	void postCheckWork(Cell* cell) ;
	void postDownloadWork(Cell* cell) ;

private:
	void init() ;
};

NS_CELL_END