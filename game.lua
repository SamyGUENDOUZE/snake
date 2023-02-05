-- machine à état
GameStates = {pause='pause', running='running', game_over='game over'}
state = GameStates.running

local snakeX = 20
local snakeY = 20
local dirX = 0
local dirY = 0

local SIZE = 20

local appleX = 0
local appleY = 0

local tail = {}

tail_length = 0
up = false
down = false
left = false
right = false

function add_apple() 
  appleX = math.random(SIZE-1)
  appleY = math.random(SIZE-1)
end

function game_draw()
    -- propriétés de la tête du serpent
    love.graphics.setColor(love.math.colorFromBytes(0,100,0)) 
    love.graphics.rectangle('fill', snakeX*SIZE, snakeY*SIZE, SIZE, SIZE)

    -- propriétés de la queue du serpent
    love.graphics.setColor(love.math.colorFromBytes(50,205,50))
    for _, v in ipairs(tail) do
        love.graphics.rectangle('fill', v[1]*SIZE, v[2]*SIZE, SIZE, SIZE)
    end

    -- propriétés de la pomme
    love.graphics.setColor(love.math.colorFromBytes(255,0,0)) 
    love.graphics.rectangle('fill', appleX*SIZE, appleY*SIZE, SIZE, SIZE)
    
    -- propriétés de l'affichage du score
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.print('score: '.. tail_length, 242, 15, 0, 2, 2)
end

function game_update()
    if up and dirY == 0 then
        dirX, dirY = 0, -1
    elseif down and dirY == 0 then
        dirX, dirY = 0, 1
    elseif left and dirX == 0 then
        dirX, dirY = -1, 0
    elseif right and dirX == 0 then
        dirX, dirY = 1, 0
    end

    local oldX = snakeX
    local oldY = snakeY

    snakeX = snakeX + dirX
    snakeY = snakeY + dirY

    if snakeX == appleX and snakeY == appleY then
        add_apple()
        tail_length = tail_length + 1
        table.insert(tail, {0,0})
        if tail_length % 10 == 0 then
            love.audio.play(score_sound)
        end
    end

    -- partie qui gère les traversées du mur
    if snakeX < 0 then
        snakeX = SIZE + 9 
    elseif snakeX > SIZE + 9  then
        snakeX = 0
    elseif snakeY < 0 then
        snakeY = SIZE + 9 
    elseif snakeY > SIZE + 9  then
        snakeY = 0
    end


    if tail_length > 0 then
        for _, v in ipairs(tail) do 
        local x, y = v[1], v[2] -- logique : si a = b et que b = c , alors a = c
        v[1], v[2] = oldX, oldY
        oldX, oldY = x, y
        end
        
    end

    for _, v in ipairs(tail) do
        if snakeX == v[1] and snakeY == v[2] then
        state = GameStates.game_over
        end
    end
    end

function game_restart()
  snakeX, snakeY = 20, 20
  dirX, dirY = 0, 0
  tail = {}
  up, down, left, right = false, false, false, false
  tail_length = 0
  state = GameStates.running
  add_apple()
end