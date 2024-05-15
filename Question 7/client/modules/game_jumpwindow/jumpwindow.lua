jumpWindow = nil
jumpButton = nil
buttonSlideEvent = nil

function init()
  g_ui.importStyle('jumpwindow')

  connect(g_game, { onGameStart = create,
                    onGameEnd = destroy })
	
  g_keyboard.bindKeyDown('J', toggle) -- bind 'J' key to toggle window
end

function terminate()
  disconnect(g_game, { onGameStart = create,
                       onGameEnd = destroy })

  g_keyboard.unbindKeyDown('J')	
  destroy()
end

function toggle() -- either hide window and cancel button sliding or show window and restart button sliding
  if jumpWindow:isVisible() then
    jumpWindow:hide()
	buttonSlideEvent:cancel()
  else
    jumpWindow:show()
	buttonSlideEvent = cycleEvent(function() slideButtonLeft() end, 50)
  end
end

function moveButton() -- linked to button @onClick in .otui file
  local windowPos = jumpWindow:getPosition()
  local buttonPos = jumpButton:getPosition()
  local distFromTop = buttonPos.y - windowPos.y - 40 -- distance between button and top of window
  local distFromBottom = windowPos.y + jumpWindow:getHeight() - buttonPos.y - 15 -- distance between button and bottom of window
  local randYMove = math.random(-distFromTop, distFromBottom) -- get value for randomly moving the button to a different height within the window
  
  buttonPos.y = buttonPos.y + randYMove
  
  jumpButton:breakAnchors() -- allow button to move
  jumpButton:setPosition(buttonPos)
  jumpButton:addAnchor(AnchorRight, 'parent', AnchorRight) -- move button back to right side
end

function slideButtonLeft()
  local buttonPos = jumpButton:getPosition()
  local windowPos = jumpWindow:getPosition()
  
  buttonPos.x = buttonPos.x - 7

  jumpButton:breakAnchors() -- allow button to move
  jumpButton:setPosition(buttonPos)
  
  if buttonPos.x < windowPos.x + 10 then -- call moveButton when button reaches left side of window
    moveButton()
  end
end

function create()
  jumpWindow = g_ui.createWidget('JumpWindow', rootWidget)
  jumpButton = jumpWindow:getChildById('jumpButton')

  local buttonPos = jumpButton:getPosition()
  local windowPos = jumpWindow:getPosition()

  buttonSlideEvent = cycleEvent(function() slideButtonLeft() end, 50) -- continuously slide button left, store as variable to allow cancelling
end

function destroy()
  if jumpButton then
    jumpButton:destroy()
	jumpButton = nil
  end
  
  if jumpWindow then
    jumpWindow:destroy()
	jumpWindow = nil	
  end
  
  if buttonSlideEvent and buttonSlideEvent:isExecuted() then
    buttonSlideEvent:cancel()
  end
  
  buttonSlideEvent = nil
end