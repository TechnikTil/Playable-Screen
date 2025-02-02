local animations = {
	{
		name = 'singLEFT';
		frames = {
			{
				x = -22.9;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = -19.15;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = -9.05;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
		};
	},
	{
		name = 'singDOWN';
		frames = {
			{
				x = 0;
				y = 11.05;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 7.4;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 3.9;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
		};
	},
	{
		name = 'singUP';
		frames = {
			{
				x = 0;
				y = -25;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = -11.25;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = -3.75;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
		};
	},
	{
		name = 'singRIGHT';
		frames = {
			{
				x = 33.15;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = 22.1;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = 6.5;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
		};
	},
	{
		name = 'hey';
		frames = {
			{
				x = -17.05;
				y = -9.55;
				width = 34.1;
				height = 19.2;
			},
			{
				x = -79.2;
				y = -44.5;
				width = 158.5;
				height = 89.15;
			},
			{
				x = -60.95;
				y = -32.6;
				width = 132.9;
				height = 73.15;
			},
			{
				x = -60.95;
				y = -32.6;
				width = 132.9;
				height = 73.15;
			},
			{
				x = -38.15;
				y = -21.45;
				width = 76.55;
				height = 43.05;
			},
			{
				x = -38.15;
				y = -21.45;
				width = 76.55;
				height = 43.05;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			},
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
		};
	}
}

local baseWindow = {
	x = 0;
	y = 0;
};

function onCreatePost()
	makeLuaSprite('missOverlay');
	makeGraphic('missOverlay', screenWidth, screenHeight);
	setObjectCamera('missOverlay', 'camOther');
	setProperty('missOverlay.color', getColorFromHex('565694'));
	setProperty('missOverlay.alpha', 0.8);
	addLuaSprite('missOverlay');

	if playerHasSkinOn() then
		setProperty("iconP1.flipX", true);
	end

	baseWindow.x = (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.width') - screenWidth) / 2;
	baseWindow.y = (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.height') - screenHeight) / 2;
end

local windowPosDirty = true;

function onUpdatePost(elapsed)
	local curAnim = getProperty(getPlayerName()..'.animation.curAnim.name');
	local animDetails = getAnimDetails(curAnim);

	if animDetails ~= nil then
		local curFrameDetails = animDetails.frames[getProperty(getPlayerName()..'.animation.curAnim.curFrame')+1];
		setPropertyFromClass('flixel.FlxG', 'stage.window.x', baseWindow.x + curFrameDetails.x);
		setPropertyFromClass('flixel.FlxG', 'stage.window.y', baseWindow.y + curFrameDetails.y);
		setPropertyFromClass('flixel.FlxG', 'stage.window.width', screenWidth + curFrameDetails.width);
		setPropertyFromClass('flixel.FlxG', 'stage.window.height', screenHeight + curFrameDetails.height);
		windowPosDirty = true;
	elseif windowPosDirty then
		setPropertyFromClass('flixel.FlxG', 'stage.window.x', baseWindow.x);
		setPropertyFromClass('flixel.FlxG', 'stage.window.y', baseWindow.y);
		setPropertyFromClass('flixel.FlxG', 'stage.window.width', screenWidth);
		setPropertyFromClass('flixel.FlxG', 'stage.window.height', screenHeight);

		windowPosDirty = false;
	end

	if getPropertyFromClass('flixel.FlxG', 'stage.window.fullscreen') then
		setPropertyFromClass('flixel.FlxG', 'stage.window.fullscreen', false);
	end

	if getPropertyFromClass('flixel.FlxG', 'stage.window.maximized') then
		setPropertyFromClass('flixel.FlxG', 'stage.window.maximized', false);
	end

	setProperty('missOverlay.visible', stringEndsWith(curAnim, 'miss'));
end


function onMoveCamera(character)
	if character == getPlayerName() then
		if getOpponentName() == 'dad' then
			setProperty("camFollow.x", getMidpointX(getOpponentName()) + 150 + getProperty(getOpponentName()..'.cameraPosition[0]') + getProperty(getCameraOffsetName()..'CameraOffset[0]'));
		else
			setProperty("camFollow.x", getMidpointX(getOpponentName()) - 100 - getProperty(getOpponentName()..'.cameraPosition[0]') - getProperty(getCameraOffsetName()..'CameraOffset[0]'));
		end
		setProperty("camFollow.y", getMidpointY(getOpponentName()) - 100 + getProperty(getOpponentName()..'.cameraPosition[1]') + getProperty(getCameraOffsetName()..'CameraOffset[1]'));

		-- for the mods that override camera movement
		local thingy = 0;

		if getOpponentName() == 'dad' then
			thingy = 150;
		else
			thingy = -100;
		end

		setProperty(getPlayerName()..'Group.x', getProperty('camFollow.x') + thingy - 0.5);
		setProperty(getPlayerName()..'Group.y', getProperty('camFollow.y') + 100 - 0.5);
	end
end

function getAnimDetails(name)
	for i=1,#animations do 
		if animations[i].name == name then
			return animations[i];
		end
	end

	return nil;
end

function getPlayerName()
	if playerHasSkinOn() then
		return 'boyfriend';
	else
		return 'dad';
	end
end

function getOpponentName()
	if not playerHasSkinOn() then
		return 'boyfriend';
	else
		return 'dad';
	end
end

function getCameraOffsetName()
	if playerHasSkinOn() then
		return 'boyfriend';
	else
		return 'opponent';
	end
end

function playerHasSkinOn()
	if isRoomConnected() then
		if isSwapSides() then
			return getPlayerSkinName(1) == 'screen';
		else
			return getPlayerSkinName(2) == 'screen';
		end
	else
		return playsAsBF();
	end
end

function onDestroy(name)
	if baseWindow ~= nil then
		setPropertyFromClass('flixel.FlxG', 'stage.window.x', baseWindow.x);
		setPropertyFromClass('flixel.FlxG', 'stage.window.y', baseWindow.y);
		setPropertyFromClass('flixel.FlxG', 'stage.window.width', screenWidth);
		setPropertyFromClass('flixel.FlxG', 'stage.window.height', screenHeight);
	end
end