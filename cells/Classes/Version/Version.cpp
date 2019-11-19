/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#include "Version.h"

#include "cocos2d.h"

#define CPP_VERSION 111   //勿改格式 谢谢

int Version::getCPPVersion()
{
	return CPP_VERSION ;
}

std::string Version::getCPPVersionDesc()
{
	cocos2d::String* version = cocos2d::String::createWithFormat("%d", CPP_VERSION) ;

	int len = version->length() ;
	std::string versionDesc = version->getCString() ;
	for (int i = len - 1; i > 0; i--)
	{
		versionDesc.insert(i, ".") ;
	}
	

	return versionDesc ;
}