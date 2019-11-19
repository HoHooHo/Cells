/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "DirUtil.h"
#include "CellPlatform.h"

#ifdef MINIZIP_FROM_SYSTEM
#include <minizip/unzip.h>
#else // from our embedded sources
#include "unzip/unzip.h"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include <io.h>
#else
#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/stat.h>
#endif


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

void DirUtil::setRoot(const std::string& srcRoot, const std::string& desRoot){
	this->srcRoot = srcRoot;
	this->desRoot = desRoot;
}

std::string DirUtil::getDirByFileName(const std::string& fileName)
{
	std::string path = formatPath( fileName ) ;

	size_t found = path.find_last_of("/");


	if (std::string::npos != found)
	{
		return path.substr(0, found + 1) ;
	}
	else
	{
		return fileName;
	}

}

std::string DirUtil::getNameByFileName(const std::string& fileName)
{
	std::string path = formatPath( fileName ) ;

	size_t found = path.find_last_of("/");


	if (std::string::npos != found)
	{
		return path.substr(found + 1) ;
	}
	else
	{
		return fileName;
	}
}

std::string DirUtil::getExtNameByFileName(const std::string& fileName)
{
	size_t found = fileName.find_last_of(".");

	if (std::string::npos != found)
	{
		return fileName.substr(found + 1) ;
	}
	else
	{
		return fileName;
	}
}

std::string DirUtil::replaceExtName(std::string fileName, const std::string& newExtName)
{
	size_t found = fileName.find_last_of(".") ;

	if (std::string::npos != found)
	{
		fileName = fileName.erase(found + 1) ;
		fileName = fileName.append(newExtName) ;
	}

	return fileName ;
}

//bool DirUtil::access(const char* path)
//{
//	return ::access(path, 0) == 0 ;
//}
//
//bool DirUtil::remove(const char* file)
//{
//	return ::remove(file) == 0 ;
//}
//
//bool DirUtil::rename(const char* srcName, const char* desName)
//{
//	return ::rename(srcName, desName) == 0 ;
//}

bool DirUtil::isDirExist(const char* dir)
{
	//return this->access(dir) ;
	//std::unique_lock<std::mutex> lock(_mutex) ;
    return cocos2d::FileUtils::getInstance()->isDirectoryExist(dir) ;
}

bool DirUtil::isDirExistByFileName(const char* fileName)
{
	return isDirExist(getDirByFileName(fileName).c_str()) ;
}

bool DirUtil::isFileExist(const char* file, const bool ignoreCache /*= false*/)
{
	//	return this->access(file) ;
	//std::unique_lock<std::mutex> lock(_mutex) ;
    return cocos2d::FileUtils::getInstance()->isFileExist(file) ;
}

std::string DirUtil::getStringFromFile(const char* file)
{
	//std::unique_lock<std::mutex> lock(_mutex) ;
	return cocos2d::FileUtils::getInstance()->getStringFromFile(file) ;
}

std::string DirUtil::fullPathForFilename(const char* fileName)
{
	//std::unique_lock<std::mutex> lock(_mutex) ;
	return cocos2d::FileUtils::getInstance()->fullPathForFilename(fileName) ;
}

//bool DirUtil::mkDir(const char* dir)
//{
//	if (isDirExist(dir))
//	{
//		return true ;
//	}
//	
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
//#	include <direct.h>
//	return _mkdir(dir) == 0;
//#else
//	return ::mkdir(dir, S_IRWXU | S_IRWXG | S_IRWXO) == 0;
//#endif
//}
//
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

//bool DirUtil::createDirForFormate(const std::string& dir)
//{
//	std::string::size_type pos = 0 ;
//	pos = dir.find("/", pos) ;
//	while (pos != std::string::npos)
//	{
//		mkDir(dir.substr(0, pos).c_str()) ;
//		pos = dir.find("/", pos + 1) ;
//	}
//
//	return mkDir(dir.c_str());
//}

