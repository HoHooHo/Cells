/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once


enum WORK_STATE
{
	WORK_STATE_00_NONE,
	WORK_STATE_01_READY_CHECK,
	WORK_STATE_02_CHECKING,
	WORK_STATE_03_CHECK_FINISH,
	WORK_STATE_04_READY_DOWNLOAD,
	WORK_STATE_05_DOWNLOADING,
	WORK_STATE_06_DOWNLOAD_ERROR,
	WORK_STATE_07_ALL_FINISH,
	WORK_STATE_08_WAIT
};

#define USING_COCOS2DX 0
#define CELL_DEBUG	0


#ifdef USING_COCOS2DX

#	include "cocos2d.h"
#	define PRINT_LOG	cocos2d::log

#else

#	define PRINT_LOG	printf

#endif // USING_COCOS2DX


#ifdef CELL_DEBUG

#	define CELL_LOG(format, ...)	PRINT_LOG(format, ##__VA_ARGS__)

#else

#	define CELL_LOG(format, ...)	do {} while (0)

#endif // CELL_DEBUG

#define NS_CELL					cell
#define NS_CELL_BEGIN			namespace NS_CELL {
#define NS_CELL_END				}
#define USING_NS_CELL			using namespace NS_CELL



#define CELL_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2)


typedef std::function<void(WORK_STATE workState, const std::string& fileName, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)> DownloadObserverFunctor ;
typedef std::function<void(const std::string& fileName)> DownloadErrorObserverFunctor ;
typedef std::function<void(const std::string& newVersion)> DownloadForceUpdateObserverFunctor ;
typedef std::function<void()> DownloadRestartObserverFunctor ;


#define CELL_CHECK_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5)
#define CELL_DOWNLOAD_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5, std::placeholders::_6)
#define CELL_DOWNLOAD_XML_ERR_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1)
#define CELL_FORCE_UPDATE_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1)


// 外部类绑定回调函数 宏定义
#define DOWNLOAD_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5, std::placeholders::_6, std::placeholders::_7)
#define DOWNLOAD_ERROR_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1)
#define DOWNLOAD_RESTART_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__)
#define DOWNLOAD_FORCE_UPDATE_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1)


#define MD5_SUFFIX  ".hash" ;
#define TEMP_SUFFIX  ".temp" ;


#ifndef UNZIP_BUFFER_SIZE
#define UNZIP_BUFFER_SIZE    8192
#endif // !UNZIP_BUFFER_SIZE

#ifndef UNZIP_MAX_FILENAME
#define UNZIP_MAX_FILENAME    512
#endif // !UNZIP_MAX_FILENAME
