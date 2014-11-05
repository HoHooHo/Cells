import os, sys
from optparse import OptionParser
import hashlib
import shutil

enter = '\n'
tab = '\t'

def getMD5(fileName):
	file = open(fileName, 'rb')
	md5 = hashlib.md5()
	md5.update(file.read())
	file.close()

	return md5.hexdigest()

def getRelativePath(root, fileName):
	path = fileName.replace(root, '')
	path = path.replace('\\', '/')
	path = path.replace('//', '/')

	return path

def getSize(fileName):
	return os.path.getsize(fileName)

def output(output_path, data):
	templateHandle = open('template.xml', 'r')
	templateContent = templateHandle.read()
	templateHandle.close()


	cellContent = templateContent.replace('cells_data', data)

	cellName = output_path + 'cells.xml'
	cellXMLHandle = open(cellName, 'w')
	cellXMLHandle.write(cellContent)
	cellXMLHandle.close()

	cellXMLHashValue = getMD5(cellName)
	cellHashName = cellName + '.hash'
	cellHashHandle = open(cellHashName, 'w')
	cellHashHandle.write(cellXMLHashValue)
	cellHashHandle.close()

def createCell(fileName, rootDir):
	name = ' name="' + getRelativePath(rootDir, fileName) + '"'
	md5 = ' md5="' + getMD5(fileName) + '"'
	size = ' size="' + '%d' %getSize(fileName) + '"'

	cell = tab + '<cell' + md5 + size + name + ' />' + enter

	# print cell

	return cell

def clear(path):
	if os.path.exists(path):
		shutil.rmtree(path)

def copyFile(fileName, input_path, output_path):
	des = output_path + getRelativePath(input_path, fileName)
	src = fileName

	fileDir = os.path.dirname(des)

	if not os.path.exists(fileDir):
		os.makedirs(fileDir)

	shutil.copy(src, des)


def  build(input_path, output_path):
	clear(output_path)
	data = enter
	for root, dirs, files in os.walk(input_path):
		for file in files:
			if not root.endswith("/"):
				root = root + '/'
			fileName = root + file

			copyFile(fileName, input_path, output_path)
			cell = createCell(fileName, input_path)

			data = data + cell
        
	output(output_path, data)


if __name__ == '__main__':

    parser = OptionParser()
    parser.add_option("-i", "--input", dest="arg_input", help='intput path')
    (opts, args) = parser.parse_args()

    arg_output = os.getcwd() + "/output/"
    build(opts.arg_input, arg_output)
    print("==================    end    ====================")
