-- one-time setup
function love.load()
    points = 0
    print("Load")
    w, h = 400, 800
    boardBorderW = 200
    love.window.setTitle("Tetris")
    love.window.setMode(w + boardBorderW, h)
    board = {}
    math.randomseed(os.time())
    -- love.keyboard.setKeyRepeat(true)

    for i = 1, 20 do
        board[i] = {{0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}}
    end

    fallingObject = {}
    fallingObjectTransition = 0
    fallingObjectColor = {}
    generateInitialObjects()
    spawnObject()
end

wallKickDataRight = {
    {{-1, 0}, {-1, 1}, {0,-2}, {-1,-2}}, -- 0 >> 1
    {{1, 0}, {1,-1}, {0, 2}, {1, 2}}, -- 1 >> 2
    {{1, 0}, {1, 1}, {0,-2}, {1,-2}}, -- 2 >> 3
    {{-1, 0}, {-1,-1}, {0, 2}, {-1, 2}} -- 3 >> 0
}

wallKickDataLeft = {
    {{1, 0}, {1,-1}, {0, 2}, {1, 2}}, -- 1 >> 0
    {{-1, 0}, {-1, 1}, {0,-2}, {-1,-2}}, -- 2 >> 1
    {{-1, 0}, {-1,-1}, {0, 2}, {-1, 2}}, -- 3 >> 2
    {{1, 0}, {1, 1}, {0,-2}, {1,-2}}, -- 0 >> 3
}

blocks = {
    {{{1, 6}, {2, 4}, {2, 5}, {2, 6}}, 1, {0.0, 0.8, 0.0}},
    {{{1, 5}, {2, 5}, {2, 6}, {1, 6}}, 1, {0.7, 0.0, 0.0}},
    {{{1, 4}, {2, 4}, {2, 5}, {2, 6}}, 1, {0.0, 0.0, 0.7}},
    {{{1, 5}, {2, 4}, {2, 5}, {2, 6}}, 1, {0.1, 0.7, 0.7}},
    {{{1, 4}, {1, 5}, {1, 6}, {1, 7}}, 1, {0.7, 0.7, 0.1}}
}

nextThreeBlocks = {}

dtotal = 0
dtotalSide = 0
fallingSpeed = 1
-- stateevery frame
function love.update(dt)
    dtotal = dtotal + dt
    dtotalSide = dtotalSide + dt
    
    if dtotalSide >= 0.05 then
        dtotalSide = dtotalSide - 0.05
        
        if love.keyboard.isDown("right") then
            moveFallingObjectSideways(1)
        elseif love.keyboard.isDown("left") then
            moveFallingObjectSideways(-1)
        end
    end
    
    if dtotal >= fallingSpeed then
        if love.keyboard.isDown("down") then
            points = points + 1
        end
        dtotal = dtotal - fallingSpeed
        moveFallingObjectDown()
    end
end

-- Draw a coloured rectangle.
function love.draw()
    -- print("draw")
    drawGrid(w, h)
    drawBoard()
    drawBoardBorder()
end

function drawBoardBorder()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", w, 0, boardBorderW, 800)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", w + 25, 500, 150, 25)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", w + 25, 50, 150, 400)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(points, w + 37.5, 500)

    local borderObj = {}
    local borderObjCol = {}

    for i = 1, 3 do
        for rectId, rectCoors in ipairs(nextThreeBlocks[i][1]) do
            borderObj[rectId] = {rectCoors[1] + i * 6, rectCoors[2] + 20}
        end

        borderObjCol = nextThreeBlocks[i][3]

        for rectId, rectCoors in pairs(borderObj)
        do
            drawRectOnBorder(rectCoors[1], rectCoors[2], borderObjCol)
        end
    end
end

function drawGrid(width, height)
    for i = 0, width - 40, 40 do
        for j = 0, height - 40, 40 do
            love.graphics.setColor(0.1, 0.1, 0.1)
            love.graphics.rectangle("line", i, j, 40, 40)
        end
    end
end

function moveFallingObjectDown()
    for rectId, rectCoors in pairs(fallingObject) do
        if (rectCoors[1] == 20 or board[rectCoors[1] + 1][rectCoors[2]][1] == 2) then
            for rectId, rectCoors in pairs(fallingObject) do
                board[rectCoors[1]][rectCoors[2]][1] = 2
                board[rectCoors[1]][rectCoors[2]][2] = fallingObjectColor
            end

            emptyFullRows()
            spawnObject()
            return
        end
    end

    for rectId, rectCoors in pairs(fallingObject) do
        fallingObject[rectId][1] = rectCoors[1] + 1
    end
end

function emptyFullRows()
    local rowsToDeleteSet = {}
    local rowsToDelete = {}
    for rectId, rectCoors in pairs(fallingObject) do
        local isFull = true
        for col = 1, 10 do
            if board[rectCoors[1]][col][1] == 0 then
                isFull = false
                break
            end
        end

        if isFull then
            print("full row", rectCoors[1])
            rowsToDeleteSet[rectCoors[1]] = rectCoors[1]
        end
    end


    for key, value in pairs(rowsToDeleteSet) do
        table.insert(rowsToDelete, value)
    end

    table.sort(rowsToDelete)

    for _, startingRow in ipairs(rowsToDelete) do
        print("row", startingRow)
        for row = startingRow, 2, -1  do
            board[row] = board[row - 1]
        end
        board[1] = {{0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}, {0,{}}}

        points = points + 100
    end
