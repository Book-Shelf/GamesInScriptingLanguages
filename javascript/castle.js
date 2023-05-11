player.onChat("build castle", function(num) {
    build_castle(player.position())
})

function create_rectangle(block:number, left_corner:Position, right_corner:Position) {

    const sides_lengths = right_corner.add(world(-left_corner.getValue(Axis.X), 0, -left_corner.getValue(Axis.Z)))

    shapes.line(block, left_corner, left_corner.add(world(sides_lengths.getValue(Axis.X), 0, 0)))
    shapes.line(block, left_corner.add(world(sides_lengths.getValue(Axis.X), 0, 0)), right_corner)
    shapes.line(block, right_corner, left_corner.add(world(0, 0, sides_lengths.getValue(Axis.Z))))
    shapes.line(block, left_corner.add(world(0, 0, sides_lengths.getValue(Axis.Z))), left_corner)
}

function add_side_tower_top_part(stairs_dir:number, tower_top_corner_pos:Position) {
    let opposite_stairs_dir = stairs_dir - 4

    if (stairs_dir <= 5) {
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, 0, 1)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, 0, 3)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, -1, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, -1, 4)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, -2, 2)))

        blocks.place(STONE_BRICKS_SLAB, tower_top_corner_pos.add(world(0, 2, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(0, 1, 1)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(0, 2, 2)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(0, 1, 3)))
        blocks.place(STONE_BRICKS_SLAB, tower_top_corner_pos.add(world(0, 2, 4)))

        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(0, 0, 0)), tower_top_corner_pos.add(world(0, 1, 0)))
        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(0, 0, 4)), tower_top_corner_pos.add(world(0, 1, 4)))
        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(0, -1, 2)), tower_top_corner_pos.add(world(0, 1, 2)))
    } else {
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(1, 0, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(3, 0, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(0, -1, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(4, -1, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), tower_top_corner_pos.add(world(2, -2, 0)))

        blocks.place(STONE_BRICKS_SLAB, tower_top_corner_pos.add(world(0, 2, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(1, 1, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(2, 2, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), tower_top_corner_pos.add(world(3, 1, 0)))
        blocks.place(STONE_BRICKS_SLAB, tower_top_corner_pos.add(world(4, 2, 0)))

        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(0, 0, 0)), tower_top_corner_pos.add(world(0, 1, 0)))
        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(4, 0, 0)), tower_top_corner_pos.add(world(4, 1, 0)))
        shapes.line(STONE_BRICKS, tower_top_corner_pos.add(world(2, -1, 0)), tower_top_corner_pos.add(world(2, 1, 0)))
    }
}

function add_side_tower_bottom_parts(tower_pos:Position, parts_height:number, side_top_block:Block, tower_width:number) {
    for (let i = 0; i < parts_height; i++) {
        shapes.line(STONE_BRICKS, tower_pos.add(world(-1, i, 1)), tower_pos.add(world(-1, i, tower_width - 2)))
        shapes.line(STONE_BRICKS, tower_pos.add(world(tower_width, i, 1)), tower_pos.add(world(tower_width, i, tower_width - 2)))
        shapes.line(STONE_BRICKS, tower_pos.add(world(1, i, tower_width)), tower_pos.add(world(tower_width - 2, i, tower_width)))
        shapes.line(STONE_BRICKS, tower_pos.add(world(1, i, -1)), tower_pos.add(world(tower_width - 2, i, -1)))
    }

    const top_height = parts_height + 1
    const stiars_height = parts_height

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 2), tower_pos.add(world(-1, stiars_height, 1)))
    shapes.line(STONE_BRICKS, tower_pos.add(world(-1, stiars_height, 2)), tower_pos.add(world(-1, stiars_height, tower_width - 3)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 3), tower_pos.add(world(-1, stiars_height, tower_width - 2)))
    shapes.line(side_top_block, tower_pos.add(world(-1, top_height, 2)), tower_pos.add(world(-1, top_height, tower_width - 3)))

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 2), tower_pos.add(world(tower_width, stiars_height, 1)))
    shapes.line(STONE_BRICKS, tower_pos.add(world(tower_width, stiars_height, 2)), tower_pos.add(world(tower_width, stiars_height, tower_width - 3)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 3), tower_pos.add(world(tower_width, stiars_height, tower_width - 2)))
    shapes.line(side_top_block, tower_pos.add(world(tower_width, top_height, 2)), tower_pos.add(world(tower_width, top_height, tower_width - 3)))

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 0), tower_pos.add(world(1, stiars_height, -1)))
    shapes.line(STONE_BRICKS, tower_pos.add(world(2, stiars_height, -1)), tower_pos.add(world(tower_width - 3, stiars_height, -1)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 1), tower_pos.add(world(tower_width - 2, stiars_height, -1)))
    shapes.line(side_top_block, tower_pos.add(world(2, top_height, -1)), tower_pos.add(world(tower_width - 3, top_height, -1)))

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 0), tower_pos.add(world(1, stiars_height, tower_width)))
    shapes.line(STONE_BRICKS, tower_pos.add(world(2, stiars_height, tower_width)), tower_pos.add(world(tower_width - 3, stiars_height, tower_width)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 1), tower_pos.add(world(tower_width - 2, stiars_height, tower_width)))
    shapes.line(side_top_block, tower_pos.add(world(2, top_height, tower_width)), tower_pos.add(world(tower_width - 3, top_height, tower_width)))
}

