/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once

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

typedef std::function<void( const std::string& newVersion )> CellForceUpdateObserverFunctor ;
#define CELL_FORCE_UPDATE_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1)

#define CELL_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2)

#define CELL_CHECK_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5)
#define CELL_DOWNLOAD_OBSERVER_CREATER(__selector__,__target__) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4, std::placeholders::_5, std::placeholders::_6)


#define MD5_SUFFIX  ".hash" ;
#define TEMP_SUFFIX  ".temp" ;


#ifndef UNZIP_BUFFER_SIZE
#define UNZIP_BUFFER_SIZE    8192
#endif // !UNZIP_BUFFER_SIZE

#ifndef UNZIP_MAX_FILENAME
#define UNZIP_MAX_FILENAME    512
#endif // !UNZIP_MAX_FILENAME
