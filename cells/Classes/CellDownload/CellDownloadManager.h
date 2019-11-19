/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include "Download/DownloadConig.h"
#include "Cell/CellWorkCenter.h"


class CellDownloadManager : public cocos2d::Ref
{
private:
	NS_CELL::DownloadConig* _config ;
	NS_CELL::CellWorkCenter* _workCenter ;

	DownloadObserverFunctor _observer ;
	DownloadErrorObserverFunctor _errorObserver ;
	DownloadErrorObserverFunctor _idxErrorObserver ;
	DownloadRestartObserverFunctor _restartObserver ;
	DownloadForceUpdateObserverFunctor _forceUpdateObserver ;

	bool _autoDownload ; //auto start download when finish checked

	WORK_STATE _state ;
	WORK_STATE _stateTag ;

	std::recursive_mutex _stateMutex ;

	std::vector<std::string> _failedFiles ;
	std::string _failedIdxFile ;

	std::string _fileName ;
	/*
		check:		bRet:  is need update. true: yes, false: no.
		download:	bRet: download success. true: yes, false: no.
	*/
	bool _bRet ;
	int _nowCount ;
	int _totalCount ;
	double _nowSize ;
	double _totalSize ;

	std::string _restartKeyWord;

public:
	/* 
	in fact, all count of the work thread is (workThreadCount * 2 + 1) when it's working,
	because the threads for check and the threads for download are not the same one, and
	there is a factory thread manages all work threads.

	at the same time, the check threads are running or the download threads are running, or
	both of them are waitting. but the factory thread is always running.
	*/
	CellDownloadManager(const std::string& url, int urlCount, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount = 4) ;
	CellDownloadManager(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount = 4) ;
	virtual ~CellDownloadManager() ;

	int getWorkThreadCount() ;

	void postWork(const char* fileName) ;
	void postCheckWork(const char* fileName) ;
	void postDownloadWork() ;

	void registerObserver(const DownloadObserverFunctor& observer) ;
	void registerErrorObserver(const DownloadErrorObserverFunctor& observer) ;
	void registerIdxErrorObserver(const DownloadErrorObserverFunctor& observer) ;
	void registerRestartObserver(const DownloadRestartObserverFunctor& observer) ;
	void registerForceUpdateObserver(const DownloadForceUpdateObserverFunctor& observer) ;


	void setRestartKeyWord(const char* keyWord) { _restartKeyWord = keyWord  ; } ;

private:
	void init(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue, int workThreadCount) ;
	void scheduleUpdate(float delta) ;
	bool ignoreObserver() ;

	void onForceUpdate(const std::string& newVersion) ;

	void onChecking(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize) ;
	void onAllCheckedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double totalSize) ;

	void onDownloading(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;
	void onDownloadError(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;
	void onDownloadIdxError(const std::string& fileName) ;
	void onAllDownloadedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;

};