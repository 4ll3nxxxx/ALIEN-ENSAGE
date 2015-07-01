text = drawMgr:CreateText(client.screenSize.x/2.34,client.screenSize.y/17,0xD10A0A80,"Techies shit is nearby you.",drawMgr:CreateFont("manabarsFont","Arial",26,600)) text.visible = false

function Frame() 
	if not PlayingGame() then return end 
	local mins = entityList:GetEntities(function (v) return (v.classId == CDOTA_BaseNPC_Additive and v.team ~= entityList:GetMyHero().team and v.alive == true and (v.name == "npc_dota_techies_land_mine" or  v.name == "npc_dota_techies_remote_mine" or v.name == "npc_dota_techies_stasis_trap")) end)[1]
	if entityList:GetMyHero().visibleToEnemy and GetDistance2D(entityList:GetMyHero(),mins) <= 800 then
		text.visible = true
	else
		text.visible = false
	end       
end
 
script:RegisterEvent(EVENT_TICK,Frame)