function build_entry_tower(p1: Position) {

    for (let i = 0; i < 15; i++) {
        create_rectangle(STONE_BRICKS, p1.add(world(0, i, 0)), p1.add(world(4, i, 4)))
    }

    add_side_tower_bottom_parts(p1, 6, STONE_BRICKS_SLAB, 5)

    add_side_tower_top_part(4, p1.add(world(-1, 14, 0)))
    add_side_tower_top_part(5, p1.add(world(5, 14, 0)))
    add_side_tower_top_part(6, p1.add(world(0, 14, -1)))
    add_side_tower_top_part(7, p1.add(world(0, 14, 5)))

    blocks.fill(PLANKS_SPRUCE, p1.add(world(0, 14, 0)), p1.add(world(4, 14, 4)))

    blocks.fill(PLANKS_SPRUCE, p1.add(world(1, 8, 1)), p1.add(world(3, 8, 3)))
    shapes.line(AIR, p1.add(world(2, 10, 0)), p1.add(world(2, 11, 0)))
    shapes.line(AIR, p1.add(world(2, 10, 4)), p1.add(world(2, 11, 4)))

}

function build_entry_gate(tower1_pos:Position, tower2_pos:Position) {
    blocks.fill(AIR, tower1_pos.add(world(5, 6, 1)), tower1_pos.add(world(5, 7, 3)))
    blocks.fill(AIR, tower2_pos.add(world(-1, 6, 1)), tower2_pos.add(world(-1, 7, 3)))

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 5), tower1_pos.add(world(6, 5, 1)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 5), tower1_pos.add(world(6, 4, 2)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 5), tower1_pos.add(world(6, 5, 3)))

    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 4), tower2_pos.add(world(-2, 5, 1)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 4), tower2_pos.add(world(-2, 4, 2)))
    blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 4), tower2_pos.add(world(-2, 5, 3)))

    shapes.line(STONE_BRICKS, tower1_pos.add(world(5, 5, 2)), tower1_pos.add(world(11, 5, 2)))
    blocks.fill(STONE_BRICKS, tower1_pos.add(world(5, 6, 1)), tower1_pos.add(world(11, 8, 3)))

    blocks.place(blocks.blockWithData(STONE_BRICKS_SLAB, 8), tower1_pos.add(world(8, 6, 1)))
    blocks.place(blocks.blockWithData(STONE_BRICKS_SLAB, 8), tower1_pos.add(world(8, 5, 2)))
    blocks.place(blocks.blockWithData(STONE_BRICKS_SLAB, 8), tower1_pos.add(world(8, 6, 3)))

    for (let i = 5; i < 12; i += 2) {
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 6), tower1_pos.add(world(i, 7, 0)))
        blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 7), tower1_pos.add(world(i, 7, 4)))
        shapes.line(STONE_BRICKS, tower1_pos.add(world(i, 8, 0)), tower1_pos.add(world(i, 9, 0)))
        shapes.line(STONE_BRICKS, tower1_pos.add(world(i, 8, 4)), tower1_pos.add(world(i, 9, 4)))
        blocks.place(STONE_BRICKS_SLAB, tower1_pos.add(world(i, 10, 0)))
        blocks.place(STONE_BRICKS_SLAB, tower1_pos.add(world(i, 10, 4)))

        if (i < 11) {
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 2), tower1_pos.add(world(i + 1, 9, 0)))
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 3), tower1_pos.add(world(i + 1, 9, 4)))
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 6), tower1_pos.add(world(i + 1, 8, 0)))
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, 7), tower1_pos.add(world(i + 1, 8, 4)))
        }
    }

    blocks.fill(AIR, tower1_pos.add(world(4, 9, 1)), tower1_pos.add(world(4, 11, 3)))
    blocks.place(STONE_BRICKS, tower1_pos.add(world(4, 11, 1)))
    blocks.place(blocks.blockWithData(STONE_BRICKS_SLAB, 8), tower1_pos.add(world(4, 11, 2)))
    blocks.place(STONE_BRICKS, tower1_pos.add(world(4, 11, 3)))
    shapes.line(COBBLESTONE_WALL, tower1_pos.add(world(4, 9, 1)), tower1_pos.add(world(4, 10, 1)))
    shapes.line(COBBLESTONE_WALL, tower1_pos.add(world(4, 9, 3)), tower1_pos.add(world(4, 10, 3)))

    blocks.fill(AIR, tower2_pos.add(world(0, 9, 1)), tower2_pos.add(world(0, 11, 3)))
    blocks.place(STONE_BRICKS, tower2_pos.add(world(0, 11, 1)))
    blocks.place(blocks.blockWithData(STONE_BRICKS_SLAB, 8), tower2_pos.add(world(0, 11, 2)))
    blocks.place(STONE_BRICKS, tower2_pos.add(world(0, 11, 3)))
    shapes.line(COBBLESTONE_WALL, tower2_pos.add(world(0, 9, 1)), tower2_pos.add(world(0, 10, 1)))
    shapes.line(COBBLESTONE_WALL, tower2_pos.add(world(0, 9, 3)), tower2_pos.add(world(0, 10, 3)))
}

