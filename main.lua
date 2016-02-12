debug = true
require "TEsound"

--// General Data \\--
grid = nil
mainFont = nil
glowShader = nil

--// Menu Data \\--
playButton = {x = love.window:getWidth() / 2, y = 50, w = "Play", over = 1}
settingsButton = {x = love.window:getWidth() / 2, y = 120, w = "Settings", over = 1}
highScoreButton = {x = love.window:getWidth() / 2, y = 190, w = "Score", over = 1}

--// Settings Data \\--
local offsetXTitle = 50
local offsetXButton = love.window:getWidth() / 2
local radius = 30
local angle = math.pi

settingsTitle = {x = love.window:getWidth() / 2, y = 50, w = "Settings"}

musicTitle = {x = offsetXTitle, y = 2 * love.window:getHeight() / 8, w = "Music", over = 1}
musicButton = {x = offsetXButton, y = 2 * love.window:getHeight() / 8 + radius / 2, r = radius, a = angle}

sfxTitle = {x = offsetXTitle, y = 3 * love.window:getHeight() / 8, w = "Sfx", over = 1}
sfxButton = {x = offsetXButton, y = 3 * love.window:getHeight() / 8 + radius / 2, r = radius, a = angle}

voiceTitle = {x = offsetXTitle, y = 4 * love.window:getHeight() / 8, w = "Voice", over = 1}
voiceButton = {x = offsetXButton, y = 4 * love.window:getHeight() / 8 + radius / 2, r = radius, a = angle}

mappingButton = {x = offsetXTitle, y = 5 * love.window:getHeight() / 8, w = "Mapping", over = 1}

quitButton = {x = offsetXTitle, y = 6 * love.window:getHeight() / 8, w = "Quit", over = 1}

--// Mapping Data \\--

-- 1 : left
-- 2 : down
-- 3 : right
-- 4 : up
-- 5 : shoot
-- 6 : switch
keys={{'left', 'a'}, {'down', 's'}, {'right', 'd'}, {'up', 'w'}, {'shoot', 'space'}, {'switch', 'f'}}

mappingTitle = {x = love.window:getWidth() / 2, y = 50, w = "Mapping"}

upTitle = {x = offsetXTitle, y = 2 * love.window:getHeight() / 8, w = "Up :"}
upButton = {x = offsetXButton, y = 2 * love.window:getHeight() / 8, w = keys[4][2], state = false, over = false}

leftTitle = {x = offsetXTitle, y = 3 * love.window:getHeight() / 8, w = "Left :"}
leftButton = {x = offsetXButton, y = 3 * love.window:getHeight() / 8, w = keys[1][2], state = false, over = false}

rightTitle = {x = offsetXTitle, y = 4 * love.window:getHeight() / 8, w = "Right :"}
rightButton = {x = offsetXButton, y = 4 * love.window:getHeight() / 8, w = keys[3][2], state = false, over = false}

downTitle = {x = offsetXTitle, y = 5 * love.window:getHeight() / 8, w = "Down :"}
downButton = {x = offsetXButton, y = 5 * love.window:getHeight() / 8, w= keys[2][2], state = false, over = false}

shootTitle = {x = offsetXTitle, y = 6 * love.window:getHeight() / 8, w = "Shoot :"}
shootButton = {x = offsetXButton, y = 6 * love.window:getHeight() / 8, w = keys[5][2], state = false, over = false}

switchTitle = {x = offsetXTitle, y = 7 * love.window:getHeight() / 8, w = "Switch :"}
switchButton = {x = offsetXButton, y = 7 * love.window:getHeight() / 8, w = keys[6][2], state = false, over = false}

titleMapping = {upTitle, leftTitle, rightTitle, downTitle, shootTitle, switchTitle}
buttonsMapping = {leftButton, downButton, rightButton, upButton, shootButton, switchButton}

--// Game Data \\--
gamemode = 1
previousGamemode = gamemode
musicVolume = 0.5
sfxVolume = 0.5
voiceVolume = 0.5

