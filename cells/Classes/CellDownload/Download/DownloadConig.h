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

class DownloadConig
{
private:
	std::vector<std::string> _url ;
	std::string _srcRoot ;
	std::string _desRoot ;
	std::string _random ;

	std::string _cppVersion ;
	std::string _svnVersion ;

public:
	DownloadConig(const std::vector<std::string>& url, const std::string& srcRoot, const std::string& desRoot, const std::string& randomValue)
	{
		setURL(url) ;
		setSrcRoot(srcRoot) ;
		setDesRoot(desRoot) ;
		setRandom(randomValue) ;
		_cppVersion = "" ;
		_svnVersion = "" ;
	} ;

	virtual ~DownloadConig() {} ;

	inline const std::vector<std::string>& getURL(){ return _url ; } ;
	inline std::string getSrcRoot(){ return _srcRoot ; } ;
	inline std::string getDesRoot(){ return _desRoot ; } ;
	inline std::string getRandom(){ return _random ; } ;
	inline std::string getCppVersion(){ return _cppVersion ; } ;
	inline std::string getSvnVersion(){ return _svnVersion ; } ;

	inline void urlOpt(std::string url)
	{
		if (url != _url.front())
		{
			_url.insert(std::begin(_url), url) ;
		}
	}

private:
	inline void setURL(const std::vector<std::string>& urlVector)
	{
		for(auto url : urlVector)
		{
			if (url.at(url.length() - 1) != '/')
			{
				url.append("/") ;
			}
			_url.push_back(url) ;
		}
	} ;

	inline void setSrcRoot(const std::string& srcRoot)
	{
		_srcRoot = srcRoot ;
		if (_srcRoot.at(_srcRoot.length() - 1) != '/')
		{
			_srcRoot.append("/") ;
		}
	} ;

	inline void setDesRoot(const std::string& desRoot)
	{
		_desRoot = desRoot ;
		if (_desRoot.at(_desRoot.length() - 1) != '/')
		{
			_desRoot.append("/") ;
		}
	} ;

	inline void setRandom(const std::string& randomValue)
	{
		_random = randomValue ;
	}

public:
	inline void setCppVersion(std::string& cppVersion)
	{
		_cppVersion = cppVersion ;
	}

	inline void setSvnVersion(std::string& svnVersion)
	{
		_svnVersion = svnVersion ;
	}
};

NS_CELL_END