function add_main_castle_door(p1:Position) {

    blocks.fill(AIR, p1.add(world(6, 0, 0)), p1.add(world(13, 3, 0)))
    shapes.line(PLANKS_SPRUCE, p1.add(world(6, -1, 0)), p1.add(world(13, -1, 0)))
    shapes.line(blocks.blockWithData(BLACKSTONE_WALL, 1), p1.add(world(6, 0, 0)), p1.add(world(6, 3, 0)))
    shapes.line(blocks.blockWithData(BLACKSTONE_WALL, 8), p1.add(world(13, 0, 0)), p1.add(world(13, 3, 0)))
    shapes.line(blocks.blockWithData(BLACKSTONE_WALL, 8), p1.add(world(7, 4, 0)), p1.add(world(12, 4, 0)))
    blocks.place(blocks.blockWithData(BLACKSTONE_WALL, 8), p1.add(world(7, 3, 0)))
    blocks.place(blocks.blockWithData(BLACKSTONE_WALL, 8), p1.add(world(12, 3, 0)))

}

function build_main_castle_tower(p1:Position, height:number, width:number) {
    blocks.fill(AIR, p1, p1.add(world(width - 1, height, width - 1)))
    blocks.fill(STONE_BRICKS, p1, p1.add(world(width - 1, -1, width - 1)))

    for (let i = 0; i < height; i++) {
        create_rectangle(STONE_BRICKS, p1.add(world(0, i, 0)), p1.add(world(width - 1, i, width - 1)))
    }

    add_side_tower_bottom_parts(p1, height / 2, STONE_BRICKS_SLAB, width)

    add_top_wall_part(4, p1.add(world(-1, height - 1, 0)), width)
    add_top_wall_part(5, p1.add(world(width, height - 1, 0)), width)
    add_top_wall_part(6, p1.add(world(0, height - 1, -1)), width)
    add_top_wall_part(7, p1.add(world(0, height - 1, width)), width)

    blocks.fill(PLANKS_SPRUCE, p1.add(world(0, height - 1, 0)), p1.add(world(width - 1, height - 1, width - 1)))
}

