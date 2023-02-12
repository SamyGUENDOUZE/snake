require('grid')
require('game')


function love.load()
  interval = 20
  add_apple()
end

function love.draw()
  grid_draw()
  game_draw()
  if state == GameStates.game_over then 
    love.graphics.print("Game Over!", 200, 225, 0, 2, 2)
    love.graphics.print("Press Space to restart", 200, 250, 0, 2, 2)
  end
end

function love.update()
  if state == GameStates.running then
    interval = interval - 1
    if interval < 0 then
      game_update()
      -- partie du code qui sert à accélerer le jeu au fur et à mesure que le score augmente
      if body_length <= 5 then
        interval = 20
      elseif body_length > 5 and body_length <= 10 then 
        interval = 15
      elseif body_length > 10 and body_length <= 25 then
        interval = 10
      elseif body_length > 25 and body_length <= 50 then
        interval = 5
      else
        interval = 3
      end
    end
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'left' and state == GameStates.running then 
    left, right, up, down = true, false, false, false
  elseif key == 'right' and state == GameStates.running then
    left, right, up, down = false, true, false, false
  elseif key == 'up' and state == GameStates.running then
    left, right, up, down = false, false, true, false
  elseif key == 'down' and state == GameStates.running then
    left, right, up, down = false, false, false, true
  elseif key == 'space' and state == GameStates.game_over then
    game_restart()
  elseif key == 'p' then
    if state == GameStates.running then
      state = GameStates.pause
    else
      state = GameStates.running
    end
  end
end