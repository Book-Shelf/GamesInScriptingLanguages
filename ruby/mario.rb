require 'ruby2d'

set width: 800, height: 600
$gravity = 6
$tile_scale = 3
$grounds = Array.new
$tubes = Array.new
$bricks = Array.new
$background = Image.new('map1-1.png', y: -120)
$overall_speed = 5

set title: 'Mario'

class Ground
    def initialize(x, y, tiles_num_width, tiles_num_height)
        @x = x
        @y = y
        @width = x + 16 * $tile_scale * tiles_num_width
        @height = y + 16 * $tile_scale * tiles_num_height
        @tiles_coordinates = Array.new
        generate_coordinates()
    end

    def get_tiles_coordinates()
        return @tiles_coordinates
    end

    def is_colliding(objectx, objecty, offsetx)
        return ((objectx + offsetx >= @x and objectx <= @width) and (objecty >= @y and objecty <= (@y + 5)))
    end

    def is_touching_side(objectx, objecty, offsetx)
        return ((objectx + offsetx >= @x and objectx <= @width) and (objecty > (@y + 5) and objecty <= @height))
    end

    private

    def generate_coordinates()
        j = @y

        while j < @height do
            i = @x

            while i < @width do
                @tiles_coordinates.push({x: i, y: j})
                i += 16 * $tile_scale
            end

            j += 16 * $tile_scale
        end
    end
end

class Tube
    def initialize(x, y, tube_height)
        @left_x = x
        @y = y
        @right_x = x + 16 * $tile_scale
        @height = y + 16 * $tile_scale * tube_height
        @top_left_coordinates = {}
        @top_right_coordinates = {}
        @bottom_left_coordinates = Array.new
        @bottom_right_coordinates = Array.new
        generate_coordinates()
    end

    def get_top_left_coordinates()
        return @top_left_coordinates
    end

    def get_top_right_coordinates()
        return @top_right_coordinates
    end

    def get_bottom_left_coordinates()
        return @bottom_left_coordinates
    end

    def get_bottom_right_coordinates()
        return @bottom_right_coordinates
    end

    def is_touching_side(objectx, objecty, offsetx)
        width = @left_x + 32 * $tile_scale
        return (objectx + offsetx <= width and objectx + offsetx >= @left_x and (objecty > (@y + 9) and objecty <= @height))
    end

    def is_touching_surface(objectx, objecty, offsetx)
        return (is_in_width_range(objectx, offsetx) and (objecty >= @y) and objecty <= (@y + 10))
    end

    private

    def is_in_width_range(objectx, offsetx)
        width = @left_x + 32 * $tile_scale
        return ((objectx + offsetx >= @left_x and objectx + offsetx <= width))
    end

    def generate_coordinates()
        @top_left_coordinates = [x:  @left_x, y: @y]
        @top_right_coordinates = [x: @right_x, y: @y]

        j = @y + 16 * $tile_scale

        while j <= @height do

            @bottom_left_coordinates.push({x: @left_x, y: j})
            @bottom_right_coordinates.push({x: @right_x, y: j})

            j += 16 * $tile_scale
        end
    end
end

class BrickBlock
    def initialize(x, y, tiles_num_width, tiles_num_height)
        @x = x
        @y = y
        @width = x + 16 * $tile_scale * tiles_num_width
        @height = y + 16 * $tile_scale * tiles_num_height
        @tiles_coordinates = Array.new
        generate_coordinates()
    end

    def get_tiles_coordinates()
        return @tiles_coordinates
    end

    def is_colliding(objectx, objecty, offsetx)
        return ((objectx + offsetx >= @x and objectx <= @width) and (objecty >= @y and objecty <= (@y + 5)))
    end

    def is_touching_side(objectx, objecty, offsetx)
        return ((objectx + offsetx >= @x and objectx <= @width) and (objecty > (@y + 5) and objecty <= @height))
    end

    def is_touching_bottom(objectx, objecty, offsetx)
        return ((objectx + offsetx >= @x and objectx <= @width) and (objecty >= (@height - 5) and objecty <= @height))
    end

    def move_tiles()
        @x = @x - $camera_x
        @width = @width - $camera_x
        @tiles_coordinates.each do |tile_coor, _|
            tile_coor[:x] = tile_coor[:x] - $camera_x
        end
    end

    private

    def generate_coordinates()
        j = @y

        while j < @height do
            i = @x

            while i < @width do
                @tiles_coordinates.push({x: i, y: j})
                i += 16 * $tile_scale
            end

            j += 16 * $tile_scale
        end
    end
