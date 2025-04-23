local blue = { x = 300, y = 200, w = 80, h = 80 }
local yellow = { w = 80, h = 80 }
local button = { x = 50, y = 50, w = 160, h = 40 }

local rightSide = true
local inputActiveYellow = false
local inputActiveBlue = false
local inputTextYellow = ""
local inputTextBlue = ""

-- Linia
local linePosition = "horizontal"
local line = { x1 = 0, y1 = 0, x2 = 0, y2 = 0 }

function updateYellowPosition()
    if rightSide then
        yellow.x = blue.x + blue.w + 10
        yellow.y = blue.y
    else
        yellow.x = blue.x
        yellow.y = blue.y + blue.h + 10
    end
end

function updateLinePosition()
    if linePosition == "horizontal" then
        -- linia pozioma nad blokami
        line.x1 = blue.x - 20
        line.y1 = blue.y - 30
        line.x2 = yellow.x + yellow.w + 20
        line.y2 = blue.y - 30
    else
        -- linia pionowa po lewej stronie bloków
        local minLeft = math.min(blue.x, yellow.x)
        local top = math.min(blue.y, yellow.y)
        local bottom = math.max(blue.y + blue.h, yellow.y + yellow.h)

        line.x1 = minLeft - 20
        line.y1 = top - 20
        line.x2 = minLeft - 20
        line.y2 = bottom + 20
    end
end

function love.load()
    updateYellowPosition()
    updateLinePosition()
    font = love.graphics.newFont(14)
    love.keyboard.setKeyRepeat(true)
end

function love.draw()
    love.graphics.setFont(font)

    -- Niebieski blok
    love.graphics.setColor(0, 0.4, 1)
    love.graphics.rectangle("fill", blue.x, blue.y, blue.w, blue.h)

    -- Tekst w niebieskim bloku
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(inputTextBlue, blue.x + 5, blue.y + blue.h/2 - 7, blue.w - 10, "left")

    -- Żółty blok
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", yellow.x, yellow.y, yellow.w, yellow.h)

    -- Tekst w żółtym bloku
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(inputTextYellow, yellow.x + 5, yellow.y + yellow.h/2 - 7, yellow.w - 10, "left")

    -- Przycisk
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Zmień pozycję", button.x, button.y + 12, button.w, "center")

    -- Obwódki aktywnych pól
    if inputActiveYellow then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", yellow.x, yellow.y, yellow.w, yellow.h)
    end
    if inputActiveBlue then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", blue.x, blue.y, blue.w, blue.h)
    end

    -- Linia
love.graphics.setColor(1, 1, 1)
love.graphics.setLineWidth(3)

if linePosition == "horizontal" then
    -- Linia pozioma
    love.graphics.line(line.x1, line.y1, line.x2, line.y2)

    -- Nóżki w dół
    local legHeight = 15
    love.graphics.line(line.x1, line.y1, line.x1, line.y1 + legHeight)
    love.graphics.line(line.x2, line.y2, line.x2, line.y2 + legHeight)
else
    -- Linia zakrzywiona w kształcie "("
    local radius = (line.y2 - line.y1) / 2
    local cy = (line.y1 + line.y2) / 2
    local cx = line.x1 - radius  -- przesuwamy środek w lewo

    -- Rysowanie zakrzywionego nawiasu "("
    love.graphics.arc("fill", cx, cy, radius, math.pi*1.5, math.pi/2)
end


end

function love.mousepressed(x, y, buttonPressed)
    if buttonPressed == 1 then
        -- Przycisk
        if x >= button.x and x <= button.x + button.w and
           y >= button.y and y <= button.y + button.h then
            rightSide = not rightSide
            linePosition = (linePosition == "horizontal") and "vertical" or "horizontal"
            updateYellowPosition()
            updateLinePosition()
            inputActiveYellow = false
            inputActiveBlue = false
        end

        -- Klik na żółty blok
        if x >= yellow.x and x <= yellow.x + yellow.w and
           y >= yellow.y and y <= yellow.y + yellow.h then
            inputActiveYellow = true
            inputActiveBlue = false
        elseif x >= blue.x and x <= blue.x + blue.w and
               y >= blue.y and y <= blue.y + blue.h then
            inputActiveBlue = true
            inputActiveYellow = false
        else
            inputActiveYellow = false
            inputActiveBlue = false
        end
    end
end

function love.textinput(text)
    if inputActiveYellow then
        inputTextYellow = inputTextYellow .. text
    elseif inputActiveBlue then
        inputTextBlue = inputTextBlue .. text
    end
end

function love.keypressed(key)
    if inputActiveYellow then
        if key == "backspace" then
            inputTextYellow = inputTextYellow:sub(1, -2)
        elseif key == "return" or key == "kpenter" or key == "escape" then
            inputActiveYellow = false
        end
    elseif inputActiveBlue then
        if key == "backspace" then
            inputTextBlue = inputTextBlue:sub(1, -2)
        elseif key == "return" or key == "kpenter" or key == "escape" then
            inputActiveBlue = false
        end
    end
end
