/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include <string>
#include <unordered_map>
#include <functional>
#include "../../Utils/CellMacro.h"

NS_CELL_BEGIN

class Cell
{
public:
	Cell(const std::string& xmlName, const std::string& name, const std::string& md5, double size) ;
	Cell(const std::string& xmlName, std::unordered_map<std::string, std::string>& map) ;
	virtual ~Cell() ;

	inline std::string& getXMLName(){ return _xmlName ; } ;
	inline std::string& getName(){ return _name ; } ;
	inline std::string& getMD5Name(){ return _md5Name ; } ;
	inline std::string& getMD5(){ return _md5 ; } ;
	inline std::string& getLocalMD5(){ return _localMD5 ; } ;
	inline double getSize(){ return _size ; } ;


	inline void setLocalMD5(std::string localMD5){ _localMD5 = localMD5 ; } ;

private:
	std::string _xmlName ;
	std::string _name ;
	std::string _md5Name ;
	std::string _md5 ;

	std::string _localMD5 ;
	double _size ;

	void init(const std::string& xmlName, std::unordered_map<std::string, std::string>& map) ;
};

typedef std::function<void(Cell* cell, bool bRet)> CellObserverFunctor ;

NS_CELL_END