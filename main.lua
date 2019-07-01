function love.draw()
    -- Timeline Boarders
    love.graphics.line( 0, 25, 800, 25 )
    love.graphics.line( 0, 325, 800, 325 )

    -- Timeline Middle Line
    for i = 0, 800,30
    do
        love.graphics.line( i, 175, i+15, 175 )
    end

    -- Timeline Slots
    for i = 25, 750, 150
    do
        -- Slot
        love.graphics.line( i, 350, i + 125, 350 )
        love.graphics.line( i, 525, i + 125, 525 )
        love.graphics.line( i, 350, i, 525 )
        love.graphics.line( i + 125, 350, i + 125, 525 )

        --Refresh Button
        love.graphics.line( i + 25, 550, i + 100, 550 )
        love.graphics.line( i + 25, 575, i + 100, 575 )
        love.graphics.line( i + 25, 550, i + 25, 575 )
        love.graphics.line( i + 100, 550, i + 100, 575 )
    end
end


function love.load()
    love.window.setMode( 800, 600, {} )
end