-- machine à état
GameStates = {pause='pause', running='running', game_over='game over'}
state = GameStates.running

sound_effect = love.audio.newSource("sound/mario_power_up.mp3", "static")
background_music = love.audio.newSource("sound/love_yourself_8_bits.mp3", "stream")

local snake = {}
snake.x = 20
snake.y = 20


local dirX = 0
local dirY = 0

local SIZE = 20 -- j'ai choisi des tuiles/tiles de 20 car c'est pratique:)

local apple = {}
apple.x = 0
apple.y = 0

local body = {}

body_length = 0
up = false
down = false
left = false
right = false

function add_apple() 
  apple.x = math.random(SIZE-1)
  apple.y = math.random(SIZE-1)
end

function game_draw()
    -- propriétés de la tête du serpent
    love.graphics.setColor(love.math.colorFromBytes(0,100,0)) 
    love.graphics.rectangle('fill', snake.x*SIZE, snake.y*SIZE, SIZE, SIZE)

    -- propriétés de la queue du serpent
    love.graphics.setColor(love.math.colorFromBytes(50,205,50))
    for _, v in ipairs(body) do
        love.graphics.rectangle('fill', v[1]*SIZE, v[2]*SIZE, SIZE, SIZE)
    end

    -- propriétés de la pomme
    love.graphics.setColor(love.math.colorFromBytes(255,0,0)) 
    love.graphics.rectangle('fill', apple.x*SIZE, apple.y*SIZE, SIZE, SIZE)
    
    -- propriétés de l'affichage du score
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.print('score: '.. body_length, 242, 15, 0, 2, 2)
end

function game_update()

    love.audio.play(background_music)
    love.audio.setVolume(0.2)

    if up and dirY == 0 then
        dirX, dirY = 0, -1
    elseif down and dirY == 0 then
        dirX, dirY = 0, 1
    elseif left and dirX == 0 then
        dirX, dirY = -1, 0
    elseif right and dirX == 0 then
        dirX, dirY = 1, 0
    end

    local oldX = snake.x
    local oldY = snake.y

    snake.x = snake.x + dirX
    snake.y = snake.y + dirY

    if snake.x == apple.x and snake.y == apple.y then
        add_apple()
        body_length = body_length + 1
        table.insert(body, {0,0})
        if body_length % 10 == 0 then
            love.audio.play(sound_effect)
          end
    end

    -- partie qui gère les traversées du mur
    if snake.x < 0 then
        snake.x = SIZE + 9 
    elseif snake.x > SIZE + 9  then
        snake.x = 0
    elseif snake.y < 0 then
        snake.y = SIZE + 9 
    elseif snake.y > SIZE + 9  then
        snake.y = 0
    end


    if body_length > 0 then
        for _, v in ipairs(body) do 
        local x, y = v[1], v[2] -- logique : si a = b et que b = c , alors a = c
        v[1], v[2] = oldX, oldY
        oldX, oldY = x, y
        end
        
    end

    for _, v in ipairs(body) do
        if snake.x == v[1] and snake.y == v[2] then
        state = GameStates.game_over
        end
    end
    end

function game_restart()
  snake.x, snake.y = 20, 20
  dirX, dirY = 0, 0
  body = {}
  up, down, left, right = false, false, false, false
  body_length = 0
  state = GameStates.running
  add_apple()
end