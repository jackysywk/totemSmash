
local composer = require( "composer" )

local scene = composer.newScene()
local unityads = require("plugin.unityads.v4")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function showads()
    if (unityads.isLoaded("Interstitial_Android")) then
        unityads.show("Interstitial_Android")
    else 
        unityads.load("Interstitial_Android")
    end
end
local function gotoMenu()
    showads()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
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
    local title = display.newText( sceneGroup, "Game Over", display.contentCenterX, display.contentCenterY, native.systemFont, 50 )
    title:setFillColor( 0.82, 0.86, 1 )
    local menuButton = display.newText( sceneGroup, "Main Menu", display.contentCenterX, display.contentCenterY+100, native.systemFont, 40 )
    menuButton:setFillColor( 0.82, 0.86, 1 )
    menuButton:addEventListener("tap", gotoMenu)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
        composer.removeScene("gameover")
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