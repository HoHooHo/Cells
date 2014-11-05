#pragma once

#include "../../Utils/CellMacro.h"
#include "CellWorker.h"

NS_CELL_BEGIN

class CellCheckWorker : public CellWorker
{
public:
	CellCheckWorker(DownloadConig* config) ;
	virtual ~CellCheckWorker() ;

protected:
	virtual bool doWork(Cell* cell) ;
};

NS_CELL_END