--// Controls \\--
escapePress = false
escapeCoolDown = 0.2
escapeTimer = escapeCoolDown

left = false
right = false
up = false
down = false

--// Grid Data \\--
grid = {
	image = nil,
	angle = 0,
	zoom = 0,
	speed = 3,
	timeElapsed = 0}

--// Entity Data \\--
timerAnimationMax = 0.5
timerAnimation = timerAnimationMax

--HITBOX
local playerW, playerH = 8, 8
local playerX, playerY = love.window:getWidth() / 2, love.window:getHeight() - 50

bullet = {x = -1, y = -1, speed = 0, angle = 0}
-- define each bullet launched, based on x,y position at origin AND mainAngle at 0rad

weapon1 = {
			name = "straight",
			img = nil,
			shoot = function()
				-- create 3 bullets for player
				local b1 = bullet
				local b2 = bullet
				local b3 = bullet

				-- modify the bullet comportement according to the player and the kind of weapon
	
				table.insert(player.bullets, b1)
				table.insert(player.bullets, b2)
				table.insert(player.bullets, b3)
			end
}

weapon2 = {
			name = "angle",
			img = nil,
			shoot = function()
				local b1 = bullet
				local b2 = bullet
				local b3 = bullet

				-- modify the bullet comportement according to the player and the kind of weapon
	
				table.insert(player.bullets, b1)
				table.insert(player.bullets, b2)
				table.insert(player.bullets, b3)
			end
}

playerWeapon = {weapon1, weapon2}

player = {
	life = 1,
	pv = 3,
	x = playerX,
	y = playerY,
	w = playerW,
	h = playerH,
	speed = 250,
	zoom = 10,
	isShooting = false,
	angle = 0,
	weapon = 1,
	bullets = {}}

basicEnemies = {pv = 4, w = 3, h = 3, zoom = 10, speed = 150, fireRateMax = 1, fireRate = fireRateMax, fireSpeed = 300, bezierTablePoints = {}, bezierIndexTable = 1}
advancedEnemies = {pv = 16, w = 6, h = 3, zoom = 10, speed = 350, fireRateMax = 0.5, fireRate = fireRateMax, fireSpeed = 400, bezierTablePoints = {}, bezierIndexTable = 1}
expertEnemies = {pv = 64, w = 4, h = 4, zoom = 10, speed = 250, fireRateMax = 0.8, fireRate = fireRateMax, fireSpeed = 350, bezierTablePoints = {}, bezierIndexTable = 1}

bosses = {}

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --
--@@@ KEYBOARD/MOUSE EVENT FUNCTION @@@--
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --

function love.keypressed(key)
	if (key == "escape") then
		escapePress = true
	end
	if (key == keys[5][2]) then
		player.isShooting = true
	end
	if (key == keys[1][2]) then
		left = true
	end
	if (key == keys[2][2]) then
		down = true
	end
	if (key == keys[3][2]) then
		right = true
	end
	if (key == keys[4][2]) then
		up = true
	end
	if (key == keys[6][2]) then
		player:switchWeapon()
	end
end

function love.keyreleased(key)
	if (key == "escape") then
		escapePress = false
	end
	if (key == keys[5][2]) then
		player.isShooting = false
	end
	if (key == keys[1][2]) then
		left = false
	end
	if (key == keys[2][2]) then
		down = false
	end
	if (key == keys[3][2]) then
		right = false
	end
	if (key == keys[4][2]) then
		up = false
	end
end

function love.mousepressed(x, y, button)
	if (button == "l") then
		player.isShooting = true
	end
end

function love.mousereleased(x, y, button)
	if (button == "l") then
		player.isShooting = false
	end
end

-- @@@@@@@@@@@@@@@@ --
--@@@ LOVE LOAD  @@@--
-- @@@@@@@@@@@@@@@@ --

