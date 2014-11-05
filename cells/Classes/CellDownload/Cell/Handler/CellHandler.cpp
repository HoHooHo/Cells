#include "CellHandler.h"
#include <thread>
#include "../Cell/CellParser.h"
#include "../CellWorker/CellWorkerFactory.h"

NS_CELL_BEGIN

CellHandler::CellHandler(DownloadConig* config, int workThreadCount)
	:_config(config)
	,_checkObserver(nullptr)
	,_downloadObserver(nullptr)
	,_cellTotalCount(0)
{
	_factory = new CellWorkerFactory(_config, workThreadCount) ;
	_factory->registerObserver(CELL_OBSERVER_CREATER(CellHandler::onCheck, this), CELL_OBSERVER_CREATER(CellHandler::onDownload, this)) ;
}

CellHandler::~CellHandler()
{
	delete _factory ;

	while ( !_cellsQueue.empty() )
	{
		Cell* cell = _cellsQueue.pop() ;
		delete cell ;
	}

	while ( !_postCellsQueue.empty() )
	{
		Cell* cell = _postCellsQueue.pop() ;
		delete cell ;
	}

}

void CellHandler::onCheck(Cell* cell, bool bRet)
{
	//CELL_LOG("*** CellHandler::onCheck ***  %s",cell->getName().c_str()) ;
	if (_checkObserver)
	{
		_checkObserver(cell, bRet) ;
	}
}

void CellHandler::onDownload(Cell* cell, bool bRet)
{
	//CELL_LOG("*** CellHandler::onDownload ***  %s",cell->getName().c_str()) ;
	if (_downloadObserver)
	{
		_downloadObserver(cell, bRet) ;
	}
}

void CellHandler::registerCheckObserver(const CellObserverFunctor& checkObserver)
{
	_checkObserver = checkObserver ;
}

void CellHandler::registerDownloadObserver(const CellObserverFunctor& downloadObserver)
{
	_downloadObserver = downloadObserver ;
}

void CellHandler::registerObserver(const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver)
{
	registerCheckObserver(checkObserver) ;
	registerDownloadObserver(downloadObserver) ;
}

void CellHandler::parse(const char* filePath, const char* fileName)
{
	CellParser parser(&_cellsQueue) ;
	parser.parse(filePath, fileName) ;
	_cellTotalCount += _cellsQueue.size() ;
}

void CellHandler::postCheckWork(const char* filePath, const char* fileName)
{
	parse(filePath, fileName) ;

	while ( !_cellsQueue.empty() )
	{
		Cell* cell = _cellsQueue.pop() ;
		_postCellsQueue.push(cell) ;
		_factory->postCheckWork(cell) ;
	}
}

void CellHandler::postDownloadWork(CellQueue<Cell*>& newCells)
{
	while ( !newCells.empty() )
	{
		_factory->postDownloadWork(newCells.pop()) ;
	}
}

NS_CELL_END