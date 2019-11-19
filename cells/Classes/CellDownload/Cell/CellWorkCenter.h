/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include "../Utils/CellMacro.h"
#include "../Download/DownloadConig.h"
#include "../Download/Downloader.h"
#include "Handler/CellHandler.h"

NS_CELL_BEGIN

typedef std::function<void(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double totalSize)> CellCheckObserverFunctor ;
typedef std::function<void(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)> CellDownloadObserverFunctor ;

class CellWorkCenter
{
private:
	DownloadConig* _config ;
	int _workThreadCount ;
	CellQueue<std::string> _fileNames ;
	std::unordered_map<std::string, int> _downloadCount ;
	CellHandler* _cellHandler ;

	Downloader* _dowloader ;
	FILE* _fp ;

private:
	CellQueue<Cell*> _downloadCells;
	CellQueue<Cell*> _downloadedErrorCells;

	CellQueue<Cell*> _checkedOkCells;
	CellQueue<Cell*> _downloadedOkCells;

private:
	int _checkedCount ;

	int _newNowCount ;
	int _newTotalCount ;
	double _newNowSize ;
	double _newTotalSize ;

private:
	CellCheckObserverFunctor _checkingObserver ;
	CellCheckObserverFunctor _allCheckedObserver ;
	CellDownloadObserverFunctor _downloadingObserver ;
	CellDownloadObserverFunctor _allDownloadedObserver ;
	CellDownloadObserverFunctor _downloadErrorObserver ;
	DownloadErrorObserverFunctor _downloadXMLErrorObserver ;
	DownloadForceUpdateObserverFunctor  _forceUpdateObserver ;

private:
	bool download(const std::string& file, const std::string& fileName) ;
	void startDownload(const std::string& file) ;
	void finishDownload(const std::string& file) ;

private:
	void initHandler() ;
	void unInitHandler() ;

	/*
		bRet:  is need update. true: yes, false: no.
	*/
	void onCheck(Cell* cell, bool bRet) ;
	void onCheckFinish(Cell* cell, bool bRet, int nowCount, int totalCount) ;
	void onDownload(Cell* cell, bool bRet) ;
	void onDownloadFinish(Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;

private:
	void doWork(const std::string& fileName) ;
	bool checkHashFile(const std::string& fileName) ;
	bool renameHash(const std::string& xmlName, int count) ;
	void renameAllHash() ;

public:
	CellWorkCenter(DownloadConig* config, int workThreadCount) ;
	virtual ~CellWorkCenter() ;

	void registerObserver(const CellCheckObserverFunctor& checkingObserver, 
						  const CellCheckObserverFunctor& allCheckedObserver, 
						  const CellDownloadObserverFunctor& downloadingObserver, 
						  const CellDownloadObserverFunctor& allDownloadedObserver, 
						  const CellDownloadObserverFunctor& downloadErrorObserver, 
						  const DownloadErrorObserverFunctor& downloadXMLErrorObserver,
						  const DownloadForceUpdateObserverFunctor& forceUpdateObserver
						  ) ;

	int getWorkThreadCount() ;
	void postCheckWork(const char* fileName, WORK_STATE workState) ;
	void postDownloadWork(WORK_STATE workState) ;
};

NS_CELL_END