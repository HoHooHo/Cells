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
#include "../Utils/CellMacro.h"

NS_CELL_BEGIN

#define MD5_BUFFER_LENGTH 16

class QuickMD5
{
public:
	static QuickMD5* getInstance() ;

	const std::string MD5File(const char* path);
	const std::string MD5String(const std::string str);

	const std::string SimpleMD5File(const char* path);
	const std::string SimpleMD5String(const std::string str);
    
private:
	QuickMD5(void) {}
	char* bin2hex(unsigned char* bin, int binLength);

	static QuickMD5* s_quickMd5 ;

	std::mutex _mutex ;


	/** @brief Calculate MD5, get MD5 code (not string) */
	void MD5(void* input, int inputLength,
		unsigned char* output);

	const std::string _MD5String(void* input, int inputLength);
};

NS_CELL_END