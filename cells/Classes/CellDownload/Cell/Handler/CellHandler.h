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
	CellQueue<Cell*> _cellsQueue ; 
	int _cellTotalCount ;

private:
	CellObserverFunctor _checkObserver ;
	CellObserverFunctor _downloadObserver ;

private:
	void parse(const char* filePath, const char* fileName) ;

private:
	void onCheck(Cell* cell, bool bRet) ;
	void onDownload(Cell* cell, bool bRet) ;

public:
	CellHandler(DownloadConig* config, int workThreadCount) ;
	virtual ~CellHandler() ;

	void registerCheckObserver(const CellObserverFunctor& checkObserver) ;
	void registerDownloadObserver(const CellObserverFunctor& downloadObserver) ;
	void registerObserver(const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver) ;

	void postCheckWork(const char* filePath, const char* fileName) ;
	void postDownloadWork(CellQueue<Cell*>& newCells) ;

	inline int getCellsTotalCount() { return _cellTotalCount ; } ;
};

NS_CELL_END