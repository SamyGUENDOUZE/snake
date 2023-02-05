local cellSize  = 20 -- Width and height of cells.
local gridLines = {}

local windowWidth, windowHeight = love.graphics.getDimensions()

-- Vertical lines.
for x = cellSize, windowWidth, cellSize do
	local line = {x, 0, x, windowHeight}
	table.insert(gridLines, line)
end
-- Horizontal lines.
for y = cellSize, windowHeight, cellSize do
	local line = {0, y, windowWidth, y}
	table.insert(gridLines, line)
end

function grid_draw()
	love.graphics.setColor(love.math.colorFromBytes(30,144,255))
	love.graphics.setLineWidth(1)  -- épaisseur de la ligne

	for i, line in ipairs(gridLines) do
		love.graphics.line(line)
	end
end