end

function drawBoard()
    for i = 1, 20 do
        for j = 1, 10 do
            if (board[i][j][1] == 2) then
                drawRect(i, j, board[i][j][2])
            end
        end
    end

    for rectId, rectCoors in pairs(fallingObject)
    do
        drawRect(rectCoors[1], rectCoors[2], fallingObjectColor)
    end
end

function drawRect(x, y, color)
    love.graphics.setColor(color[1] + 0.1, color[2] + 0.1, color[3] + 0.3)
    love.graphics.rectangle("line", (y - 1) * 40, (x - 1) * 40, 40, 40)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("fill", (y - 1) * 40, (x - 1) * 40, 40, 40)
end

function drawRectOnBorder(x, y, color)
    love.graphics.setColor(color[1] + 0.1, color[2] + 0.1, color[3] + 0.3)
    love.graphics.rectangle("line", (y - 1) * 20, (x - 1) * 20, 20, 20)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("fill", (y - 1) * 20, (x - 1) * 20, 20, 20)
end

function generateInitialObjects()
    nextThreeBlocks[1] = blocks[math.random(1, 5)]
    nextThreeBlocks[2] = blocks[math.random(1, 5)]
    nextThreeBlocks[3] = blocks[math.random(1, 5)]
end

function spawnObject()
    for rectId, rectCoors in ipairs(nextThreeBlocks[1][1]) do
        fallingObject[rectId] = {rectCoors[1], rectCoors[2]}
    end

    if doesCollide(fallingObject) then
        love.event.quit()
    end

    fallingObjectTransition = nextThreeBlocks[1][2]
    fallingObjectColor = nextThreeBlocks[1][3]

    moveNextObjects()
end

function moveNextObjects()
    nextThreeBlocks[1] = nextThreeBlocks[2]
    nextThreeBlocks[2] = nextThreeBlocks[3]
    nextThreeBlocks[3] = blocks[math.random(1, 5)]
end

function rotateFallingObject(direction)
    if blockType == 2 then
        return
    end

    local origin = {fallingObject[3][1], fallingObject[3][2]}
    local newCoord = {}
    print("Rot from", fallingObjectTransition, ">>", fallingObjectTransition + 1)
    for rectId, rectCoors in pairs(fallingObject) do
        local translationCoord = {rectCoors[1] - origin[1], rectCoors[2] - origin[2]}
        local rotatedCoord = {direction * translationCoord[2], direction * (-translationCoord[1])}
        newCoord[rectId] = {rotatedCoord[1] + origin[1], rotatedCoord[2] + origin[2]}
    end

    if not doesCollide(newCoord) then
        fallingObject = newCoord
        fallingObjectTransition = (fallingObjectTransition + (direction)) % 4
        if fallingObjectTransition < 0 then
            fallingObjectTransition = 3
        end
    else
        tryAlternativeRotations(newCoord, direction)
    end
end

function tryAlternativeRotations(coords, direction)
    local testCoords = {}
    local wallKickSide = wallKickDataRight
    local nextState = (fallingObjectTransition + direction) % 4

    if nextState < 0 then
        nextState = 3
    end

    if direction == 1 then
        wallKickSide = wallKickDataRight
    else
        wallKickSide = wallKickDataLeft
    end

    for testId, testTranslation in pairs(wallKickSide[nextState]) do
        for rectId, rectCoords in pairs(coords) do
            testCoords[rectId] = {rectCoords[1] + testTranslation[2], rectCoords[2] + testTranslation[1]}
        end
        if not doesCollide(testCoords) then
            fallingObject = testCoords
            fallingObjectTransition = nextState
            return
        end
    end
end

function doesCollide(coords)
    for rectId, rectCoors in pairs(coords) do
        if rectCoors[1] < 1 or rectCoors[1] > 20 or rectCoors[2] < 1 or rectCoors[2] > 10 or board[rectCoors[1]][rectCoors[2]][1] == 2 then
            return true
        end
    end

    return false
end

function moveFallingObjectSideways(dx)
    for rectId, rectCoors in pairs(fallingObject)
    do
        if rectCoors[2] + dx < 1 or rectCoors[2] + dx > 10 or board[rectCoors[1]][rectCoors[2] + dx][1] == 2 then
            return
        end
    end

    for rectId, rectCoors in pairs(fallingObject)
    do
        fallingObject[rectId][2] = rectCoors[2] + dx
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end

    if key == "up" then
        rotateFallingObject(1)
    end

    if key == "z" then
        rotateFallingObject(-1)
    end

    if key == "down" then
        dtotal = 0
        fallingSpeed = 0.05
    end
end

function love.keyreleased(key)
    if key == "down" then
        fallingSpeed = 1
        dtotal = dtotal + 1
    end
end