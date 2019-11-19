#include "HelloWorldScene.h"
USING_NS_CC;

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    auto closeItem = MenuItemImage::create(
                                           "CloseNormal.png",
                                           "CloseSelected.png",
                                           CC_CALLBACK_1(HelloWorld::menuCloseCallback, this));
    
	closeItem->setPosition(Vec2(origin.x + visibleSize.width - closeItem->getContentSize().width/2 ,
                                origin.y + closeItem->getContentSize().height/2));

    // create menu, it's an autorelease object
    auto menu = Menu::create(closeItem, NULL);
    menu->setPosition(Vec2::ZERO);
    this->addChild(menu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    //
    //auto label = LabelTTF::create("Hello World", "Arial", 24);
    //
    //// position the label on the center of the screen
    //label->setPosition(Vec2(origin.x + visibleSize.width/2,
    //                        origin.y + visibleSize.height - label->getContentSize().height));

    //// add the label as a child to this layer
    //this->addChild(label, 1);

    // add "HelloWorld" splash screen"
    auto sprite = Sprite::create("HelloWorld.png");

    // position the sprite on the center of the screen
    sprite->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));

    // add the sprite as a child to this layer
    this->addChild(sprite, 0);
    
    return true;
}
CellDownloadManager* cdm = nullptr ;

void foo(WORK_STATE workState, const std::string& fileName, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	switch (workState)
	{
	case WORK_STATE_00_NONE:
		CCLOG("************WORK_STATE_00_NONE") ;
		break;
	case WORK_STATE_01_READY_CHECK:
		CCLOG("************WORK_STATE_01_READY_CHECK") ;
		break;
	case WORK_STATE_02_CHECKING:
		CCLOG("************WORK_STATE_02_CHECKING  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_03_CHECK_FINISH:
		CCLOG("************WORK_STATE_03_CHECK_FINISH  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_04_READY_DOWNLOAD:
		CCLOG("************WORK_STATE_04_READY_DOWNLOAD  %d", totalSize) ;
		break;
	case WORK_STATE_05_DOWNLOADING:
		CCLOG("************WORK_STATE_05_DOWNLOADING  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_06_DOWNLOAD_ERROR:
		CCLOG("************WORK_STATE_06_DOWNLOAD_ERROR  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_07_ALL_FINISH:
		CCLOG("************WORK_STATE_07_ALL_FINISH  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_08_WAIT:
		CCLOG("************WORK_STATE_08_WAIT") ;
		break;
	}
	
}

void HelloWorld::onWorking(WORK_STATE workState, const std::string& fileName, bool bRet, int nowCount, int totalCount, double nowSize, double totalSize)
{
	switch (workState)
	{
	case WORK_STATE_00_NONE:
		CCLOG("************WORK_STATE_00_NONE") ;
		break;
	case WORK_STATE_01_READY_CHECK:
		CCLOG("************WORK_STATE_01_READY_CHECK") ;
		break;
	case WORK_STATE_02_CHECKING:
		CCLOG("************WORK_STATE_02_CHECKING  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_03_CHECK_FINISH:
		CCLOG("************WORK_STATE_03_CHECK_FINISH  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_04_READY_DOWNLOAD:
		CCLOG("************WORK_STATE_04_READY_DOWNLOAD  %d", totalSize) ;
		break;
	case WORK_STATE_05_DOWNLOADING:
		CCLOG("************WORK_STATE_05_DOWNLOADING  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_06_DOWNLOAD_ERROR:
		CCLOG("************WORK_STATE_06_DOWNLOAD_ERROR  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_07_ALL_FINISH:
		CCLOG("************WORK_STATE_07_ALL_FINISH  %d / %d", nowCount, totalCount) ;
		break;
	case WORK_STATE_08_WAIT:
		CCLOG("************WORK_STATE_08_WAIT") ;

		CCLOG("**************************************** OVER") ;
		break;
	}

}

void HelloWorld::onDownloadError(std::string filename)
{
	CCLOG("************ onDownloadError: %s", filename.c_str()) ;
}

void HelloWorld::onDownloadXMLError(std::string filename)
{
	CCLOG("************ onDownloadXMLError: %s", filename.c_str()) ;
}

void HelloWorld::onRestart()
{
	CCLOG("************************************************ onRestart") ;
}

void HelloWorld::onForceUpdate(std::string newVersion)
{
	CCLOG("************ onForceUpdate: %s", newVersion.c_str()) ;
}

int m = 0 ;

void HelloWorld::menuCloseCallback(Ref* pSender)
{
	m++ ;
	if (m == 1)
	{
		cdm = new CellDownloadManager("127.0.0.1/celltest", 3, "E:/project/github/Cells/cells/Resources", FileUtils::getInstance()->getWritablePath() + "Resources", "?rnd=rand123") ;
		
		//cdm->registerObserver(DownloadObserverFunctor(foo)) ;
		cdm->registerObserver(DOWNLOAD_OBSERVER_CREATER(HelloWorld::onWorking, this));
		cdm->registerErrorObserver(DOWNLOAD_ERROR_OBSERVER_CREATER(HelloWorld::onDownloadError, this));
		cdm->registerXMLErrorObserver(DOWNLOAD_ERROR_OBSERVER_CREATER(HelloWorld::onDownloadXMLError, this));
		cdm->registerRestartObserver(DOWNLOAD_RESTART_OBSERVER_CREATER(HelloWorld::onRestart, this));
		cdm->registerForceUpdateObserver(DOWNLOAD_FORCE_UPDATE_OBSERVER_CREATER(HelloWorld::onForceUpdate, this));
		cdm->setRestartKeyWord("core_res");
		cdm->postWork("cells.xml") ;

	}else if(m == 2)
	{
		delete cdm ;
		cdm = nullptr ;
		m = 0 ;
	}
	

//#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8) || (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
//	MessageBox("You pressed the close button. Windows Store Apps do not implement a close button.","Alert");
//    return;
//#endif
//
//    Director::getInstance()->end();
//
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
//    exit(0);
//#endif
}