function love.load()

	--## SPRITES ##--
	grid.image = love.graphics.newImage("asset/grid.png")
	tileset = love.graphics.newImage("asset/tileset.png")

	local tileW, tileH = 16, 16
	
	weapon1.img = love.graphics.newQuad(0 * tileW, 0 * tileH, tileW, tileH, tileset:getWidth(), tileset:getHeight())
	weapon2.img = love.graphics.newQuad(1 * tileW, 0 * tileH, tileW, tileH, tileset:getWidth(), tileset:getHeight())
	bullet.img = love.graphics.newQuad(2 * tileW, 0 * tileH, tileW, tileH, tileset:getWidth(), tileset:getHeight())

	--## FONT ##--
	mainFont = love.graphics.newFont("font/Tr2n.ttf", 50)

	--## SHADER ##--
	glowShader = love.graphics.newShader("shader/bloomShader2.glsl")

	--## KEY CONFIG ##--
	loadConfigKeys(keys)
end

-- @@@@@@@@@@@@@@@@@@@@@ --
--@@@ UPDATE FUNCTION @@@--
-- @@@@@@@@@@@@@@@@@@@@@ --

function love.update(dt)
	escapeTimer = (escapeTimer <= 0) and 0 or escapeTimer - dt
	--## UPDATE GRID ##--
	grid:rotate(dt)

	--## DETECT GAMEMODE ##--
	if (gamemode == 1) then
		updateTitleMenu(dt)
	elseif (gamemode == 2) then
		updateGame(dt)
	elseif (gamemode == 3) then
		updateSettingMenu(dt)
	elseif (gamemode == 4) then
		updateMapInput()
	end
end

function updateTitleMenu(dt)
	--## KEY EVENT ##--
	if (escapePress and escapeTimer == 0) then
		love.event.quit()
		escapeTimer = escapeCoolDown
	end

	playButton.over = 1
	settingsButton.over = 1
	highScoreButton.over = 1
	previousGamemode = gamemode

	--## MOUSE EVENT ##--
	local mx, my = love.mouse.getPosition()
	if (detectMouseOver({x = mx, y = my}, {x = playButton.x - mainFont:getWidth(playButton.w) / 2, y = playButton.y, w = mainFont:getWidth(playButton.w), h = mainFont:getHeight(playButton.w)})) then
		playButton.over = 0
		if (love.mouse.isDown("l")) then
			gamemode = 2
		end
	elseif (detectMouseOver({x = mx, y = my}, {x = settingsButton.x - mainFont:getWidth(settingsButton.w) / 2, y = settingsButton.y, w = mainFont:getWidth(settingsButton.w), h = mainFont:getHeight(settingsButton.w)})) then
		settingsButton.over = 0
		if (love.mouse.isDown("l")) then
			gamemode = 3
		end
	elseif (detectMouseOver({x = mx, y = my}, {x = highScoreButton.x - mainFont:getWidth(highScoreButton.w) / 2, y = highScoreButton.y, w = mainFont:getWidth(highScoreButton.w), h = mainFont:getHeight(highScoreButton.w)})) then
		highScoreButton.over = 0
	end
end

