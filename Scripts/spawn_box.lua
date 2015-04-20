--<<Show spawn boxes blocking areas>>
require("libs.Utils")

local play = false

local spots = {
--radian
{2240,-4288,3776,-5312}, -- easy
{2688,-2944, 3776,-4096,183}, -- medium near rune 184
{1088,-3200,2304,-4544}, -- hard near rune
{-3530,768,-2560,-256,183}, -- ancient
{-1026,-2368,62,-3451}, -- medium camp
{-1728,-3522,-706,-4478,55}, -- hard camp

--dire
{-3459,4928,-2668,3968,183}, -- easy
{-5056, 4352,-3712, 3264}, -- hard pull
{3390,-105,4739,-1102}, -- ancient
{-1921,3138,-964,2308}, -- camp by rune
{-832,4098,-3,3203,183}, -- medium camp
{447,3778,1659,2822,183} -- hard camp by mid
}

local eff = {}
local eff1 = {}
local eff2 = {}
local eff3 = {}
local eff4 = {}

function Tick(tick)
    if not PlayingGame() then return end
    local me = entityList:GetMyHero()
    local effec = "origin_gizmo"
	for i,k in ipairs(spots) do
		if not eff[i] then
			local coint1 = math.floor(math.floor(k[3]-k[1])/50)
			local coint2 = math.floor(math.floor(k[2]-k[4])/50)
			eff[i] = {}		

			for a = 1,math.max(coint1,coint2) do
				eff[i].eff1 = {} eff[i].eff2 = {}	
				eff[i].eff3 = {} eff[i].eff4 = {}
			end		
			
			for a = 1,coint1 do				
				local first = Vector(k[1]+a*50, k[4], 0)
				local second = Vector(k[1]+a*50, k[2], 0)				
				eff[i].eff1[a] = Effect(first,effec)
				eff[i].eff1[a]:SetVector(0,GetVector(first,k[5]))				
				eff[i].eff3[a] = Effect(second,effec)
				eff[i].eff3[a]:SetVector(0,GetVector(second,k[5]))
			end
			
			for a = 1,coint2 do		
				local first = Vector(k[1], k[4]+a*50, 0)
				local second = Vector(k[3], k[4]+a*50, 0)				
				eff[i].eff2[a] = Effect(first,effec)
				eff[i].eff2[a]:SetVector(0,GetVector(first,k[5]))				
				eff[i].eff4[a] = Effect(second,effec)
				eff[i].eff4[a]:SetVector(0,GetVector(second,k[5]))
			end	
		end
	end
end

function GetVector(Vec,zet)
	local retVector = Vec
	client:GetGroundPosition(retVector)	
	if not zet or (zet and math.floor(retVector.z) == zet) then
		return retVector
	end 
	return Vector(-10000,-10000,-100)
end

function Load()
	if PlayingGame() then
		play = true
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function Close()
	eff = {}
	eff1 = {}
	eff2 = {}
	eff3 = {}
	eff4 = {}
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
