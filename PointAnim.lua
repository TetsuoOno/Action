local resultData = {}

resultData.options = {
	frames = {
		-- point_1.png
		{
			x = 0,
			y = 0,
			width = 100,
			height = 100,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 100,
			sourceHeight = 100,
		},
		-- point_2.png
		{
			x = 100,
			y = 0,
			width = 100,
			height = 100,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 100,
			sourceHeight = 100,
		},
		-- point_3.png
		{
			x = 0,
			y = 100,
			width = 100,
			height = 100,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 100,
			sourceHeight = 100,
		},
		-- point_4.png
		{
			x = 100,
			y = 100,
			width = 100,
			height = 100,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 100,
			sourceHeight = 100,
		},
	},
	sheetContentWidth = 200,
	sheetContentHeight = 200
}

resultData.sequences = {
    	{ name="PointAnim", frames={  1,  2,  3,  4,  }, time=400 },
}

resultData.indexDictionary = {
	["point_1.png"] = 1,
	["point_2.png"] = 2,
	["point_3.png"] = 3,
	["point_4.png"] = 4,
}

function resultData:getIndexByName(name)
    return self.indexDictionary[name];
end

return resultData