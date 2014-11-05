#pragma once
#include "CellMacro.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#	include <direct.h>
#	include <io.h>
#else
#	include <sys/stat.h>
#	include <unistd.h>
#endif