function add_throne(p1:Position) {
    blocks.fill(LAPIS_LAZULI_BLOCK, p1.add(world(-1, -1, -1)), p1.add(world(8, -1, 6)))
    blocks.fill(LAPIS_LAZULI_BLOCK, p1.add(world(0, 0, 0)), p1.add(world(7, 0, 5)))
    blocks.fill(LAPIS_LAZULI_BLOCK, p1.add(world(1, 1, 1)), p1.add(world(6, 1, 4)))
    blocks.fill(GOLD_BLOCK, p1.add(world(2, 2, 2)), p1.add(world(5, 2, 3)))
    blocks.fill(GOLD_BLOCK, p1.add(world(2, 3, 2)), p1.add(world(2, 3, 3)))
    blocks.fill(GOLD_BLOCK, p1.add(world(5, 3, 2)), p1.add(world(5, 3, 3)))
    blocks.fill(GOLD_BLOCK, p1.add(world(3, 2, 4)), p1.add(world(4, 5, 4)))

    blocks.place(GLOWSTONE, p1.add(world(2, 3, 4)))
    blocks.place(GLOWSTONE, p1.add(world(2, 5, 4)))
    blocks.place(GLOWSTONE, p1.add(world(2, 7, 4)))

    blocks.place(GLOWSTONE, p1.add(world(1, 4, 4)))
    blocks.place(GLOWSTONE, p1.add(world(1, 6, 4)))

    blocks.place(GLOWSTONE, p1.add(world(0, 5, 4)))

    blocks.place(GLOWSTONE, p1.add(world(3, 6, 4)))
    blocks.place(GLOWSTONE, p1.add(world(3, 8, 4)))
    blocks.place(GLOWSTONE, p1.add(world(4, 8, 4)))
    blocks.place(GLOWSTONE, p1.add(world(4, 6, 4)))

    blocks.place(GLOWSTONE, p1.add(world(5, 3, 4)))
    blocks.place(GLOWSTONE, p1.add(world(5, 5, 4)))
    blocks.place(GLOWSTONE, p1.add(world(5, 7, 4)))

    blocks.place(GLOWSTONE, p1.add(world(6, 4, 4)))
    blocks.place(GLOWSTONE, p1.add(world(6, 6, 4)))

    blocks.place(GLOWSTONE, p1.add(world(7, 5, 4)))
}

function add_door_lamp(p1:Position, chain_length:number) {
    blocks.place(CRACKED_STONE_BRICKS, p1)
    blocks.place(blocks.blockWithData(COBBLESTONE_STAIRS, 6), p1.add(world(0, -1, 0)))
    blocks.place(blocks.blockWithData(COBBLESTONE_STAIRS, 5), p1.add(world(1, 0, 0)))
    blocks.place(blocks.blockWithData(COBBLESTONE_STAIRS, 4), p1.add(world(-1, 0, 0)))

    blocks.place(STONE_SLAB, p1.add(world(0, 1, 0)))
    blocks.place(STONE_SLAB, p1.add(world(0, 1, -1)))

    for (let i = 0; i > -chain_length; i--) {
        blocks.place(CHAIN, p1.add(world(0, i, -1)))
    }

    blocks.place(GLOWSTONE, p1.add(world(0, -chain_length, -1)))

}

function add_window(p1:Position) {
    blocks.fill(GLASS_PANE, p1, p1.add(world(0, 2, 1)))
}

