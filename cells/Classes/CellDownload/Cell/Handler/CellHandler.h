/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include <functional>
#include <vector>
#include "../Cell/Cell.h"
#include "../../Utils/CellMacro.h"
#include "../../Download/DownloadConig.h"
#include "../CellWorker/CellWorkerFactory.h"

NS_CELL_BEGIN

class CellHandler
{
private:
	DownloadConig* _config ;
	CellWorkerFactory* _factory ;

private:
	CellQueue<Cell*> _postCellsQueue ; 
	CellMap<std::string, Cell*> _cellsMap ; 
	int _cellTotalCount ;

private:
	CellForceUpdateObserverFunctor _forceUpdateObserver ;
	CellObserverFunctor _checkObserver ;
	CellObserverFunctor _downloadObserver ;

private:
	std::string parse(DownloadConig* config, const char* fileName) ;

private:
	void onCheck(Cell* cell, bool bRet) ;
	void onDownload(Cell* cell, bool bRet) ;

public:
	CellHandler(DownloadConig* config, int workThreadCount) ;
	virtual ~CellHandler() ;

	void registerForceUpdateObserver(const CellForceUpdateObserverFunctor& forceUpdateObserver) ;
	void registerCheckObserver(const CellObserverFunctor& checkObserver) ;
	void registerDownloadObserver(const CellObserverFunctor& downloadObserver) ;
	void registerObserver(const CellForceUpdateObserverFunctor& forceUpdateObserver, const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver) ;

	void postCheckWork(DownloadConig* config, const char* fileName) ;
	void postDownloadWork(CellQueue<Cell*>& newCells) ;

	inline int getCellsTotalCount() { return _cellTotalCount ; } ;
};

NS_CELL_END