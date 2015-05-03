local MapLeft = -8000
local MapTop = 7350
local MapRight = 7500
local MapBottom = -7200
local MapWidth = math.abs(MapLeft - MapRight)
local MapHeight = math.abs(MapBottom - MapTop)

ResTable = {
	-- Settings for 4:3
	{800,600,{
		minimap    = {px = 4, py = 5, h = 146, w = 151},
		}
	},
	{1024,768,{
		minimap    = {px = 5, py = 7, h = 186, w = 193},
		}
	}, 
	{1152,864,{
		minimap    = {px = 6, py = 7, h = 211, w = 217},
		}
	},
	{1280,960,{
		minimap    = {px = 6, py = 9, h = 235, w = 241},
		}
	},
	{1280,1024,{
		minimap    = {px = 6, py = 9, h = 229, w = 255},
		}
	},
	{1600,1200,{
		minimap    = {px = 8, py = 14, h = 288, w = 304},
		}
	},
	-- Settings for 16:9
	{1280,720,{
		minimap    = {px = 8, py = 8, h = 174, w = 181},
		}
	},
	{1360,768,{
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1366,768,{
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1600,900,{
		minimap    = {px = 9, py = 9,  h = 217, w = 232},
		}
	},
	{1920,1080,{
		minimap    = {px = 11, py = 11, h = 261, w = 272},
		}
	},
	{2560,1440,{
		minimap    = {px = 12, py = 12, h = 341, w = 372},
		}
    },
	-- Settings for 16:10
	{1024,600,{
		minimap    = {px = 8, py = 8, h = 146, w = 151},
		}
	},
	{1280,768,{
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		}
	},
	{1280,800,{
		minimap    = {px = 8, py = 10, h = 192, w = 203},
		}
	},
	{1440,900,{
		minimap    = {px = 9, py = 9, h = 217, w = 227},
		}
	},
	{1680,1050,{
		minimap    = {px = 10, py = 11, h = 252, w = 267},
		}
	},
	{1920,1200,{
		minimap    = {px = 12, py = 14, h = 288, w = 304},
		}
	},
	{2560,1600,{
		minimap    = {px = 27, py = 28, h = 356, w = 391},
		}
	},
	{2880,1800,{
		minimap    = {px = 37, py = 38, h = 396, w = 430},
		}
	},
}

function MapToMinimap(x, y)
	_x = x - MapLeft
	_y = y - MapBottom
    
    local scaledX = math.min(math.max(_x * MinimapMapScaleX, 0), location.minimap.w)
    local scaledY = math.min(math.max(_y * MinimapMapScaleY, 0), location.minimap.h)
    
    local screenX = location.minimap.px + scaledX
    local screenY = screenSize.y - scaledY - location.minimap.py

    return Vector2D(math.floor(screenX),math.floor(screenY))
end

do
    screenSize = client.screenSize
    if screenSize.x == 0 and screenSize.y == 0 then
	print("ensage can't determine your screen resolution, try to launch in window mode")
    end
    for i,v in ipairs(ResTable) do
	if v[1] == screenSize.x and v[2] == screenSize.y then
		location = v[3]
		break
	elseif i == #ResTable then
		print("res.lua don't support you resolution")
		break
	end
    end

end

MinimapMapScaleX = location.minimap.w / MapWidth
MinimapMapScaleY = location.minimap.h / MapHeight
