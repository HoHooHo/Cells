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
#include "CellMacro.h"

NS_CELL_BEGIN

class DirUtil
{
public:
	static DirUtil* getInstance() ;

	void setRoot(const std::string& srcRoot, const std::string& desRoot);

	bool isDirExist(const char* dir) ;
	bool isDirExistByFileName(const char* fileName) ;
	bool isFileExist(const char* file, const bool ignoreCache = false) ;

	std::string getStringFromFile(const char* file) ;

	std::string fullPathForFilename(const char* fileName) ;

	bool createDir(const std::string& dir) ;
	bool createDirByFileName(const std::string& fileName) ;

	bool removeFile(const std::string& file) ;

	bool renameFile(const std::string& path, const std::string& srcName, const std::string& desName) ;

	bool decompress(const std::string& filename, bool defaultRoot = false);

	void iterateFolder(const std::string& folder, int depth = 0) ;

	std::string getDirByFileName(const std::string& fileName) ;
	std::string getNameByFileName(const std::string& fileName) ;
	std::string getExtNameByFileName(const std::string& fileName) ;
	std::string replaceExtName(std::string fileName, const std::string& newExtName) ;

private:
	DirUtil() {} ;
//	bool access(const char* path) ;
//	bool remove(const char* file) ;
//	bool rename(const char* srcName, const char* desName) ;
//	bool mkDir(const char* dir) ;
//	bool createDirForFormate(const std::string& dir) ;
	std::string formatPath(std::string path) ;


	std::mutex _mutex ;


	std::string srcRoot;
	std::string desRoot;
};

NS_CELL_END