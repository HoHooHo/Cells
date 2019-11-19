/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "CellParser.h"
#include "../../Utils/DirUtil.h"

NS_CELL_BEGIN

const char* TAG_CELL = "cell" ;
const char* TAG_CELLS = "cells" ;
const char* TAG_VERSION = "version" ;

CellParser::CellParser(CellMap<std::string, Cell*>* cells, std::string* cppVersion, std::string* svnVersion)
	:_cells(cells)
	,_fileName("")
	,_cppVersion(cppVersion)
	,_svnVersion(svnVersion)
	,_local(false)
{

}

bool CellParser::parse(DownloadConig* config, const char* fileName)
{
	_fileName = fileName ;

	std::string srcFullName = NS_CELL::DirUtil::getInstance()->fullPathForFilename( (config->getSrcRoot() + std::string(fileName)).c_str() ) ;

	std::string tempFullName = config->getDesRoot() + std::string(fileName) + TEMP_SUFFIX ;
	cocos2d::SAXParser parser ;

	if ( !parser.init("UTF-8") )
	{
		CELL_LOG("[Cells] CCSAXParser.init failed! when load file: %s", tempFullName.c_str());
		return false ;
	}

	parser.setDelegator(this) ;
	bool bRet = parser.parse(tempFullName) ;

	_local = true;

	if (NS_CELL::DirUtil::getInstance()->isFileExist(srcFullName.c_str()))
	{
		bRet = parser.parse(srcFullName) ;
	}

	return bRet ;
}


void CellParser::startElement(void *ctx, const char *name, const char **atts)
{
	if (strcmp(TAG_CELLS, name) == 0 && (*atts))
	{
		if (!_local)
		{
			*_cppVersion = atts[1] ;
			*_svnVersion = atts[3] ;
		}
	}
	else if ( strcmp(TAG_CELL, name) == 0 && (*atts) ) 
	{
		if (!_local)
		{
			std::unordered_map<std::string, std::string> attrMap ;
			for (size_t i = 0; atts[i] && atts[i+1]; i+=2 )
			{
				attrMap.insert( std::make_pair(atts[i], atts[i+1]) ) ;
			}
			Cell* cell = new Cell(_fileName, attrMap) ;

			_cells->insert(cell->getName(), cell);
		}
		else
		{
			CellMap<std::string, Cell*>::iterator iter = _cells->find(atts[5]);
			if (iter != _cells->end())
			{
				Cell* cell = iter->second;
				cell->setLocalMD5(atts[1]);

				if (cell->getMD5().compare(cell->getLocalMD5()) == 0)
				{
					_cells->erase(iter) ;
					delete cell;
				}
			}
		}
	}
}

void CellParser::textHandler(void *ctx, const char *s, int len)
{
	//CELL_LOG("textHandler  s: %s", s) ;
}

void CellParser::endElement(void *ctx, const char *name)
{
	//CELL_LOG("endElement  name: %s", name) ;
}

NS_CELL_END