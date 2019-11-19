/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include "CellMacro.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#	include <direct.h>
#	include <io.h>
#else
#	include <sys/stat.h>
#	include <unistd.h>
#endif
