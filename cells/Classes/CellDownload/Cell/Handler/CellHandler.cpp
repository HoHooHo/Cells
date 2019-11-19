/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellHandler.h"
#include <thread>
#include "../Cell/CellParser.h"
#include "../CellWorker/CellWorkerFactory.h"
#include "../../../Version/Version.h"

NS_CELL_BEGIN

CellHandler::CellHandler(DownloadConig* config, int workThreadCount)
	:_config(config)
	,_forceUpdateObserver(nullptr)
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


	for (CellMap<std::string, Cell*>::iterator it = _cellsMap.begin(); it != _cellsMap.end(); it++)
	{
		delete it->second;
	}

	_cellsMap.clear();

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

void CellHandler::registerForceUpdateObserver(const DownloadForceUpdateObserverFunctor& forceUpdateObserver)
{
	_forceUpdateObserver = forceUpdateObserver ;
}

void CellHandler::registerCheckObserver(const CellObserverFunctor& checkObserver)
{
	_checkObserver = checkObserver ;
}

void CellHandler::registerDownloadObserver(const CellObserverFunctor& downloadObserver)
{
	_downloadObserver = downloadObserver ;
}

void CellHandler::registerObserver(const DownloadForceUpdateObserverFunctor& forceUpdateObserver, const CellObserverFunctor& checkObserver, const CellObserverFunctor& downloadObserver)
{
	registerForceUpdateObserver(forceUpdateObserver) ;
	registerCheckObserver(checkObserver) ;
	registerDownloadObserver(downloadObserver) ;
}

std::string CellHandler::parse(DownloadConig* config, const char* fileName)
{
	std::string cppVersion ;
	std::string svnVersion ;
	CellParser parser(&_cellsMap, &cppVersion, &svnVersion) ;

	parser.parse(config, fileName) ;

	_config->setCppVersion(cppVersion) ;
	_config->setSvnVersion(svnVersion) ;

	_cellTotalCount += _cellsMap.size() ;

	return cppVersion ;
}

void CellHandler::postCheckWork(DownloadConig* config, const char* fileName)
{
	std::string cppVersion = parse(config, fileName) ;

	if (Version::getCPPVersion() != atoi(cppVersion.c_str()))
	{
		if (_forceUpdateObserver)
		{
			_forceUpdateObserver(cppVersion) ;
		}
	}else
	{
		if (_cellTotalCount == 0)
		{
			onCheck(nullptr, false);
		}else
		{
			for (CellMap<std::string, Cell*>::iterator iter = _cellsMap.begin(); iter != _cellsMap.end(); iter++)
			{
				_postCellsQueue.push(iter->second) ;
				_factory->postCheckWork(iter->second) ;
			}

			_cellsMap.clear();
		}
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