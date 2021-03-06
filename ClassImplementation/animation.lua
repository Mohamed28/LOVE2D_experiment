local Frame = require("frame")
local Animation = Class:create("Animation")

function Animation:constructor(label, spritesheet_path, width, height, length, duration, loop)
    self.label = string.lower(label or "")
    self.spritesheet = love.graphics.newImage(IMAGES_PATH .. spritesheet_path)
    self.length = length
    self.loop = loop
    self.frames = {}
    self.state = "loaded"
    self.current_frame = {}
    self.current_time = 0
    self.spritesheet:setFilter("nearest", "nearest")
    self:setFrames(width, height, length, duration)
end

function Animation:setFrames(width, height, length, duration)
    local sprite = {
        width = width,
        height = height,
        offset = {x = -width, y = 0}
    }

    for index = 1, length, 1 do
        sprite.position = index
        sprite.offset.x = sprite.offset.x + width
        table.insert(self.frames, Frame:new(sprite, self.spritesheet, duration, length))
    end

    self.current_frame = self.frames[1]
end

function Animation:play(deltaTime)
    if self.state ~= "ended" then
        self.current_time = self.current_time + deltaTime

        if self.current_time >= self.current_frame.duration then
            self.current_time = self.current_time - self.current_frame.duration
            self.current_frame = self:nextFrame()
        end
    end

    return self.state
end

function Animation:nextFrame()
    if self.current_frame.position < self.length then
        return self.frames[self.current_frame.position + 1]
    else
        if self.loop then
            self.state = "playing"
        else
            self.state = "ended"
        end

        return self.frames[1]
    end
end

function Animation:reset()
    self.state = "loaded"
    self.current_frame = self.frames[1]
    self.current_time = 0
end

return Animation