bool DirUtil::createDir(const std::string& dir)
{
//	const std::string path = formatPath(dir) ;
//
//	if (isDirExist(path.c_str()))
//	{
//		return true ;
//	}
	//	return createDirForFormate(path);
	std::unique_lock<std::mutex> lock(_mutex) ;
    return cocos2d::FileUtils::getInstance()->createDirectory(dir) ;
}

bool DirUtil::createDirByFileName(const std::string& fileName)
{
//	if (isDirExistByFileName(fileName.c_str()))
//	{
//		return true ;
//	}
//	return createDirForFormate(getDirByFileName(fileName)) ;
    return createDir(getDirByFileName(fileName)) ;
}

bool DirUtil::removeFile(const std::string& file)
{
	//	return this->remove(file.c_str()) ;
	//std::unique_lock<std::mutex> lock(_mutex) ;
    return cocos2d::FileUtils::getInstance()->removeFile(file) ;
}

bool DirUtil::renameFile(const std::string& path, const std::string& srcName, const std::string& desName)
{
	//	return this->rename(srcName.c_str(), desName.c_str()) ;
	//std::unique_lock<std::mutex> lock(_mutex) ;
    return cocos2d::FileUtils::getInstance()->renameFile(path, srcName, desName) ;
}

bool DirUtil::decompress(const std::string &zip, bool defaultRoot/* = false*/)
{
	if ( !DirUtil::getInstance()->isFileExist(zip.c_str()) )
	{
		CELL_LOG("DirUtil : zip file %s is not exist!", zip.c_str());
		return false;
	}
	// Find root path for zip file
	size_t pos = zip.find_last_of("/\\");
	if (pos == std::string::npos)
	{
		CELL_LOG("DirUtil : no root path specified for zip file %s", zip.c_str());
		return false;
	}
	const std::string rootPath = zip.substr(0, pos+1);

	// Open the zip file
	unzFile zipfile = cocos2d::unzOpen(zip.c_str());
	if (! zipfile)
	{
		CELL_LOG("DirUtil : can not open zip file %s", zip.c_str());
		return false;
	}

	// Get info about the zip file
	cocos2d::unz_global_info global_info;
	if (cocos2d::unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
	{
		CELL_LOG("DirUtil : can not read file global info of %s", zip.c_str());
		cocos2d::unzClose(zipfile);
		return false;
	}

	// Buffer to hold data read from the zip file
	char readBuffer[UNZIP_BUFFER_SIZE];
	// Loop to extract all files.
	uLong i;
	for (i = 0; i < global_info.number_entry; ++i)
	{
		// Get info about current file.
		cocos2d::unz_file_info fileInfo;
		char fileName[UNZIP_MAX_FILENAME];
		if (cocos2d::unzGetCurrentFileInfo(zipfile,
			&fileInfo,
			fileName,
			UNZIP_MAX_FILENAME,
			NULL,
			0,
			NULL,
			0) != UNZ_OK)
		{
			CELL_LOG("DirUtil : can not read compressed file info");
			cocos2d::unzClose(zipfile);
			return false;
		}

		std::string fullPath = rootPath + fileName;
		if (defaultRoot)
		{
			std::string::size_type srcLen = srcRoot.size();  
			std::string::size_type desLen = desRoot.size();  

			std::string::size_type pos = fullPath.find(srcRoot);   
			if ( pos != std::string::npos )  
			{  
				fullPath.replace(pos, srcLen, desRoot);  
			}
		}

		createDirByFileName(fullPath) ;
		

		// Check if this entry is a directory or a file.
		const size_t filenameLength = strlen(fileName);
		if (fileName[filenameLength-1] == '/')
		{
			//There are not directory entry in some case.
			//So we need to create directory when decompressing file entry
			if ( !createDir(DirUtil::getInstance()->getDirByFileName(fullPath)) )
			{
				// Failed to create directory
				CELL_LOG("DirUtil : can not create directory %s", fullPath.c_str());
				cocos2d::unzClose(zipfile);
				return false;
			}
		}
		else
		{
			// Entry is a file, so extract it.
			// Open current file.
			if (cocos2d::unzOpenCurrentFile(zipfile) != UNZ_OK)
			{
				CELL_LOG("DirUtil : can not extract file %s", fileName);
				cocos2d::unzClose(zipfile);
				return false;
			}

			// Create a file to store current file.
			FILE *out = fopen(fullPath.c_str(), "wb");
			if (!out)
			{
				CELL_LOG("DirUtil : can not create decompress destination file %s", fullPath.c_str());
				cocos2d::unzCloseCurrentFile(zipfile);
				cocos2d::unzClose(zipfile);
				return false;
			}

			// Write current file content to destinate file.
			int error = UNZ_OK;
			do
			{
				error = cocos2d::unzReadCurrentFile(zipfile, readBuffer, UNZIP_BUFFER_SIZE);
				if (error < 0)
				{
					CELL_LOG("DirUtil : can not read zip file %s, error code is %d", fileName, error);
					fclose(out);
					cocos2d::unzCloseCurrentFile(zipfile);
					cocos2d::unzClose(zipfile);
					return false;
				}

				if (error > 0)
				{
					fwrite(readBuffer, error, 1, out);
				}
			} while(error > 0);

			fclose(out);
		}

		cocos2d::unzCloseCurrentFile(zipfile);

		// Goto next entry listed in the zip file.
		if ((i+1) < global_info.number_entry)
		{
			if (cocos2d::unzGoToNextFile(zipfile) != UNZ_OK)
			{
				CELL_LOG("DirUtil : can not read next file for decompressing");
				cocos2d::unzClose(zipfile);
				return false;
			}
		}
	}

	CELL_LOG("DirUtil : decompress zip file end : %s", zip.c_str());

	cocos2d::unzClose(zipfile);
	return true;
}

void DirUtil::iterateFolder(const std::string& folder, int depth /* = 0 */)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	_finddata_t fileInfo ;
	std::string strFind = folder + "/*" ;
	long handle = _findfirst(strFind.c_str(), &fileInfo) ;

	if (handle == -1L)
	{
		CELL_LOG("DirUtil : can not match the folder path ==>> %s", folder.c_str()) ;
		return ;
	}

	do 
	{
		if (fileInfo.attrib & _A_SUBDIR)
		{
			if ( (strcmp(fileInfo.name, ".") != 0) && (strcmp(fileInfo.name, "..") != 0) )
			{
				std::string subFolder = folder + "/" + fileInfo.name ;
				iterateFolder(subFolder) ;
			}
		}
		else
		{
			std::string fileName = folder + "/" + fileInfo.name ;
			CELL_LOG("DirUtil : fileName = %s", fileName.c_str()) ;

			if ( fileName.substr(fileName.size() - 4) == ".zip" )
			{
				decompress(fileName, true) ;
			}
		}
	} while ( _findnext(handle, &fileInfo) == 0 );

	_findclose(handle) ;
#else
	DIR* dp ;
	struct dirent* entry ;
	struct stat statbuf ;
	if ( (dp = opendir(folder.c_str())) == nullptr )
	{
		CELL_LOG("DirUtil : can not match the folder path ==>> %s", folder.c_str()) ;

		return ;
	}

	chdir(folder.c_str()) ;
	while ( (entry = readdir(dp)) != nullptr )
	{
        std::string name = folder + "/" + entry->d_name ;
		lstat(name.c_str(), &statbuf) ;
		if (S_ISDIR(statbuf.st_mode))
		{
			if (strcmp(".", entry->d_name) == 0 || strcmp("..", entry->d_name) == 0)
			{
				continue ;
			}
			iterateFolder(folder + "/" + entry->d_name, depth + 4) ;
		}
		else
		{
			CELL_LOG("DirUtil : fileName = %s", name.c_str()) ;

			if ( name.substr(name.size() - 4) == ".zip" )
			{
				decompress(name, true) ;
			}
		}
	}
#endif

}

NS_CELL_END