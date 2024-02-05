-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
local unityads = require("plugin.unityads.v4")


local function adListener( event )
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.provider )
    
    end
end
unityads.init( adListener, { gameId="5541299", testMode=false } )

composer.gotoScene("menu")