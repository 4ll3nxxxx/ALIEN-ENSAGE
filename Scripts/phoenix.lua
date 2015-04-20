require("libs.Utils")

local play,Toggle,Toggle_1 = false,false,false

local angle = 30 -- if the angle between the target and the hero is more then 30* phoenix stopsю
local distance = 600 -- min distance for move

function Tick(tick)
	if not PlayingGame() then return end
    local me = entityList:GetMyHero() local forward = FindMove(me)
	if forward ~= nil then
		if me:DoesHaveModifier("modifier_phoenix_sun_ray") then
			play = true
			local target = nil		
			if test then
				target = entityList:GetEntity(test.handle)
			end			
			if target then
				if (target.activity == LuaEntityNPC.ACTIVITY_MOVE and ToFace(target,me)) or target:GetDistance2D(me) > distance or not target.visible then
					if not (forward and toggle) then
						me:CastAbility(me:GetAbility(4))
						toggle,toggle_1 = true,false					
					end
					me:Follow(target)					
				else 
					if forward and not toggle_1 then
						me:CastAbility(me:GetAbility(4))
						toggle,toggle_1 = false,true
					end
					me:Follow(target)
				end
			end
		elseif play then
			play,toggle,toggle_1 = false,false,false
		end
		
	end
	Sleep(250)	
end

function Key(msg)
	if msg == RBUTTON_DOWN and play then		
		test = entityList:GetMouseover()
	elseif not play then
		test = nil
	end
end

function FindMove(me)
	if not p then 
		a1 = me.position 
		p = true 
	else 
		a2 = me.position
		p = false
	end
	if a1 == a2 then 
		return false
	else
		return true
	end
	return nil
end

function ToFace(my,t_)
	if ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi >= (360-angle) or ((FindAngle(my,t_)) % (2 * math.pi)) * 180 / math.pi <= angle then
		return true
	end
	return false
end

function FindAngle(my,t_)
	return ((math.atan2(my.position.y-t_.position.y,my.position.x-t_.position.x) - t_.rotR + math.pi) % (2 * math.pi)) - math.pi
end

function Load()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if me.classId ~= CDOTA_Unit_Hero_Phoenix then 
			script:Disable() 
		else
			play = true
			script:RegisterEvent(EVENT_KEY,Key)
			script:RegisterEvent(EVENT_TICK,Tick)
			script:UnregisterEvent(Load)
		end
	end	
end

function Close()
	Toggle,Toggle_1 = false,false
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_CLOSE,Close)
script:RegisterEvent(EVENT_TICK,Load)