function add_light_inside(p1:Position) {
    blocks.place(GLOWSTONE, p1.add(world(16, 8, 1)))
    blocks.place(GLOWSTONE, p1.add(world(18, 8, 3)))
    blocks.place(GLOWSTONE, p1.add(world(3, 8, 1)))
    blocks.place(GLOWSTONE, p1.add(world(1, 8, 3)))

    blocks.place(GLOWSTONE, p1.add(world(1, -1, 4)))
    blocks.place(GLOWSTONE, p1.add(world(2, -1, 3)))
    blocks.place(GLOWSTONE, p1.add(world(3, -1, 2)))
    blocks.place(GLOWSTONE, p1.add(world(4, -1, 1)))

    blocks.place(GLOWSTONE, p1.add(world(15, -1, 1)))
    blocks.place(GLOWSTONE, p1.add(world(16, -1, 2)))
    blocks.place(GLOWSTONE, p1.add(world(17, -1, 3)))
    blocks.place(GLOWSTONE, p1.add(world(18, -1, 4)))


    blocks.fill(RED_CARPET, p1.add(world(9, 0, 1)), p1.add(world(10, 0, 15)))
    blocks.place(GLOWSTONE, p1.add(world(8, -1, 3)))
    blocks.place(GLOWSTONE, p1.add(world(8, -1, 6)))
    blocks.place(GLOWSTONE, p1.add(world(8, -1, 9)))
    blocks.place(GLOWSTONE, p1.add(world(8, -1, 12)))
    blocks.place(GLOWSTONE, p1.add(world(11, -1, 3)))
    blocks.place(GLOWSTONE, p1.add(world(11, -1, 6)))
    blocks.place(GLOWSTONE, p1.add(world(11, -1, 9)))
    blocks.place(GLOWSTONE, p1.add(world(11, -1, 12)))
}

function get_stair_height_pos(stair_height_pos:number) {
    let new_stair_height_pos = 0

    switch (stair_height_pos) {
        case 0:
            new_stair_height_pos = -2
            break
        case -1:
            new_stair_height_pos = 0
            break
        case -2:
            new_stair_height_pos = 0
            break
    }

    return new_stair_height_pos
}

function add_top_wall_part(stairs_dir:number, corner_pos:Position, length:number) {
    let opposite_stairs_dir = stairs_dir - 4
    let stair_height_pos = -1
    let odd = -1

    if (stairs_dir <= 5) {
        for (let i = 0, j = 0; i < length; i++, j++) {
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), corner_pos.add(world(0, stair_height_pos, i)))

            if (j == 0) {
                shapes.line(STONE_BRICKS, corner_pos.add(world(0, 0, i)), corner_pos.add(world(0, 1, i)))
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(0, 2, i)))
                stair_height_pos = 0
            } else if (j == 1) {
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(0, 1, i)))
                stair_height_pos = -2
            }else if (j == 2) {
                shapes.line(STONE_BRICKS, corner_pos.add(world(0, -1, i)), corner_pos.add(world(0, 1, i)))
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(0, 2, i)))
                stair_height_pos = 0
            } else {
                j = -1
                stair_height_pos = -1
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(0, 1, i)))
            }


        }

        blocks.place(STONE_BRICKS_SLAB, corner_pos.add(world(0, 2, 0)))
        blocks.place(STONE_BRICKS_SLAB, corner_pos.add(world(0, 2, length - 1)))
    } else {
        for (let i = 0, j = 0; i < length; i++, j++) {
            blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, stairs_dir), corner_pos.add(world(i, stair_height_pos, 0)))

            if (j == 0) {
                shapes.line(STONE_BRICKS, corner_pos.add(world(i, 0, 0)), corner_pos.add(world(i, 1, 0)))
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(i, 2, 0)))
                stair_height_pos = 0
            } else if (j == 1) {
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(i, 1, 0)))
                stair_height_pos = -2
            } else if (j == 2) {
                shapes.line(STONE_BRICKS, corner_pos.add(world(i, -1, 0)), corner_pos.add(world(i, 1, 0)))
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(i, 2, 0)))
                stair_height_pos = 0
            } else {
                j = -1
                stair_height_pos = -1
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS, opposite_stairs_dir), corner_pos.add(world(i, 1, 0)))
            }


        }

        blocks.place(STONE_BRICKS_SLAB, corner_pos.add(world(0, 2, 0)))
        blocks.place(STONE_BRICKS_SLAB, corner_pos.add(world(length - 1, 2, 0)))
    }
}

