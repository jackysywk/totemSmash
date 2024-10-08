
local composer = require( "composer" )

local scene = composer.newScene()
local unityads = require("plugin.unityads.v4")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    composer.gotoScene("game")
end

local function gotoHighScores()
    composer.gotoScene("highscores")
end

local function adListener( event )
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.provider )
    unityads.load("Interstitial_Android")
    end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    unityads.init( adListener, { gameId="5541299" } )
	local sceneGroup = self.view
    mainGroup = display.newGroup()

	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect(sceneGroup,"asset/image/background.png",480,1100)
    background.alpha = 0.5
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	local otherText = display.newText( sceneGroup, "Totem Smasher!", display.contentCenterX, 300, native.systemFont, 50 )
    otherText:setFillColor( 0.82, 0.86, 1 )
	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 600, native.systemFont, 44 )
    playButton:setFillColor( 0.82, 0.86, 1 )
    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 700, native.systemFont, 44 )
    highScoresButton:setFillColor( 0.82, 0.86, 1 )
    playButton:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener("tap",gotoHighScores)
    -- Initialize the Unity Ads plugin




end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        if (unityads.isLoaded("Interstitial_Android")) then
            unityads.show("Interstitial_Android")
        end
    

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        if (unityads.isLoaded("Interstitial_Android")) then
            unityads.show("Interstitial_Android")
        end
    
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("menu")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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