-- collision.lua
local M = {}

-- ¿se solapan dos rectángulos? (AABB)
function M.aabb(a, b)
    return a.x < b.x + b.w and b.x < a.x + a.w
       and a.y < b.y + b.h and b.y < a.y + a.h
end

-- rebota por el eje de menor solape y expulsa la bola
function M.resolveBallBrick(ball, brick)
    local ax2, bx2 = ball.x + ball.w, brick.x + brick.w
    local ay2, by2 = ball.y + ball.h, brick.y + brick.h
    local ox = math.min(ax2, bx2) - math.max(ball.x, brick.x) -- solape en X
    local oy = math.min(ay2, by2) - math.max(ball.y, brick.y) -- solape en Y
    
    if ox < oy then -- menor solape en X -> chocó de lado
        ball.vx = -ball.vx
        ball.x = ball.x + (ball.x < brick.x and -ox or ox)
    else -- menor solape en Y -> chocó arriba/abajo
        ball.vy = -ball.vy
        ball.y = ball.y + (ball.y < brick.y and -oy or oy)
    end
end

return M
