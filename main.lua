

function saveToDatabase()
    local stmt = db:prepare[[
      INSERT INTO wartosci (input1_2, input2_2, input1_3, input2_3, input3_3)
      VALUES (?, ?, ?, ?, ?)
    ]]
    stmt:bind_values(input1_2, input2_2, input1_3, input2_3, input3_3)
    stmt:step()
    stmt:finalize()
end


function love.load()
    font = love.graphics.newFont("DejaVuSansCondensed-Bold.ttf", 18)
    love.graphics.setFont(font)

    button1 = {x = 100, y = 100, w = 200, h = 50, text = "Eliminacja"}
    button2 = {x = 310, y = 100, w = 200, h = 50, text = "Zrównoleglanie"}
    button3 = {x = 520, y = 100, w = 200, h = 50, text = "Podstawienie"}

    input_active = false
    input_mode = nil
    dialog_active = false

    input1_2 = ""
    input2_2 = ""
    current_input_2 = 1
    show_values_2 = false

    input1_3 = ""
    input2_3 = ""
    input3_3 = ""
    current_input_3 = 1
    show_values_3 = false

    show_dialog = false
end

function love.draw()
    love.graphics.setColor(0.3, 0.5, 1)
    love.graphics.rectangle("fill", button1.x, button1.y, button1.w, button1.h)
    love.graphics.rectangle("fill", button2.x, button2.y, button2.w, button2.h)
    love.graphics.rectangle("fill", button3.x, button3.y, button3.w, button3.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(button1.text, button1.x, button1.y + 15, button1.w, "center")
    love.graphics.printf(button2.text, button2.x, button2.y + 15, button2.w, "center")
    love.graphics.printf(button3.text, button3.x, button3.y + 15, button3.w, "center")

    if input_active and input_mode == 1 then
        love.graphics.print("Wartość 1: " .. input1_2, 100, 300)
        love.graphics.print("Wartość 2: " .. input2_2, 100, 330)
        love.graphics.print("Naciśnij Enter, aby zatwierdzić", 100, 370)
    end

    if input_active and input_mode == 2 then
        love.graphics.print("Wartość 1: " .. input1_3, 100, 300)
        love.graphics.print("Wartość 2: " .. input2_3, 100, 330)
        love.graphics.print("Wartość 3: " .. input3_3, 100, 360)
        love.graphics.print("Naciśnij Enter, aby zatwierdzić", 100, 400)
    end

    if show_values_2 then
        local line_x1 = 100
        local text = input1_2 .. ", " .. input2_2
        local line_x2 = 100 + font:getWidth(text)
        local line_y = 180

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(2)
        love.graphics.line(line_x1, line_y - 5, line_x1, line_y + 5)
        love.graphics.line(line_x2, line_y - 5, line_x2, line_y + 5)
        love.graphics.line(line_x1, line_y, line_x2, line_y)

        love.graphics.setColor(0, 1, 0)
        love.graphics.print(text, 100, 200)
    end

    if show_values_3 then
        local base_x = 130
        local base_y = 240
        local spacing = 30
        local values = {input1_3, input2_3, input3_3}

        love.graphics.setColor(0, 1, 0)
        for i, val in ipairs(values) do
            love.graphics.print(val, base_x, base_y + (i - 1) * spacing * 2)
            if i < #values then
                love.graphics.print(";", base_x, base_y + (i - 1) * spacing * 2 + spacing)
            end
        end

        local bracket_x = base_x - 25
        local bracket_y1 = base_y - 5
        local bracket_y2 = base_y + ((#values - 1) * spacing * 2) + font:getHeight()

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(3)
        love.graphics.line(bracket_x, bracket_y1, bracket_x, bracket_y2)
        love.graphics.line(bracket_x, bracket_y1, bracket_x + 10, bracket_y1)
        love.graphics.line(bracket_x, bracket_y2, bracket_x + 10, bracket_y2)

    end

    if show_values_4 then
        replaceA()
    end
    if show_values_5 then
        replaceB()
    end
    if save_values then
        local command = string.format('lua dbSave.lua "%s" "%s" "%s" "%s" "%s"',
        input1_2, input2_2, input1_3, input2_3, input3_3
    )
    os.execute(command)
    save_values = false
    end

    if show_dialog then
        love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
        love.graphics.rectangle("fill", 300, 200, 200, 150)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Wybierz: A lub B", 300, 220, 200, "center")
        love.graphics.rectangle("line", 320, 260, 60, 30)
        love.graphics.rectangle("line", 420, 260, 60, 30)
        love.graphics.printf("A", 320, 265, 60, "center")
        love.graphics.printf("B", 420, 265, 60, "center")
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if show_dialog then
            if x > 320 and x < 380 and y > 260 and y < 290 then
                --[input1_2 = input1_3 .. ", " .. input2_2
                show_values_2 = false
                show_values_3 = false
                show_values_4 = true
                show_values_5 = false
                save_values = true
                show_dialog = false
            elseif x > 420 and x < 480 and y > 260 and y < 290 then
                show_dialog = false
                show_values_2 = false
                show_values_3 = false
                show_values_4 = false
                show_values_5 = true
                save_values = true
                show_dialog = false
            end
            return
        end

        if x > button1.x and x < button1.x + button1.w and y > button1.y and y < button1.y + button1.h then
            input_mode = 1
            input_active = true
            input1_2 = ""
            input2_2 = ""
            current_input_2 = 1
            show_values_2 = false
            show_values_4 = false
            show_values_5 = false
        elseif x > button2.x and x < button2.x + button2.w and y > button2.y and y < button2.y + button2.h then
            input_mode = 2
            input_active = true
            input1_3 = ""
            input2_3 = ""
            input3_3 = ""
            current_input_3 = 1
            show_values_3 = false
        elseif x > button3.x and x < button3.x + button3.w and y > button3.y and y < button3.y + button3.h then
            show_dialog = true
        end
    end
end

function love.textinput(t)
    if input_active then
        if input_mode == 1 then
            if current_input_2 == 1 then
                input1_2 = input1_2 .. t
            elseif current_input_2 == 2 then
                input2_2 = input2_2 .. t
            end
        elseif input_mode == 2 then
            if current_input_3 == 1 then
                input1_3 = input1_3 .. t
            elseif current_input_3 == 2 then
                input2_3 = input2_3 .. t
            elseif current_input_3 == 3 then
                input3_3 = input3_3 .. t
            end
        end
    end
end

function replaceA()
    local base_x = 100
    local base_y = 250
    local spacing = 25
    local font_height = font:getHeight()

    -- Kolory i grubość linii
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)

    -- Rysujemy "a,b" w poziomie
    local top_text = "  , " .. input2_2
    love.graphics.print(top_text, base_x, base_y)

    -- Wymiary "a,b"
    local top_width = font:getWidth(top_text)
    local top_height = font_height

    local h_line_y = base_y - 40  -- trochę powyżej "a,b"
    local v_line_height = 30       -- wysokość pionowych linii litery h

    -- Rysujemy odcinek w kształcie litery h nad "a,b"
    -- dwie pionowe kreski i poziomą łączącą je na środku
    local left_x = base_x - 30
    local right_x = base_x + top_width + 30
    local mid_y = h_line_y + v_line_height / 2

    -- lewa pionowa kreska
    love.graphics.line(left_x, h_line_y, left_x, h_line_y + v_line_height)
    -- prawa pionowa kreska
    love.graphics.line(right_x, h_line_y, right_x, h_line_y + v_line_height)
    -- pozioma kreska łącząca pionowe
    love.graphics.line(left_x, mid_y, right_x, mid_y)

    -- Rysujemy pionowy ciąg: c ; d ; e
    local vertical_x = base_x + top_width + 90
    local values = {input1_3, ";" , input2_3, ";", input3_3}
 
    for i, val in ipairs(values) do
        love.graphics.print(val, base_x, base_y + (i - 1) * spacing)
    end

    -- Rysujemy nawias prostokątny po lewej stronie pionowego ciągu
    local bracket_x = base_x - 15
    local bracket_y1 = base_y - 5
    local bracket_y2 = base_y + ( #values - 1 ) * spacing + font_height

    -- pionowa linia nawiasu
    love.graphics.line(bracket_x, bracket_y1, bracket_x, bracket_y2)
    -- górna pozioma kreska nawiasu
    love.graphics.line(bracket_x, bracket_y1, bracket_x + 10, bracket_y1)
    -- dolna pozioma kreska nawiasu
    love.graphics.line(bracket_x, bracket_y2, bracket_x + 10, bracket_y2)
end

function replaceB()
    local base_x = 160
    local base_y = 250
    local spacing = 25
    local font_height = font:getHeight()

    -- Kolory i grubość linii
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)

    -- Rysujemy "a,b" w poziomie
    local top_text = input1_2 .. "  ,  "
    love.graphics.print(top_text, base_x, base_y)

    -- Wymiary "a,b"
    local top_width = font:getWidth(top_text)
    local top_height = font_height

    local h_line_y = base_y - 40  -- trochę powyżej "a,b"
    local v_line_height = 30       -- wysokość pionowych linii litery h

    -- Rysujemy odcinek w kształcie litery h nad "a,b"
    -- dwie pionowe kreski i poziomą łączącą je na środku
    local left_x = base_x - 30
    local right_x = base_x + top_width + 30
    local mid_y = h_line_y + v_line_height / 2

    -- lewa pionowa kreska
    love.graphics.line(left_x, h_line_y, left_x, h_line_y + v_line_height)
    -- prawa pionowa kreska
    love.graphics.line(right_x, h_line_y, right_x, h_line_y + v_line_height)
    -- pozioma kreska łącząca pionowe
    love.graphics.line(left_x, mid_y, right_x, mid_y)

    -- Rysujemy pionowy ciąg: c ; d ; e
    local vertical_x = base_x + top_width + 90
    local values = {input1_3, ";" , input2_3, ";", input3_3}
 
    for i, val in ipairs(values) do
        love.graphics.print(val, base_x + 35, base_y + (i - 1) * spacing)
    end

    -- Rysujemy nawias prostokątny po lewej stronie pionowego ciągu
    local bracket_x = base_x + 30
    local bracket_y1 = base_y - 5
    local bracket_y2 = base_y + ( #values - 1 ) * spacing + font_height

    -- pionowa linia nawiasu
    love.graphics.line(bracket_x, bracket_y1, bracket_x, bracket_y2)
    -- górna pozioma kreska nawiasu
    love.graphics.line(bracket_x, bracket_y1, bracket_x + 10, bracket_y1)
    -- dolna pozioma kreska nawiasu
    love.graphics.line(bracket_x, bracket_y2, bracket_x + 10, bracket_y2)
end


function love.keypressed(key)
    if key == "return" and input_active then
        if input_mode == 1 then
            if current_input_2 == 1 then
                current_input_2 = 2
            else
                input_active = false
                show_values_4 = false
                show_values_2 = true
            end
        elseif input_mode == 2 then
            if current_input_3 < 3 then
                current_input_3 = current_input_3 + 1
            else
                input_active = false
                show_values_4 = false
                show_values_3 = true
            end
        end
    elseif key == "backspace" and input_active then
        if input_mode == 1 then
            if current_input_2 == 1 then
                input1_2 = input1_2:sub(1, -2)
            elseif current_input_2 == 2 then
                input2_2 = input2_2:sub(1, -2)
            end
        elseif input_mode == 2 then
            if current_input_3 == 1 then
                input1_3 = input1_3:sub(1, -2)
            elseif current_input_3 == 2 then
                input2_3 = input2_3:sub(1, -2)
            elseif current_input_3 == 3 then
                input3_3 = input3_3:sub(1, -2)
            end
        end
    end
end

