#include "CellParser.h"

NS_CELL_BEGIN

const char* TAG_CELL = "cell" ;
const char* TAG_NAME = "name" ;
const char* TAG_MD5  = "md5"  ;
const char* TAG_SIZE = "size" ;

CellParser::CellParser(CellQueue<Cell*>* cells)
	:_cells(cells)
	,_fileName("")
{

}

bool CellParser::parse(const char* filePath, const char* fileName)
{
	_fileName = fileName ;
	std::string fullName = std::string(filePath) + std::string(fileName) ;
	cocos2d::SAXParser parser ;

	if ( !parser.init("UTF-8") )
	{
		CELL_LOG("[Cells] CCSAXParser.init failed! when load file: %s", fullName);
		return false ;
	}

	parser.setDelegator(this) ;

	return parser.parse(fullName) ;
}


void CellParser::startElement(void *ctx, const char *name, const char **atts)
{
	if ( strcmp(TAG_CELL, name) == 0 && (*atts) ) 
	{
		std::map<std::string, std::string> attrMap ;
		for (size_t i = 0; atts[i] && atts[i+1]; i+=2 )
		{
			//CELL_LOG("key: %s", atts[i]) ;
			//CELL_LOG("value: %s", atts[i+1]) ;
			attrMap.insert( std::make_pair(atts[i], atts[i+1]) ) ;
		}
		Cell* cell = new Cell(_fileName, attrMap) ;

		_cells->push(cell) ;
	}
}

void CellParser::textHandler(void *ctx, const char *s, int len)
{
	//CELL_LOG("textHandler  s: %s", s) ;
}

void CellParser::endElement(void *ctx, const char *name)
{
	//CELL_LOG("endElement  name: %s", name) ;
}

NS_CELL_END