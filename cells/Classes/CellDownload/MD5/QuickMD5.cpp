#include "QuickMD5.h"
#include <iostream>
#include "../Utils/CellPlatform.h"

extern "C" {
#include "md5/md5.h"
}

NS_CELL_BEGIN

QuickMD5* QuickMD5::s_quickMd5 = nullptr ;

QuickMD5* QuickMD5::getInstance()
{
	if (!s_quickMd5)
	{
		s_quickMd5 = new QuickMD5() ;
	}

	return s_quickMd5 ;
}

const std::string QuickMD5::MD5File(const char* path)
{
	cocos2d::Data data = cocos2d::FileUtils::getInstance()->getDataFromFile(path) ;
	return MD5String((void*)(data.getBytes()), data.getSize()) ;
}



void QuickMD5::MD5(void* input, int inputLength, unsigned char* output)
{
	MD5_CTX ctx;
	MD5_Init(&ctx);
	MD5_Update(&ctx, input, inputLength);
	MD5_Final(output, &ctx);
}

const std::string QuickMD5::MD5String(void* input, int inputLength)
{
    unsigned char buffer[MD5_BUFFER_LENGTH];
    MD5(static_cast<void*>(input), inputLength, buffer);

    char* hex = bin2hex(buffer, MD5_BUFFER_LENGTH);
    std::string ret(hex);
    delete[] hex;

    return ret;
}

char* QuickMD5::bin2hex(unsigned char* bin, int binLength)
{
	static const char* hextable = "0123456789abcdef";

	int hexLength = binLength * 2 + 1;
	char* hex = new char[hexLength];
	memset(hex, 0, sizeof(char) * hexLength);

	int ci = 0;
	for (int i = 0; i < 16; ++i)
	{
		unsigned char c = bin[i];
		hex[ci++] = hextable[(c >> 4) & 0x0f];
		hex[ci++] = hextable[c & 0x0f];
	}

	return hex;
}

NS_CELL_END