end


class MarioCharacter 
    def initialize(x, y)
        @health = 1
        @speed = $overall_speed
        @jump_force = 15
        @max_jump_height = -100
        @height = 0
        @velocity_y = 0
        @change_to_default = false
        @is_jumping = false
        @sprite = Sprite.new(
            'mario.png',
            width: 20 * 4,
            height: 16 * 4,
            x: x,
            y: y,
            clip_width: 20,
            time: 100,
            animations: {
                walk: 1..3,
                jump: 4,
                die: 5
            }
        )
    end

    def get_x()
        return @sprite.x
    end

    def get_y()
        return @sprite.y
    end

    def run_left()
        if !is_touching_blocks_from_left() and !is_touching_left_screen_border()
            if $background.x == 0
                @speed = $overall_speed
            end
    
            @sprite.x -= @speed
            if $background.x < 0 and @speed == 0
                $background.x += $overall_speed
            end
        end
        @sprite.play animation: :walk, loop: true, flip: :horizontal
    end

    def run_right()
        if !is_touching_blocks_from_right() and !is_touching_right_screen_border() 
            if $background.x == -2785
                @speed = $overall_speed
            end

            @sprite.x += @speed

            if ($background.x - Window.width) > -$background.width and @speed == 0
                $background.x -= $overall_speed
            end
        end
        @sprite.play animation: :walk, loop: true 
    end

    def jump()
        if is_touching_ground() or is_touching_surface()
            @is_jumping = true
            @velocity_y = -@jump_force
        elsif @is_jumping and @velocity_y > @max_jump_height
            @velocity_y -= 6
            @height -= 6
            if @height <= @max_jump_height
                stop_jump()
            end
        end
    end
    
    def stop_jump()
        @is_jumping = false
        @change_to_default = true
        @height = 0
    end

    def stop_animation()
        @sprite.stop
    end

    def update()
        if is_falling()
            @sprite.y += $gravity
            @sprite.clip_x = 80
            @change_to_default = true

            if is_touching_bottom_border()
                remove_heart()
            end
        elsif @is_jumping
            @sprite.y += @velocity_y
            @velocity_y += $gravity
            @sprite.clip_x = 80

            if has_hit_block()
                @is_jumping = false
            end
        end

        if @change_to_default and !is_falling()
            @sprite.stop
            @change_to_default = false
        end
        
        if @sprite.x == (Window.width / 2 - 50)
            @speed = 0
        end
    end

    def is_falling()
        if is_touching_ground() or @is_jumping or is_touching_surface()
            return false
        end

        return true
    end

    def is_touching_left_screen_border()
        if @sprite.x + 9 <= 0
            return true
        end

        return false
    end

    def is_touching_right_screen_border()
        if @sprite.x >= 740
            return true
        end

        return false
    end

    def is_touching_ground()
        $grounds.each do |ground|
            if ground.is_colliding(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 40)
                return true
            end
        end

        return false
    end

    def is_touching_surface()
        $tubes.each do |tube|
            if tube.is_touching_surface(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 60)
                return true
            end
        end

        $bricks.each do |brick|
            if brick.is_colliding(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 40)
                return true
            end
        end

        return false
    end

    def is_touching_blocks_from_left()
        $tubes.each do |tube|
            if tube.is_touching_side(-$background.x + @sprite.x, @sprite.y + @sprite.height, 60) or tube.is_touching_side(-$background.x + @sprite.x, @sprite.y, 60)
                return true
            end
        end

        $grounds.each do |ground|
            if ground.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 20) or ground.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y, 20)
                return true
            end
        end

        $bricks.each do |brick|
            if brick.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 20) or brick.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y, 20)
                return true
            end
        end

        return false
    end

    def is_touching_blocks_from_right()
        $tubes.each do |tube|
            if tube.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 100) or tube.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y, 100)
                return true
            end
        end

        $grounds.each do |ground|
            if ground.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 40) or ground.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y, 40)
                return true
            end
        end

        $bricks.each do |brick|
            if brick.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y + @sprite.height, 40) or brick.is_touching_side(-$background.x + @sprite.x + 20, @sprite.y, 40)
                return true
            end
        end

        return false
    end
    
    def has_hit_block()
        $bricks.each do |brick|
            if brick.is_touching_bottom(-$background.x + @sprite.x + 20, @sprite.y, 40) or brick.is_touching_bottom(-$background.x + @sprite.x, @sprite.y, 40)
                return true
            end
        end

        return false
    end

    def is_touching_bottom_border()
        return (@sprite.y + @sprite.height) >= Window.height
    end

    def remove_heart()
        @health -= 1
    end

    def is_alive()
        return @health > 0
    end

    def reset()
        @sprite.remove()
        @health = 1
        @speed = $overall_speed
        @jump_force = 15
        @max_jump_height = -100
        @height = 0
        @velocity_y = 0
        @change_to_default = false
        @is_jumping = false
        @sprite = Sprite.new(
            'mario.png',
            width: 20 * 4,
            height: 16 * 4,
            x: 20,
            y: 400,
            clip_width: 20,
            time: 100,
            animations: {
                walk: 1..3,
                jump: 4,
                die: 5
            }
        )
    end
