#include "Cell.h"

NS_CELL_BEGIN

Cell::Cell(const std::string& xmlName, const std::string& name, const std::string& md5, double size)
:_xmlName(xmlName)
,_name(name)
,_md5(md5)
,_size(size)
{
	_md5Name = name + MD5_SUFFIX ;
}

Cell::Cell(const std::string& xmlName, std::map<std::string, std::string>& map)
{
	init(xmlName, map) ;
}

Cell::~Cell()
{

}

void Cell::init(const std::string& xmlName, std::map<std::string, std::string>& map)
{
	_xmlName = xmlName ;
	_name = map["name"] ;
	_md5Name = _name + MD5_SUFFIX ;
	_md5 = map["md5"] ;
	_size = atof(map["size"].c_str()) ;
}

NS_CELL_END