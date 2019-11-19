module("MusicHelper", package.seeall)

--进入战斗界面前，记录一下背景音乐名称
-- 退出战斗界面时，如果是没有配置背景音乐的界面，则可能出现没有背景音乐的情况
local _musicName = nil

-- 进入某个的界面时，播放对应的背景音乐
local LOGIC_NAME__BACKGROUND_MUSIC = {
	["MainViewLogic"]               = ResConfig.MUSIC_MAIN,

	["AdventureViewLogic"]          = ResConfig.MUSIC_ADVENTURE,
	["HerosDeveloperViewLogic"]     = ResConfig.MUSIC_ADVENTURE,
	["PvPMainViewLogic"]            = ResConfig.MUSIC_ADVENTURE,
	["RecruitViewLogic"]            = ResConfig.MUSIC_ADVENTURE,
	["MercenaryViewLogic"]          = ResConfig.MUSIC_ADVENTURE,
	["MineViewLogic"]               = ResConfig.MUSIC_ADVENTURE,
	["DreamLandViewLogic"]          = ResConfig.MUSIC_ADVENTURE,
	
	["ChallengeViewLogic"]          = ResConfig.MUSIC_CHALLENGE,
	["AdventureChallengeViewLogic"] = ResConfig.MUSIC_CHALLENGE,
	["WorldBossViewLogic"]          = ResConfig.MUSIC_CHALLENGE,
	["CaveViewLogic"]               = ResConfig.MUSIC_CHALLENGE,
	["ComicInstanceViewLogic"]  	= ResConfig.MUSIC_CHALLENGE,
}

local BATTLE_LOGIC_NAME = "BattleViewLogic"


local function playBattleBG()
	local battleType = BattleManager.getBattleType()

	if 	   battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_ADVENTURE
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_LOCALARENA
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_LOCALRANKBATTLE
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_CAMPAIGN
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_GLO_CAMP
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_EXPEDITION
	then
		AudioManager.playBackgroud(ResConfig.MUSIC_BATTLE)
	elseif battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_ADVENTURE_CHALLENGE
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_REBORNBOSS
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_WORLDBOSS
		or battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_MININGCAVE
	then
		AudioManager.playBackgroud(ResConfig.MUSIC_BATTLE_CHALLENGE)
	elseif battleType == FormationData.FORMATION_BATTLE_TYPE.BATTLE_TYPE_COMIC_INSTANCE then
		local isHard = ComicInstanceData.isBattleHard()
		AudioManager.playBackgroud(isHard and ResConfig.MUSIC_BATTLE_CHALLENGE or ResConfig.MUSIC_BATTLE)
	else
		AudioManager.playBackgroud(ResConfig.MUSIC_BATTLE)
	end
end

function tryPlayBackgroud( logicName )
	if LOGIC_NAME__BACKGROUND_MUSIC[logicName] then
		AudioManager.playBackgroud(LOGIC_NAME__BACKGROUND_MUSIC[logicName])
		_musicName = nil
	elseif logicName == BATTLE_LOGIC_NAME then
		_musicName = AudioManager.getMusicName() or _musicName
		playBattleBG()
	elseif _musicName and not BattleManager.inBattle() then
		AudioManager.playBackgroud(_musicName)
		_musicName = nil
	end
end