end
tileset = Tileset.new(
    'tiles.png',
    tile_width: 16,
    tile_height: 16,
    spacing: 1,
    scale: $tile_scale
)
mario = MarioCharacter.new(20, 400)

ground = Ground.new(0, Window.height - 2 * 48, 46, 2)
$grounds.push(ground)
ground = Ground.new(48 * 48, Window.height - 2 * 48, 15, 2)
$grounds.push(ground)
ground = Ground.new(48 * 66, Window.height - 2 * 48, 9, 2)
$grounds.push(ground)

tube = Tube.new(48 * 29, Window.height - 2 * 48 - 16 * $tile_scale * 2, 1)
$tubes.push(tube)
tube = Tube.new(48 * 39, Window.height - 2 * 48 - 16 * $tile_scale * 3, 2)
$tubes.push(tube)

brick = BrickBlock.new(20 * 48, Window.height - 6 * 48, 5, 1)
$bricks.push(brick)
brick = BrickBlock.new(54 * 48, Window.height - 6 * 48, 3, 1)
$bricks.push(brick)
brick = BrickBlock.new(57 * 48, Window.height - 10 * 48, 8, 1)
$bricks.push(brick)
brick = BrickBlock.new(68 * 48, Window.height - 10 * 48, 3, 1)
$bricks.push(brick)
brick = BrickBlock.new(71 * 48, Window.height - 6 * 48, 1, 1)
$bricks.push(brick)

on :key_held do |event|
    case event.key
        when 'left'
            mario.run_left
        when 'right'
            mario.run_right
        when 'space'
            mario.jump
    end
end

on :key_up do |event|
    case event.key
        when 'left'
            mario.stop_animation
        when 'right'
            mario.stop_animation
        when 'space'
            mario.stop_jump
    end
end

update do
    if mario.is_alive()
        mario.update()
    else
        $background.x = 0
        mario.reset()
    end
end
show