function add_second_floor(p1:Position, width:number, breadth:number) {
    const height = 8
    for (let i = 0; i < height; i++) {
        create_rectangle(STONE_BRICKS, p1.add(world(0, i, 0)), p1.add(world(width, i, breadth)))
    }

    add_top_wall_part(4, p1.add(world(-1, height, 0)), breadth + 1)
    add_top_wall_part(5, p1.add(world(width + 1, height, 0)), breadth + 1)
    add_top_wall_part(6, p1.add(world(0, height, -1)), width + 1)
    add_top_wall_part(7, p1.add(world(0, height, breadth + 1)), width + 1)
}

function  build_main_castle(p1:Position) {
    blocks.fill(STONE_BRICKS, p1.add(world(-4, 0, 19)), p1.add(world(22, 9, 37)))
    blocks.fill(AIR, p1.add(world(0, 0, 0)), p1.add(world(19, 9, 25)))
    blocks.fill(STONE_BRICKS, p1.add(world(0, 9, 0)), p1.add(world(19, 9, 25)))
    blocks.fill(STONE_BRICKS, p1.add(world(0, -1, 0)), p1.add(world(19, -1, 25)))


    for (let i = 0; i < 10; i++) {
        create_rectangle(STONE_BRICKS, p1.add(world(0, i, 0)), p1.add(world(19, i, 25)))
    }

    
    add_main_castle_door(p1)

    let tower_height = 16

    build_main_castle_tower(p1.add(world(-2, 0, -2)), tower_height, 5)
    blocks.place(STONE_BRICKS, p1.add(world(3, tower_height / 2 + 1, 0)))
    blocks.place(STONE_BRICKS, p1.add(world(0, tower_height / 2 + 1, 3)))

    build_main_castle_tower(p1.add(world(17, 0, -2)), tower_height, 5)
    blocks.place(STONE_BRICKS, p1.add(world(16, tower_height / 2 + 1, 0)))
    blocks.place(STONE_BRICKS, p1.add(world(19, tower_height / 2 + 1, 3)))
    
    add_light_inside(p1)

    add_throne(p1.add(world(6, 0, 17)))

    add_door_lamp(p1.add(world(6, 6, -1)), 2)
    add_door_lamp(p1.add(world(13, 6, -1)), 4)
    add_second_floor(p1.add(world(-4, 10, 19)), 26, 18)
    blocks.fill(STONE_SLAB, p1.add(world(-4, 18, 19)), p1.add(world(22, 18, 37)))

    tower_height = 40
    build_main_castle_tower(p1.add(world(-8, 0, 34)), tower_height, 9)
    build_main_castle_tower(p1.add(world(18, 0, 34)), tower_height, 9)

    tower_height = 30
    build_main_castle_tower(p1.add(world(-8, 0, 16)), tower_height, 7)
    build_main_castle_tower(p1.add(world(21, 0, 16)), tower_height, 7)


    for (let i = 0; i < 10; i += 5) {
        add_window(p1.add(world(0, 3, 6 + i)))
        add_window(p1.add(world(19, 3, 6 + i)))
    }

}

function add_moat(p1:Position) {
    for (let i = 1; i < 4; i++) {
        shapes.circle(WATER, p1.add(world(10,-i,12)), 50, Axis.Y, ShapeOperation.Hollow)
    }
}

function add_bridge(p1:Position) {
    blocks.fill(PLANKS_SPRUCE, p1, p1.add(world(4, 0, -10)))
}


function build_castle(p1:Position) {
    blocks.fill(AIR, p1, p1.add(world(50,0,50)))
    blocks.fill(AIR, p1, p1.add(world(-50, 0, -50)))
    add_moat(p1)

    for (let i = 1; i < 4; i++) {
        shapes.circle(GRASS, p1.add(world(10, -i, 12)), 40, Axis.Y, ShapeOperation.Replace)
    }
    add_bridge(p1.add(world(7, -1, -28)))

    build_main_castle(p1.add(world(0, 0, 10)))

    build_entry_tower(p1.add(world(1, 0, -27)))
    build_entry_tower(p1.add(world(13, 0, -27)))
    build_entry_gate(p1.add(world(1, 0, -27)), p1.add(world(13, 0, -27)))
}