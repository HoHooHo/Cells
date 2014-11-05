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

public:
	DownloadConig(const std::vector<std::string>& url, const std::string& srcRoot, const std::string& desRoot)
	{
		setURL(url) ;
		setSrcRoot(srcRoot) ;
		setDesRoot(desRoot) ;
	} ;

	virtual ~DownloadConig() {} ;

	inline const std::vector<std::string>& getURL(){ return _url ; } ;
	inline std::string getSrcRoot(){ return _srcRoot ; } ;
	inline std::string getDesRoot(){ return _desRoot ; } ;

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
};

NS_CELL_END