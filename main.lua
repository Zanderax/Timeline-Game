lineLength = 99
lineYCoord = 175
slotLineYCoord = 437
slots = 5
slotLength = 15
slotOffset = 25
slotWidth = 150
changeFactor = 8
bias = 0
maxTimelineVariation = 150
lose = false
score = 0

selectionLineIndex = 20

UI_COLOR = {1, 1, 1}
LINE_COLOR = {0.55, 0.1, 0.94}
SELECTION_LINE_COLOR = { 0.4, 0.56, 0.14 }
PREDICTION_COLOR= { 0.1, 0.58, 0.67 }

-- UI
-- mode, x, y, width, height
MAIN_BOX = { "line", 0, 25, 800, 300 }

SLOT_BOXES = {}
for i = 0, 4 do
    SLOT_BOXES[i+1] = {}
    -- Slot                Mode    X           Y    Width Height
    SLOT_BOXES[i+1][1] = { "line", i*150 + 25, 350, 125,  175 }
    
    -- Slot                Mode    X           Y    Width Height
    SLOT_BOXES[i+1][1] = { "line", i*150 + 25, 350, 125,  175 }
    

    -- Refresh Button      Mode    X           Y    Width Height
    SLOT_BOXES[i+1][2] = { "line", i*150 + 38, 550, 100,  25 }
end

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

function love.draw()
    love.graphics.setColor(UI_COLOR)

    if lose then
        love.graphics.print("The timeline is too unstable. You lose!", 75, 0)
    end

    drawLineSelection()

    love.graphics.rectangle( unpack(MAIN_BOX) )

    for i = 1, 5 do
        love.graphics.rectangle( unpack(SLOT_BOXES[i][1]) )
        love.graphics.rectangle( unpack(SLOT_BOXES[i][2]) )
    end

    -- Timeline Middle Line
    for i = 0, 800,30 do
        love.graphics.line( i, 175, i+15, 175 )
    end

    -- Slot Middle Line
    for i = 1, slots do
        x1 = SLOT_BOXES[i][1][2]
        x2 = SLOT_BOXES[i][1][2] + SLOT_BOXES[i][1][4]
        y1 = SLOT_BOXES[i][1][3] + SLOT_BOXES[i][1][5] / 2
        love.graphics.line( x1, y1, x2, y1 )
    end

    -- Timeline Slots
    for i = 25, 750, 150 do
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

    love.graphics.print("Score: " .. tostring(score) )

    drawTimelinePrediction()
end

function drawTimelinePrediction()
    local x, y = love.mouse.getPosition()
    local hoverSlot = coordInSlot( x, y )
    if hoverSlot == -1 then
        return
    end

    love.graphics.push()
    love.graphics.setColor(PREDICTION_COLOR)
    for i = 1, math.min( slotLength - 1, lineLength - selectionLineIndex ) do
        print( slot[hoverSlot][i])
        x1Prediction = (selectionLineIndex + i - 1) * 8
        x2Prediction = (selectionLineIndex + i) * 8
        y1Prediction = lineYCoord - line[selectionLineIndex + i - 1] - slot[hoverSlot][i]
        y2Prediction = lineYCoord - line[selectionLineIndex + i] - slot[hoverSlot][i+1]
        love.graphics.circle( "fill", x1Prediction, y1Prediction, 2)
        if i < lineLength and i ~= slotLength - 1 then
            love.graphics.line( x1Prediction, y1Prediction, x2Prediction, y2Prediction )
        end
    end
    love.graphics.pop()
end

function drawLineSelection( )
    love.graphics.push()
    love.graphics.setColor(SELECTION_LINE_COLOR)
    x1 = ( selectionLineIndex - 1 ) * 8
    y1 = MAIN_BOX[3]
    y2 = MAIN_BOX[3] + MAIN_BOX[5]
    love.graphics.line( x1, y1, x1, y2 )
    love.graphics.pop()
end

function checkLose()
    for i = 1, lineLength do
        if line[i] > 150 or line[i] < -150 then
            lose = true
        end
    end
end

function refreshSlot( slotIndex )
    slot[slotIndex][1] = 0
    for i=2, slotLength do
        change = love.math.random( -changeFactor, changeFactor )
        slot[slotIndex][i] = slot[slotIndex][i-1] + change
    end
end

function addSlotToLine( slotIndex )
    for i = 1, slotLength do
        lineIndex = selectionLineIndex + i - 2
        line[lineIndex] = line[lineIndex] + slot[slotIndex][i]
        if lineIndex == lineLength then
            return
        end
    end
end

function coordInSlot( x, y )
    for i = 1, slots do
        if x > SLOT_BOXES[i][1][2] and
            x < SLOT_BOXES[i][1][2] + SLOT_BOXES[i][1][4] and
            y > SLOT_BOXES[i][1][3] and
            y < SLOT_BOXES[i][1][3] + SLOT_BOXES[i][1][5] then
            return i
        end
    end
    return -1
end

function coordInBox( x, y )
    if x > MAIN_BOX[2] and
    x < MAIN_BOX[2] + MAIN_BOX[4] and
    y > MAIN_BOX[3] and
    y < MAIN_BOX[3] + MAIN_BOX[5] then
        selection = math.floor(x / 8)
        selectionLineIndex = selection + 1
    end
    if selectionLineIndex < 2 then
        selectionLineIndex = 2
    end
end

function love.mousepressed( x, y, button )
    if button == 1 then
        slotClicked = coordInSlot( x, y )
        if slotClicked ~= -1 then
            addSlotToLine(slotClicked, 1)
            refreshSlot(slotClicked)
            checkLose()
            if not lose then
                score = score + 1
            end
        end
        coordInBox( x, y )
    end
end


function love.load()
    love.window.setMode( 800, 600, {} )
end
