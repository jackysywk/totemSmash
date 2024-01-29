
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
local physics = require( "physics" )
physics.start()
--physics.setDrawMode("hybrid")
physics.setGravity( 0, 100 )
local totemTable = {}

local mainGroup
local lives = 3
local timeSpent = 0
local red_button
local green_button
local blue_button
local numTotem = 50

-- sound track
local climbSound
local wrongSound
local whistleSound
local failSound

local function updateText()
    livesText.text = "Lives: " .. lives
end

local function updateTime(event)
    timeSpent = timeSpent+0.1
    timeText.text = string.format("Time: %.1f", timeSpent)
end


local function createTotem()
    local totemSeed = math.random(3)
    local colorSeed = math.random(3)
    local color
    if (colorSeed == 1) then
        color = "red"
    elseif (colorSeed == 2) then
        color = "blue"
    elseif (colorSeed == 3) then 
        color = "green"
    end
    local filename = string.format("asset/image/totem/%s_%s.png", color, totemSeed)

    local newTotem = display.newImageRect(mainGroup, filename, 200,80)
    newTotem.myName=string.format("%s_totem",color)
    newTotem.x = display.contentCenterX
    newTotem.y = display.actualContentHeight-(110)*(#totemTable+1)

    table.insert(totemTable, newTotem)

    physics.addBody(newTotem, "dynamic" ,{friction=10, bounce=0, density=100})
end

local function endGame()
    audio.play(whistleSound)
    composer.setVariable("finalScore", timeSpent)
    composer.gotoScene("highscores", {time=800, effect="crossFade"})
end

local function gameOver()
    audio.play(failSound)
    composer.gotoScene("gameover",  {time=800, effect="crossFade"})
end
local function nextStep()
    if (lives == 0) then
        gameOver()
    end
    if (numTotem >0) then
        createTotem()
        numTotem = numTotem - 1
    elseif (numTotem==0) then
        if (#totemTable == 0) then
           endGame()
        end
    end
end



local function pressRedButton()
    totemColor = totemTable[1].myName
    if (totemColor == "red_totem")
    then
        audio.play(climbSound)
        display.remove(totemTable[1])
        table.remove(totemTable,1)
        
    else
        audio.play(wrongSound)
        lives = lives - 1
        
    end 
    updateText()
    nextStep()
end
local function pressGreenButton()
    totemColor = totemTable[1].myName
    if (totemColor == "green_totem")
    then
        audio.play(climbSound)
        display.remove(totemTable[1])
        table.remove(totemTable,1)
    else
        audio.play(wrongSound)
        lives = lives - 1
    end 
    updateText()
    nextStep()
end
local function pressBlueButton()
    totemColor = totemTable[1].myName
    if (totemColor == "blue_totem")
    then
        audio.play(climbSound)
        display.remove(totemTable[1])
        table.remove(totemTable,1)
    else
        audio.play(wrongSound)
        lives = lives - 1
    end 
    updateText()
    nextStep()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

    -- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group
    
    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
    
    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect(backGroup,"asset/image/background.png",480,1100)
    background.alpha = 0.5
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    livesText = display.newText(uiGroup, "Lives: "..lives, 60,80, native.systemFont, 30)
    timeText = display.newText(uiGroup, string.format("Time: %.1f", timeSpent),400,80,native.systemFont,30)
    local verticalBarrierA = display.newRect(display.contentCenterX-110, display.contentCenterY+50, 10, display.actualContentHeight+300)
    local verticalBarrierB = display.newRect(display.contentCenterX+110, display.contentCenterY+50,10, display.actualContentHeight+300)
    verticalBarrierA.alpha=0
    verticalBarrierB.alpha=0
    physics.addBody(verticalBarrierA, "static", {bounce=0})
    physics.addBody(verticalBarrierB, "static", {bounce=0})
    red_button = display.newImageRect(uiGroup, "asset/image/button/red_button.png", 160,120)
    green_button = display.newImageRect(uiGroup, "asset/image/button/green_button.png", 160,120)
    blue_button = display.newImageRect(uiGroup, "asset/image/button/blue_button.png", 160,120)

    red_button.x = display.contentCenterX-160
    red_button.y = display.actualContentHeight-70
    green_button.x = display.contentCenterX
    green_button.y = display.actualContentHeight-70
    blue_button.x = display.contentCenterX+160
    blue_button.y = display.actualContentHeight-70
    physics.addBody(red_button,"static", {friction=10, bounce=0})
    physics.addBody(green_button,"static", {friction=10, bounce=0})
    physics.addBody(blue_button,"static", {friction=10, bounce=0})

    red_button:addEventListener("tap",pressRedButton)
    green_button:addEventListener("tap",pressGreenButton)
    blue_button:addEventListener("tap",pressBlueButton)


    climbSound = audio.loadSound("asset/audio/hey.wav")
    wrongSound = audio.loadSound("asset/audio/wrong.wav")
    whistleSound = audio.loadSound("asset/audio/whistle.wav")
    failSound = audio.loadSound("asset/audio/fail.wav")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        for i=1,12,1 
        do
            createTotem()
        end
        self.timeHandle = timer.performWithDelay(100, updateTime, 0)

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        if self.timerHandle then
            time.cancel(self.timerHandle)
        end
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("game")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
    timer.performWithDelay(5000,audio.dispose(climbSound))
    timer.performWithDelay(5000,audio.dispose(wrongSound))
    timer.performWithDelay(5000,audio.dispose(whistleSound))
    timer.performWithDelay(5000,audio.dispose(failSound))


end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene