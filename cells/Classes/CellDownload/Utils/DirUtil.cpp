#include "DirUtil.h"
#include "CellPlatform.h"

NS_CELL_BEGIN

DirUtil* DirUtil::getInstance()
{
	static DirUtil* s_dirUtil = nullptr ;
	if ( !s_dirUtil )
	{
		s_dirUtil = new DirUtil() ;
	}

	return s_dirUtil ;
}

std::string DirUtil::getDirByFileName(const std::string& fileName)
{
	std::string path = formatPath( fileName ) ;
	std::string dir = path.substr(0, path.find_last_of("/")) ;
	return dir ;
}

bool DirUtil::access(const char* path)
{
	return _access(path, 0) == 0 ;
}

bool DirUtil::remove(const char* file)
{
	return ::remove(file) == 0 ;
}

bool DirUtil::rename(const char* srcName, const char* desName)
{
	return ::rename(srcName, desName) == 0 ;
}

bool DirUtil::isDirExist(const char* dir)
{
	return this->access(dir) ;
}

bool DirUtil::isDirExistByFileName(const char* fileName)
{
	return isDirExist(getDirByFileName(fileName).c_str()) ;
}

bool DirUtil::isFileExist(const char* file)
{
	return this->access(file) ;
}

std::string DirUtil::getStringFromFile(const char* file)
{
	return cocos2d::FileUtils::getInstance()->getStringFromFile(file) ;
}

std::string DirUtil::fullPathForFilename(const char* fileName)
{
	return cocos2d::FileUtils::getInstance()->fullPathForFilename(fileName) ;
}

bool DirUtil::mkDir(const char* dir)
{
	if (isDirExist(dir))
	{
		return true ;
	}
	
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#	include <direct.h>
	return _mkdir(dir) == 0;
#else
	return ::mkdir(dir, S_IRWXU | S_IRWXG | S_IRWXO) == 0;
#endif
}

std::string DirUtil::formatPath(std::string path)
{
	std::string src = "\\" ;
	std::string des = "/" ;
	std::string::size_type srcLen = src.length() ;
	std::string::size_type desLen = des.length() ;
	for (size_t i = 0; i < path.size(); i++)
	{
		char s = path[i] ;
		if (path[i] == '\\')
		{
			path.replace(i, srcLen, des) ;
		}
	}

	return path ;
}

bool DirUtil::createDirForFormate(const std::string& dir)
{
	std::string::size_type pos = 0 ;
	pos = dir.find("/", pos) ;
	while (pos != std::string::npos)
	{
		mkDir(dir.substr(0, pos).c_str()) ;
		pos = dir.find("/", pos + 1) ;
	}

	return mkDir(dir.c_str());
}

bool DirUtil::createDir(const std::string& dir)
{
	const std::string path = formatPath(dir) ;

	if (isDirExist(path.c_str()))
	{
		return true ;
	}
	return createDirForFormate(path);
}

bool DirUtil::createDirByFileName(const std::string& fileName)
{
	if (isDirExistByFileName(fileName.c_str()))
	{
		return true ;
	}
	return createDirForFormate(getDirByFileName(fileName)) ;
}

bool DirUtil::removeFile(const std::string& file)
{
	return this->remove(file.c_str()) ;
}

bool DirUtil::renameFile(const std::string& srcName, const std::string& desName)
{
	return this->rename(srcName.c_str(), desName.c_str()) ;
}

NS_CELL_END