function updateSettingMenu(dt)
	local mx, my = love.mouse.getPosition()

	musicTitle.over = 1
	sfxTitle.over = 1
	voiceTitle.over = 1
	mappingButton.over = 1
	quitButton.over = 1

	--play song over
	if (detectMouseOver({x = mx, y = my}, {x = musicTitle.x, y = musicTitle.y, w = mainFont:getWidth(musicTitle.w), h = mainFont:getHeight(musicTitle.w)})) then
		musicTitle.over = 0
	elseif (detectMouseOver({x = mx, y = my}, {x = sfxTitle.x, y = sfxTitle.y, w = mainFont:getWidth(sfxTitle.w), h = mainFont:getHeight(sfxTitle.w)})) then
		sfxTitle.over = 0
	elseif (detectMouseOver({x = mx, y = my}, {x = voiceTitle.x, y = voiceTitle.y, w = mainFont:getWidth(voiceTitle.w), h = mainFont:getHeight(voiceTitle.w)})) then
		voiceTitle.over = 0
	elseif (detectMouseOver({x = mx, y = my}, {x = quitButton.x, y = quitButton.y, w = mainFont:getWidth(quitButton.w), h = mainFont:getHeight(quitButton.w)})) then
		quitButton.over = 0
		if (player.isShooting) then
			previousGamemode = gamemode
			gamemode = 1
		end
	elseif (detectMouseOver({x = mx, y = my}, {x = mappingButton.x, y = mappingButton.y, w = mainFont:getWidth(mappingButton.w), h = mainFont:getHeight(mappingButton.w)})) then
		mappingButton.over = 0
		if (player.isShooting) then
			gamemode = 4
		end
	end

	--## BUTTON ##--
	if player.isShooting then
		if detectMouseClickButton(mx, my, musicButton)then
			setAngleButtonFromMouse(mx, my, musicButton)
			musicVolume = getVolumeFromAngle(musicButton.a)
		elseif detectMouseClickButton(mx, my, sfxButton) then
			setAngleButtonFromMouse(mx, my, sfxButton)
			sfxVolume = getVolumeFromAngle(sfxButton.a)
		elseif detectMouseClickButton(mx, my, voiceButton) then
			setAngleButtonFromMouse(mx, my, voiceButton)
			voiceVolume = getVolumeFromAngle(voiceButton.a)
		end
	end

	--## QUIT ##--
	if (escapePress and escapeTimer == 0) then
		previousGamemode, gamemode = gamemode, previousGamemode
		escapeTimer = escapeCoolDown
	end
end

function updateMapInput()
	local mx, my = love.mouse.getPosition()
	local newKeys = {}

	for i, b in ipairs(buttonsMapping) do
		newKeys[i] = manageButton(b, mx, my)
	end

	writeNewKeys(newKeys)

	--## QUIT ##--
	if (escapePress and escapeTimer == 0) then
		gamemode = 3
		escapeTimer = escapeCoolDown
	end
end

function updateGame(dt)
	timerAnimation = (timerAnimation <= 0) and timerAnimationMax or timerAnimation - dt

	--## KEY EVENT ##--
	if (escapePress and escapeTimer == 0) then
		previousGamemode = gamemode
		gamemode = 3
		escapeTimer = escapeCoolDown
	end

	--## DO AN ACCELERATION EFFECT UNTIL 1 ##--
	local moveX = 0 + ((left) and -1 or 0) + ((right) and 1 or 0)
	local moveY = 0 + ((up) and -1 or 0) + ((down) and 1 or 0)
	player:move(moveX, moveY, dt)

	local mouseX, mouseY = love.mouse.getPosition()
	player.angle = math.atan((player.x - mouseX) / (player.y - mouseY))
	player.angle = (mouseY > player.y) and player.angle + math.pi or player.angle

	-- update the bullets accordind to their speed and the orientation
end


-- @@@@@@@@@@@@@@@@@@@ --
--@@@ DRAW FUNCTION @@@--
-- @@@@@@@@@@@@@@@@@@@ --

function love.draw()
	love.graphics.clear(0, 0, 0)

	--## DRAW GRID ##--
	grid:draw()

	--## DETECT GAME MODE ##--
	if (gamemode == 1) then
		drawTitleMenu()
	elseif (gamemode == 2) then
		drawGame()
	elseif (gamemode == 3) then
		drawSettingMenu()
	elseif (gamemode == 4) then
		drawMapInput()
	end
end

function drawTitleMenu()
	--## DRAW TEXT ##--
	love.graphics.setFont(mainFont)

	love.graphics.setColor(150, 255 * playButton.over, 255 * playButton.over)
	love.graphics.printf(playButton.w, playButton.x, playButton.y, 0, "center")
	love.graphics.setColor(150, 255 * settingsButton.over, 255 * settingsButton.over)
	love.graphics.printf(settingsButton.w, settingsButton.x, settingsButton.y, 0, "center")
	love.graphics.setColor(150, 255 * highScoreButton.over, 255 * highScoreButton.over)
	love.graphics.printf(highScoreButton.w, highScoreButton.x, highScoreButton.y, 0, "center")
	love.graphics.setColor(255, 255, 255)
