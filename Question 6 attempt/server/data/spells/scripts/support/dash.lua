local DASH_DISTANCE = 6

local function dash(playerId, direction, stepsRemaining)
    local player = Player(playerId)
	
    if player then
        local pos = player:getPosition()
		pos:getNextPosition(direction) -- get target of step
		local tile = Tile(pos)
		
		-- continue dash if next tile is clear
		if tile:isWalkable() then
			player:teleportTo(pos, false) -- take step
			
            -- queue up next step if dash isn't finished
			if stepsRemaining > 1 then  
				addEvent(dash, 100, playerId, direction, stepsRemaining - 1)
			end
		else
			player:sendCancelMessage("You can't dash any further.")
		end
    end
end

function onCastSpell(creature, variant)
    dash(creature:getId(), creature:getDirection(), DASH_DISTANCE)
	
	return true
end