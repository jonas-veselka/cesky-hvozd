
local S = mobs.intllib_animal


-- Cow by sirrobzeroone

mobs:register_mob("mobs_animal:cow", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	reach = 2,
	damage = 4,
	hp_min = 5,
	hp_max = 20,
	armor = 200,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.2, 0.4},
	visual = "mesh",
	mesh = "mobs_cow.b3d",
	textures = {
		{"mobs_cow.png"},
		{"mobs_cow2.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_cow",
	},
	walk_velocity = 1,
	run_velocity = 2,
	jump = true,
	jump_height = 6,
	pushable = true,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},
		{name = "mobs:leather", chance = 1, min = 0, max = 2}
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		stand_start = 0,
		stand_end = 30,
		stand_speed = 20,
		stand1_start = 35,
		stand1_end = 75,
		stand1_speed = 20,
		walk_start = 85,
		walk_end = 114,
		walk_speed = 20,
		run_start = 120,
		run_end = 140,
		run_speed = 30,
		punch_start = 145,
		punch_end = 160,
		punch_speed = 20,
		die_start = 165,
		die_end = 185,
		die_speed = 10,
		die_loop = false
	},
	follow = {
		"farming:wheat", "default:grass_1", "farming:barley",
		"farming:oat", "farming:rye"
	},
	view_range = 8,
	replace_rate = 10,
	replace_what = {
		{"group:grass", "air", 0},
		{"default:dirt_with_grass", "default:dirt", -1}
	},
--	stay_near = {{"farming:straw", "group:grass"}, 10},
	fear_height = 2,
	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then

			-- if fed 7x wheat or grass then cow can be milked again
			if self.food and self.food > 6 then
				self.gotten = false
			end

			return
		end

		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end

		local tool = clicker:get_wielded_item()
		local name = clicker:get_player_name()
		local item = tool:get_name()

		-- milk cow with empty bucket
		if item == "bucket:bucket_empty"
		or item == "bucket_wooden:bucket_empty" then

			--if self.gotten == true
			if self.child == true then
				return
			end

			if self.gotten == true then
				minetest.chat_send_player(name,
					S("Cow already milked!"))
				return
			end

			local inv = clicker:get_inventory()

			tool:take_item()
			clicker:set_wielded_item(tool)

			-- which bucket are we using
			local ret_item = "mobs:bucket_milk"
			if item == "bucket_wooden:bucket_empty" then
				ret_item = "mobs:bucket_wooden_milk"
			end

			if inv:room_for_item("main", {name = ret_item}) then
				clicker:get_inventory():add_item("main", ret_item)
			else
				local pos = self.object:get_pos()
				pos.y = pos.y + 0.5
				minetest.add_item(pos, {name = ret_item})
			end

			self.gotten = true -- milked

			return
		end
	end,

	on_replace = function(self, pos, oldnode, newnode)

		self.food = (self.food or 0) + 1

		-- if cow replaces 8x grass then it can be milked again
		if self.food >= 8 then
			self.food = 0
			self.gotten = false
		end
	end
})


if not mobs.custom_spawn_animal then
mobs:spawn({
	name = "mobs_animal:cow",
	nodes = {"default:dirt_with_grass", "ethereal:green_dirt"},
	neighbors = {"group:grass"},
	min_light = 14,
	interval = 60,
	chance = 8000,
	min_height = 5,
	max_height = 200,
	day_toggle = true
})
end


mobs:register_egg("mobs_animal:cow", S("Cow"), "mobs_cow_inv.png")


mobs:alias_mob("mobs:cow", "mobs_animal:cow") -- compatibility


-- bucket of milk
bucket.register_full_bucket(":mobs:bucket_milk", "bucket:bucket_empty", "", {
	description = "kbelík mléka",
	inventory_image = "mobs_bucket_milk.png",
	groups = {milk_bucket = 1, food_milk = 1, flammable = 3, drink = 1},
	on_use = minetest.item_eat(8, "bucket:bucket_empty"),
	node_name = ":mobs:bucket_milk_placed",
})

-- glass of milk
minetest.register_craftitem(":mobs:glass_milk", {
	description = S("Glass of Milk"),
	inventory_image = "mobs_glass_milk.png",
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	groups = {food_milk_glass = 1, flammable = 3, vessel = 1, drink = 1},
})

