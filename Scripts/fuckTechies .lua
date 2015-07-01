text = drawMgr:CreateText(client.screenSize.x/2.34,client.screenSize.y/17,0xD10A0A80,"Techies shit is nearby you.",drawMgr:CreateFont("manabarsFont","Arial",26,600)) text.visible = false

function Frame() 
	if not PlayingGame() then return end 
	local mins = entityList:GetEntities({classId=CDOTA_NPC_TechiesMines})
	for i,v in ipairs(mins) do
		if v.team ~= team then
			if v.alive and GetDistance2D(entityList:GetMyHero(),v[1]) <= 800 then
				text.visible = true
			else
				text.visible = false
			end
		end
	end
end
 
script:RegisterEvent(EVENT_TICK,Frame)