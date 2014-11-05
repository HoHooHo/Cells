#pragma once
#include <string>
#include "CellMacro.h"

NS_CELL_BEGIN

class DirUtil
{
public:
	static DirUtil* getInstance() ;

	bool isDirExist(const char* dir) ;
	bool isDirExistByFileName(const char* fileName) ;
	bool isFileExist(const char* file) ;

	std::string getStringFromFile(const char* file) ;

	std::string fullPathForFilename(const char* fileName) ;

	bool createDir(const std::string& dir) ;
	bool createDirByFileName(const std::string& fileName) ;

	bool removeFile(const std::string& file) ;

	bool renameFile(const std::string& srcName, const std::string& desName) ;

private:
	DirUtil() {} ;
	std::string getDirByFileName(const std::string& fileName) ;
	bool access(const char* path) ;
	bool remove(const char* file) ;
	bool rename(const char* srcName, const char* desName) ;
	bool mkDir(const char* dir) ;
	bool createDirForFormate(const std::string& dir) ;
	std::string formatPath(std::string path) ; 
};

NS_CELL_END