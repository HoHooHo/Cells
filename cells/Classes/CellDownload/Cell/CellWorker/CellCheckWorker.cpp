/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellCheckWorker.h"
#include "../../Utils/DirUtil.h"
#include "../../MD5/QuickMD5.h"

NS_CELL_BEGIN

CellCheckWorker::CellCheckWorker(DownloadConig* config)
	:CellWorker(config)
{
	create() ;
}

CellCheckWorker::~CellCheckWorker()
{
	destroy() ;
}


bool CellCheckWorker::doWork(Cell* cell)
{
	bool bRet = true ;
	if (cell)
	{
		std::string cellName = cell->getName() ;
		std::string srcFile = _config->getSrcRoot() + cellName ;
		std::string desFile = _config->getDesRoot() + cellName ;

		std::string cellMD5 = cell->getMD5() ;
		std::string fileMD5 = cell->getLocalMD5() ;

		// 当部分下载失败时为了不重复下载，把需要下载的文件进行md5对比
		if (DirUtil::getInstance()->isFileExist(desFile.c_str()))
		{
			fileMD5 = QuickMD5::getInstance()->MD5File(desFile.c_str()) ;
		}
		else if (DirUtil::getInstance()->isFileExist(srcFile.c_str()))
		{
			fileMD5 = QuickMD5::getInstance()->MD5File(srcFile.c_str()) ;
		}

		bRet = cellMD5.compare(fileMD5) != 0 ;
	}

	return bRet ;
}


NS_CELL_END