end

function drawSettingMenu()
	--## DRAW TITLE ##--
	love.graphics.setColor(150, 255, 255)
	love.graphics.printf(settingsTitle.w, settingsTitle.x, settingsTitle.y, 0, "center")
	love.graphics.setColor(150, 255 * musicTitle.over, 255 * musicTitle.over)
	love.graphics.printf(musicTitle.w, musicTitle.x, musicTitle.y, 0, "left")
	love.graphics.setColor(150, 255 * sfxTitle.over, 255 * sfxTitle.over)
	love.graphics.printf(sfxTitle.w, sfxTitle.x, sfxTitle.y, 0, "left")
	love.graphics.setColor(150, 255 * voiceTitle.over, 255 * voiceTitle.over)
	love.graphics.printf(voiceTitle.w, voiceTitle.x, voiceTitle.y, 0, "left")
	love.graphics.setColor(150, 255 * mappingButton.over, 255 * mappingButton.over)
	love.graphics.printf(mappingButton.w, mappingButton.x, mappingButton.y, 0, "left")
	love.graphics.setColor(150, 255 * quitButton.over, 255 * quitButton.over)
	love.graphics.printf(quitButton.w, quitButton.x, quitButton.y, 0, "left")
	love.graphics.setColor(255, 255, 255)

	--## DRAW BUTTON ##--
	--## OUTLINE ##--
	love.graphics.setLineWidth(3)
	love.graphics.setColor(150, 150, 150)
	love.graphics.circle("line", musicButton.x, musicButton.y, musicButton.r, 20)
	love.graphics.circle("line", sfxButton.x, sfxButton.y, sfxButton.r, 20)
	love.graphics.circle("line", voiceButton.x, voiceButton.y, voiceButton.r, 20)

	--## INSIDE ##--
	love.graphics.setLineWidth(2)
	love.graphics.setColor(150, 255, 255)
	--## ANGLE IN MINUS ##--
	love.graphics.arc("fill", musicButton.x, musicButton.y, musicButton.r, 0, -musicButton.a, 20)
	love.graphics.arc("fill", sfxButton.x, sfxButton.y, sfxButton.r, 0, -sfxButton.a, 20)
	love.graphics.arc("fill", voiceButton.x, voiceButton.y, voiceButton.r, 0, -voiceButton.a, 20)

	--## CENTER ##--
	local r = 10
	love.graphics.setColor(100, 100, 100)
	love.graphics.circle("fill", musicButton.x, musicButton.y, 10, 20)
	love.graphics.circle("fill", sfxButton.x, sfxButton.y, 10, 20)
	love.graphics.circle("fill", voiceButton.x, voiceButton.y, 10, 20)

	love.graphics.setColor(255, 255, 255)
end

function drawMapInput()
	love.graphics.setColor(150, 255, 255)

	love.graphics.printf(mappingTitle.w, mappingTitle.x, mappingTitle.y, 0, "center")
	for i, t in ipairs(titleMapping) do
		love.graphics.printf(t.w, t.x, t.y, mainFont:getWidth(t.w), "left")
	end
	for i, b in ipairs(buttonsMapping) do
		buttonMappingDraw(b)
	end

	love.graphics.setColor(255, 255, 255)
end

function drawGame()
	player:draw()

	-- HUD
	local tileW, tileH = 32, love.window:getHeight() - 32
	local tileW, tileH = 16, 16
	local oX, oY = 32, love.window:getHeight() - 32

	-- draw weapon symbols
	for i, w in ipairs(playerWeapon) do
		if (player.weapon == i) then
			love.graphics.setLineWidth(2)
			love.graphics.circle("line", i * oX + tileW / 2, oY + tileH / 2, tileW, 20)
			love.graphics.setLineWidth(1)
		end
		love.graphics.draw(tileset, w.img, i * oX, oY)
	end
	-- draw a selecter of weapon

end