minetest.register_craft({
	output = "mobs:glass_milk 4",
	recipe = {
		{"vessels:drinking_glass", "vessels:drinking_glass"},
		{"vessels:drinking_glass", "vessels:drinking_glass"},
		{"mobs:bucket_milk", ""}
	},
	replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}}
})

minetest.register_craft({
	output = "mobs:bucket_milk",
	recipe = {
		{"group:food_milk_glass", "group:food_milk_glass"},
		{"group:food_milk_glass", "group:food_milk_glass"},
		{"bucket:bucket_empty", ""}
	},
	replacements = {
		{"group:food_milk_glass", "vessels:drinking_glass 4"}
	}
})


-- butter
minetest.register_craftitem(":mobs:butter", {
	description = S("Butter"),
	inventory_image = "mobs_butter.png",
	on_use = minetest.item_eat(1),
	groups = {food_butter = 1, flammable = 2}
})

local salt_item = "default:sapling" -- some saplings are high in sodium

if minetest.get_modpath("farming") and farming and farming.mod then
	salt_item = "farming:salt"
end

minetest.register_craft({
	output = "mobs:butter",
	recipe = {{"mobs:bucket_milk", salt_item}},
	replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- cheese wedge
minetest.register_craftitem(":mobs:cheese", {
	description = S("Cheese"),
	inventory_image = "mobs_cheese.png",
	on_use = minetest.item_eat(4),
	groups = {food_cheese = 1, flammable = 2}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:cheese",
	recipe = "mobs:bucket_milk",
	cooktime = 5,
	replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- cheese block
minetest.register_node(":mobs:cheeseblock", {
	description = S("Cheese Block"),
	tiles = {"mobs_cheeseblock.png"},
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 3},
	sounds = default.node_sound_dirt_defaults()
})

minetest.register_craft({
	output = "mobs:cheeseblock",
	recipe = {
		{"group:food_cheese", "group:food_cheese", "group:food_cheese"},
		{"group:food_cheese", "group:food_cheese", "group:food_cheese"},
		{"group:food_cheese", "group:food_cheese", "group:food_cheese"}
	}
})

minetest.register_craft({
	output = "mobs:cheese 9",
	recipe = {{"mobs:cheeseblock"}}
})


-- check for wooden bucket mod and add compatibility
if minetest.get_modpath("bucket_wooden") then

	bucket.register_full_bucket(":mobs:bucket_wooden_milk", "bucket_wooden:bucket_empty", "", {
		description = "vědro mléka",
		inventory_image = "mobs_wooden_bucket_milk.png",
		groups = {milk_bucket = 1, food_milk = 1, flammable = 3, drink = 1},
		on_use = minetest.item_eat(8, "bucket_wooden:bucket_empty"),
		node_name = ":mobs:bucket_wooden_milk_placed",
	})

	minetest.register_craft({
		output = "mobs:glass_milk 4",
		recipe = {
			{"vessels:drinking_glass", "vessels:drinking_glass"},
			{"vessels:drinking_glass", "vessels:drinking_glass"},
			{"mobs:bucket_wooden_milk", ""}
		},
		replacements = {{"mobs:bucket_wooden_milk", "bucket_wooden:bucket_empty"}}
	})

	minetest.register_craft({
		output = "mobs:bucket_wooden_milk",
		recipe = {
			{"group:food_milk_glass", "group:food_milk_glass"},
			{"group:food_milk_glass", "group:food_milk_glass"},
			{"bucket_wooden:bucket_empty", ""}
		},
		replacements = {
			{"group:food_milk_glass", "vessels:drinking_glass 4"}
		}
	})

	minetest.register_craft({
		output = "mobs:butter",
		recipe = {{"mobs:bucket_wooden_milk", salt_item}},
		replacements = {{"mobs:bucket_wooden_milk", "bucket_wooden:bucket_empty"}}
	})

	minetest.register_craft({
		output = "mobs:bucket_wooden_milk",
		type = "shapeless",
		recipe = {"mobs:bucket_milk", "bucket_wooden:bucket_empty"},
		replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"}},
	})

	minetest.register_craft({
		output = "mobs:bucket_milk",
		type = "shapeless",
		recipe = {"mobs:bucket_wooden_milk", "bucket:bucket_empty"},
		replacements = {{"mobs:bucket_wooden_milk", "bucket_wooden:bucket_empty"}},
	})
end
