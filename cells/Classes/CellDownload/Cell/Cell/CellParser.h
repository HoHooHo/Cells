#pragma once
#include "Cell.h"
#include "../../Utils/CellPlatform.h"
#include "../../Utils/CellMacro.h"
#include "CellContainer.h"

NS_CELL_BEGIN

class CellParser : public cocos2d::SAXDelegator
{
private:
	CellQueue<Cell*>* _cells ;
	std::string _fileName ;
public:
	CellParser(CellQueue<Cell*>* cells) ;

	bool parse(const char* filePath, const char* fileName) ;

    virtual void startElement(void *ctx, const char *name, const char **atts) ;
    virtual void endElement(void *ctx, const char *name) ;
    virtual void textHandler(void *ctx, const char *s, int len) ;
};

NS_CELL_END