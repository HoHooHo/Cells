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