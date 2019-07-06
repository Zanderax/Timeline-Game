lineLength = 99
lineYCoord = 175
slotLineYCoord = 437
slots = 5
slotLength = 15
slotOffset = 25
slotWidth = 150
changeFactor = 2
bias = 0


line = {}
line[1] = 0
for i=2, lineLength do
    change = love.math.random( -changeFactor, changeFactor )
    line[i] = line[i-1] + change + bias
    bias = change
end

slot = {}
for s=1, slots do
    slot[s] = {}
    -- Timeline starts as stable
    slot[s][1] = 0
    for i=2, slotLength, 1 do
        change = love.math.random( -changeFactor, changeFactor )
        slot[s][i] = slot[s][i-1] + change
    end
end

UI_COLOR = {1, 1, 1}
LINE_COLOR = {0.55, 0.1, 0.94}

function love.draw()
    love.graphics.setColor(UI_COLOR)

    -- Timeline Boarders
    love.graphics.line( 0, 25, 800, 25 )
    love.graphics.line( 0, 325, 800, 325 )

    -- Timeline Middle Line
    for i = 0, 800,30 do
        love.graphics.line( i, 175, i+15, 175 )
    end

    -- Timeline Slots
    for i = 25, 750, 150 do
        -- Slot
        love.graphics.setColor(UI_COLOR)
        love.graphics.line( i, 350, i + 125, 350 )
        love.graphics.line( i, 525, i + 125, 525 )
        love.graphics.line( i, 350, i, 525 )
        love.graphics.line( i + 125, 350, i + 125, 525 )

        --Refresh Button
        love.graphics.line( i + 25, 550, i + 100, 550 )
        love.graphics.line( i + 25, 575, i + 100, 575 )
        love.graphics.line( i + 25, 550, i + 25, 575 )
        love.graphics.line( i + 100, 550, i + 100, 575 )


        -- Slot Middle Line
        love.graphics.setColor(LINE_COLOR)
        for s = 1, slots do
            for i = 1, slotLength do
                xCoord = slotOffset + ( slotWidth * ( s - 1 ) ) + ( i*8 )
                love.graphics.circle( "fill", xCoord, slotLineYCoord - slot[s][i], 2)
                if i < slotLength then
                    nextXCoord = slotOffset + ( slotWidth * ( s - 1 ) ) + ( (i+1)*8 )
                    love.graphics.line( xCoord, slotLineYCoord - slot[s][i], nextXCoord, slotLineYCoord - slot[s][i+1] )
                end
            end
        end
    end

    -- Timeline
    love.graphics.setColor(LINE_COLOR)
    for i=1, lineLength do
        love.graphics.circle( "fill", i*8, lineYCoord - line[i], 2)
        if i < lineLength then
            love.graphics.line( i*8, lineYCoord - line[i], (i+1)*8, lineYCoord - line[i+1] )
        end
    end
end


function love.load()
    love.window.setMode( 800, 600, {} )
end