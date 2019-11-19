/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include "Cell.h"
#include "../../Utils/CellPlatform.h"
#include "../../Utils/CellMacro.h"
#include "CellContainer.h"
#include "../../Download/DownloadConig.h"

NS_CELL_BEGIN

class CellParser : public cocos2d::SAXDelegator
{
private:
	CellMap<std::string, Cell*>* _cells ;
	std::string _fileName ;
	std::string* _cppVersion ;
	std::string* _svnVersion ;

	bool _local ;

public:
	CellParser(CellMap<std::string, Cell*>* cells, std::string* cppVersion, std::string* svnVersion) ;

	bool parse(DownloadConig* config, const char* fileName) ;

    virtual void startElement(void *ctx, const char *name, const char **atts) ;
    virtual void endElement(void *ctx, const char *name) ;
    virtual void textHandler(void *ctx, const char *s, int len) ;
};

NS_CELL_END