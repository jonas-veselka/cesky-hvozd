
--[[
	Original textures from Crops Plus mod
	Copyright (C) 2018 Grizzly Adam
	https://forum.minetest.net/viewtopic.php?f=9&t=19488
]]

local S = farming.intllib

-- peppercorn (seed)
minetest.register_craftitem("farming:peppercorn", {
	description = S("Peppercorn"),
	inventory_image = "crops_peppercorn.png",
	groups = {seed = 1, food_peppercorn = 1, flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:pepper_1")
	end
})

-- green pepper
minetest.register_craftitem("farming:pepper", {
	description = S("Green Pepper"),
	inventory_image = "crops_pepper.png",
	on_use = minetest.item_eat(2),
	groups = {food_pepper = 1, flammable = 3}
})

-- yellow pepper
minetest.register_craftitem("farming:pepper_yellow", {
	description = S("Yellow Pepper"),
	inventory_image = "crops_pepper_yellow.png",
	on_use = minetest.item_eat(3),
	groups = {food_pepper = 1, flammable = 3}
})

-- red pepper
minetest.register_craftitem("farming:pepper_red", {
	description = S("Red Pepper"),
	inventory_image = "crops_pepper_red.png",
	on_use = minetest.item_eat(4),
	groups = {food_pepper = 1, flammable = 3}
})

minetest.register_craft({
	output = "farming:peppercorn",
	recipe = {{"group:food_pepper"}}
})

-- ground pepper
minetest.register_node("farming:pepper_ground", {
	description = S("Ground Pepper"),
	inventory_image = "crops_pepper_ground.png",
	wield_image = "crops_pepper_ground.png",
	drawtype = "plantlike",
	visual_scale = 0.8,
	paramtype = "light",
	tiles = {"crops_pepper_ground.png"},
	groups = {
		vessel = 1, food_pepper_ground = 1,
		dig_immediate = 3, attached_node = 1
	},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	}
})

minetest.register_craft( {
	output = "farming:pepper_ground",
	recipe = {
		{"group:food_peppercorn"},
		{"farming:mortar_pestle"},
		{"vessels:glass_bottle"}
	},
	replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}}
})

-- crop definition
local def = {
	description = S("Pepper"),
	drawtype = "plantlike",
	tiles = {"crops_pepper_plant_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 1,
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 3, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:pepper_1", table.copy(def))

-- stage 2
def.tiles = {"crops_pepper_plant_2.png"}
minetest.register_node("farming:pepper_2", table.copy(def))

-- stage 3
def.tiles = {"crops_pepper_plant_3.png"}
minetest.register_node("farming:pepper_3", table.copy(def))

-- stage 4
def.tiles = {"crops_pepper_plant_4.png"}
def.move_resistance = 1
minetest.register_node("farming:pepper_4", table.copy(def))

-- stage 5 (green pepper)
def.description = S("Green Pepper")
def.tiles = {"crops_pepper_plant_5.png"}
def.drop = {
	max_items = 2, items = {
		{items = {"farming:pepper 2"}, rarity = 1},
		{items = {"farming:pepper"}, rarity = 2},
		{items = {"farming:pepper"}, rarity = 3}
	}
}
minetest.register_node("farming:pepper_5", table.copy(def))

-- stage 6 (yellow pepper)
def.description = S("Yellow Pepper")
def.tiles = {"crops_pepper_plant_6.png"}
def.drop = {
	max_items = 2, items = {
		{items = {"farming:pepper_yellow 2"}, rarity = 1},
		{items = {"farming:pepper_yellow"}, rarity = 2},
		{items = {"farming:pepper_yellow"}, rarity = 3}
	}
}
minetest.register_node("farming:pepper_6", table.copy(def))

-- stage 7 (red pepper)
def.description = S("Red Pepper")
def.tiles = {"crops_pepper_plant_7.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	max_items = 2, items = {
		{items = {"farming:pepper_red 2"}, rarity = 1},
		{items = {"farming:pepper_red"}, rarity = 2},
		{items = {"farming:pepper_red"}, rarity = 3}
	}
}
minetest.register_node("farming:pepper_7", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:pepper"] = {
	crop = "farming:pepper",
	seed = "farming:peppercorn",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 5
}