-- @@@@@@@@@@@@@@@@@@@@@@@@@@ --
--@@@ KEY CONFIG FUNCTIONS @@@--
-- @@@@@@@@@@@@@@@@@@@@@@@@@@ --

function loadConfigKeys(keys)
	f = io.open("conf/keys.conf", "r")
	if (not f) then
		print("Keyboard config file missing\nGenerating a new one...")
		nf = assert(io.open("conf/keys.conf", "w+"))
		nf:write("left=a\nright=d\nup=w\ndown=s\nshoot=space\nswitch=f")
		nf:close()
		print("Done")
	else
		l = f:read()
		while (l) do
			local actual = l:sub(0, l:find("=") - 1)

			for i,k in ipairs(keys) do
				if k[1] == string.lower(actual) then
					local nK = l:sub(l:find("=") + 1, #l)
					k[2] = nK
					buttonsMapping[i].w = k[2]
				end
			end
			l = f:read()
		end
	end
	return(keys)
end

function writeNewKeys(table)
	f = io.open("conf/keys.conf", "w+")
	if (not f) then
		print("Keyboard config file missing\nGenerating a new one...")
		nf = assert(io.open("conf/keys.conf", "w+"))
		nf:write("left=a\nright=d\nup=w\ndown=s\nshoot=space\nswitch=f")
		nf:close()
		print("Done")
	else
		for i, k in ipairs(table) do
			if k then
				keys[i][2] = k
			end
			f:write(keys[i][1] .. "=" .. keys[i][2] .. '\n')
		end
		f:close()
	end
end

-- @@@@@@@@@@@@@@@@@@@@@@ --
--@@@ BUTTON FUNCTIONS @@@--
-- @@@@@@@@@@@@@@@@@@@@@@ --

function manageButton(button, mx, my)
	button.over = false
	local touch = '"' .. button.w:sub(0, 3) .. '"'

	if (detectMouseOver({x = mx, y = my}, {x = button.x, y = button.y, w = mainFont:getWidth(touch), h = mainFont:getHeight(touch)})) then
		button.over = true
		if (player.isShooting) then
			if (button.state) then
				e, a, b, c, d = love.event.wait()
				while (e ~= "keypressed" or a == "escape") do
					e, a, b, c, d = love.event.wait()
				end
				button.w = a
				-- must force reinit of click
				player.isShooting = false
				button.state = false
				return (a)
			end
			button.state = true
		end
	end
	return (false)
end

function buttonMappingDraw(button)
	local r, g, b, a = love.graphics.getColor()
	local margin = 10
	local touch = '"' .. button.w:sub(0, 3) .. '"'

	local offsetX = mainFont:getWidth(touch)
	local offsetY = mainFont:getHeight(touch) + margin

	if button.over then
		if (not button.state) then
			love.graphics.setColor(50, 255, 50)
		else
			love.graphics.setColor(255, 50, 50)
		end
		love.graphics.setLineWidth(4)
		love.graphics.line(button.x, button.y + offsetY, button.x + offsetX, button.y + offsetY)
	end
	love.graphics.setLineWidth(3)
	love.graphics.setColor(150, 200, 200)
	love.graphics.printf(touch, button.x, button.y, mainFont:getWidth(touch), "left")

	love.graphics.setColor(r, g, b, a)
end

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --
--@@@ PERSONNAL DRAW FUNCTIONS @@@--
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --

function fadedCircle(x, y, radius, segments, distFade)
	local r, g, b, a = love.graphics.getColor()
	local i
	local alpha
	distFade = distFade * 2

	love.graphics.setLineWidth(1)
	for i=1,radius,1 do
		if (i <= (radius - distFade)) then
			alpha = 255
		else
			alpha = 255 * (radius - i) / distFade
		end
		love.graphics.setColor(r, g, b, alpha)
		love.graphics.circle("line", x, y, i, segments)
	end
	love.graphics.setColor(r, g, b, a)
end

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --
--@@@ MOUSE DETECTION FUNCTIONS @@@--
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --

function detectMouseOver(mousePos, button)
	if (mousePos.x >= button.x and mousePos.x <= button.x + button.w and mousePos.y >= button.y and mousePos.y <= button.y + button.h) then
		return true
	end
	return false
end

function detectMouseClickButton(mx, my, button)
	if (math.pow(mx - button.x, 2) + math.pow(my - button.y, 2) <= math.pow(button.r, 2)) then
		return true
	end
	return false
end

function getVolumeFromAngle(angle)
	local marginEasing = 10
	return (angle / math.pi - (marginEasing * math.pi/180))
end

function setAngleButtonFromMouse(mx, my, button)
	button.a = math.atan((button.x - mx) / (button.y - my)) + math.pi / 2
	button.a = (my > button.y) and button.a + math.pi or button.a
end

-- @@@@@@@@@@@@@@@@@@@ --
--@@@ PLAYER METHOD @@@--
-- @@@@@@@@@@@@@@@@@@@ --

function player:switchWeapon()
	player.weapon = player.weapon + 1
	if (player.weapon > 2) then
		player.weapon = 1
	end
end

function player:verticesPlayer()
	local init = {0, - 3 * self.zoom,
			- 1 * self.zoom, - 1 * self.zoom,
			- 1.5 * self.zoom, - 1.5 * self.zoom,
			- 2 * self.zoom, - 1 * self.zoom,
			- 2 * self.zoom, 1 * self.zoom,
			0, 2 * self.zoom,
			2 * self.zoom, 1 * self.zoom,
			2 * self.zoom, - 1 * self.zoom,
			1.5 * self.zoom, - 1.5 * self.zoom,
			1 * self.zoom, - 1 * self.zoom}

	local final = {}
	local angle = -self.angle

	for i,p in ipairs(init) do
		if (i % 2 == 0) then
		--y' = y cos f + x sin f
			-- do a rotation
			local rot =  p * math.cos(angle) + init[i - 1] * math.sin(angle)
			-- go to player position
			p = rot + self.y
			table.insert(final, p)
		else
		--x' = x cos f - y sin f
			local rot = p * math.cos(angle) - init[i + 1] * math.sin(angle)
			-- go to player position
			p = rot + self.x
			table.insert(final, p)
		end
	end
	return final
end

function player:move(x, y, dt)
	self.x = self.x + x * self.speed * dt
	self.y = self.y + y * self.speed * dt

	--## FOLLOWING SCREEN ##--
	if (self.x < 0) then
		self.x = love.window:getWidth()
	elseif (self.x > love.window:getWidth()) then
		self.x = 0
	end
	if (self.y < 0) then
		self.y = love.window:getHeight()
	elseif (self.y > love.window:getHeight()) then
		self.y = 0
	end
end

function player:draw()
	love.graphics.setLineWidth(3)
	love.graphics.setColor(150, 255, 255)
	love.graphics.polygon("line", player:verticesPlayer())

	love.graphics.setColor(150, 0, 0)
	love.graphics.setLineWidth(2)
	fadedCircle(self.x, self.y, self.w * 2, 4, self.w)

	love.graphics.setColor(255, 255, 255)
	love.graphics.setLineWidth(1)
end

-- @@@@@@@@@@@@@@@@@ --
--@@@ GRID METHOD @@@--
-- @@@@@@@@@@@@@@@@@ --

function grid:rotate(dt)
	self.timeElapsed = self.timeElapsed + dt
	if (math.cos(0) == math.cos(self.timeElapsed)) then
		self.timeElapsed = 0
	end
	self.angle = self.angle + (self.speed * dt)
	self.zoom = 1.5 + (math.cos(self.timeElapsed / 3) - math.cos(math.pi)) / 3
end

function grid:draw()
	love.graphics.setShader(glowShader)
	love.graphics.draw(self.image, love.window:getWidth() / 2, love.window:getHeight() / 2, self.angle * math.pi / 180, self.zoom, self.zoom, self.image:getWidth() / 2, self.image:getHeight() / 2)
	love.graphics.setShader()
end
