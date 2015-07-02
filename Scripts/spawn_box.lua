--<<Show spawn boxes blocking areas>>
require("libs.Utils")

spots = {
	{2240,-4288,3776,-5312},{2688,-2944, 3776,-4096,183},
	{1088,-3200,2304,-4544},{-3530,768,-2560,-256,183},
	{-1026,-2368,62,-3451},{-1728,-3522,-706,-4478,55},
	{-3459,4928,-2668,3968,183},{-5056, 4352,-3712, 3264},
	{3390,-105,4739,-1102},{-1921,3138,-964,2308},
	{-832,4098,-3,3203,183},{447,3778,1659,2822,183}
}

play, eff, eff1, eff2, eff3, eff4 = false, {}, {}, {}, {}, {}

function FRAME()
    if not PlayingGame() then return end
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
				eff[i].eff1[a] = Effect(first,"candle_flame_medium")
				eff[i].eff1[a]:SetVector(0,GetVector(first,k[5]))				
				eff[i].eff3[a] = Effect(second,"candle_flame_medium")
				eff[i].eff3[a]:SetVector(0,GetVector(second,k[5]))
			end
			for a = 1,coint2 do		
				local first = Vector(k[1], k[4]+a*50, 0)
				local second = Vector(k[3], k[4]+a*50, 0)				
				eff[i].eff2[a] = Effect(first,"candle_flame_medium")
				eff[i].eff2[a]:SetVector(0,GetVector(first,k[5]))				
				eff[i].eff4[a] = Effect(second,"candle_flame_medium")
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
		script:RegisterEvent(EVENT_FRAME,FRAME)
		script:UnregisterEvent(Load)
	end
end

function Close()
	spots, eff, eff1, eff2, eff3, eff4 = {}, {}, {}, {}, {}, {}
	collectgarbage("collect")
	if play then
		script:UnregisterEvent(FRAME)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,Close)
