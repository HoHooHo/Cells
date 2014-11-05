#pragma once
#include "Download/DownloadConig.h"
#include "Cell/CellWorkCenter.h"
#include "Cell/CellWorkState.h"

typedef std::function<void(WORK_STATE workState, const std::string& fileName, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)> DownloadObserverFunctor ;
#define DOWNLOAD_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5, std::placeholders::_6, std::placeholders::_7)


class CellDownloadManager : public cocos2d::Ref
{
private:
	NS_CELL::DownloadConig* _config ;
	NS_CELL::CellWorkCenter* _workCenter ;

	DownloadObserverFunctor _observer ;

	bool _autoDownload ; //auto start download when finish checked

	WORK_STATE _state ;
	std::recursive_mutex _stateMutex ;

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

public:
	/* 
	in fact, all count of the work thread is (workThreadCount * 2 + 1) when it's working,
	because the threads for check and the threads for download are not the same one, and
	there is a factory thread manages all work threads.

	at the same time, the check threads are running or the download threads are running, or
	both of them are waitting. but the factory thread is always running.
	*/
	CellDownloadManager(const std::string& url, int urlCount, const std::string& srcRoot, const std::string& desRoot, int workThreadCount = 8) ;
	CellDownloadManager(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, int workThreadCount = 8) ;
	virtual ~CellDownloadManager() ;

	int getWorkThreadCount() ;

	void postWork(const char* fileName) ;
	void postCheckWork(const char* fileName) ;
	void postDownloadWork() ;

	void registerObserver(const DownloadObserverFunctor& observer) ;

private:
	void init(const std::vector<std::string>& urlVector, const std::string& srcRoot, const std::string& desRoot, int workThreadCount) ;
	void scheduleUpdate(float delta) ;

	void onChecking(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount) ;
	void onAllCheckedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount) ;

	void onDownloading(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;
	void onDownloadError(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;
	void onAllDownloadedFinish(NS_CELL::Cell* cell, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize) ;

};