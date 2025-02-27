--[[
Bags for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
License: GPLv3
--]]

local S = minetest.get_translator("unified_inventory")
local F = minetest.formspec_escape
local ui = unified_inventory

ui.register_page("bags", {
	get_formspec = function(player)
		local player_name = player:get_player_name()
		return { formspec = table.concat({
			ui.style_full.standard_inv_bg,
			ui.single_slot(0.100, 1.5),
			ui.single_slot(1.414, 1.5),
			ui.single_slot(2.728, 1.5),
			ui.single_slot(4.042, 1.5),
			ui.single_slot(5.356, 1.5),
			ui.single_slot(6.670, 1.5),
			ui.single_slot(7.984, 1.5),
			ui.single_slot(9.298, 1.5),
			"label["..ui.style_full.form_header_x..","..ui.style_full.form_header_y..";" .. F(S("Bags")) .. "]",
			"button[0.1500,2.75;1.200,0.75;bag1;" .. F(S("Bag @1", 1)) .. "]",
			"button[1.4640,2.75;1.200,0.75;bag2;" .. F(S("Bag @1", 2)) .. "]",
			"button[2.7780,2.75;1.200,0.75;bag3;" .. F(S("Bag @1", 3)) .. "]",
			"button[4.0920,2.75;1.200,0.75;bag4;" .. F(S("Bag @1", 4)) .. "]",
			"button[5.4060,2.75;1.200,0.75;bag5;" .. F(S("Bag @1", 5)) .. "]",
			"button[6.7200,2.75;1.200,0.75;bag6;" .. F(S("Bag @1", 6)) .. "]",
			"button[8.0340,2.75;1.200,0.75;bag7;" .. F(S("Bag @1", 7)) .. "]",
			"button[9.3480,2.75;1.200,0.75;bag8;" .. F(S("Bag @1", 8)) .. "]",
			"listcolors[#00000000;#00000000]",
			"list[detached:" .. F(player_name) .. "_bags;bag1;0.250,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag2;1.564,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag3;2.878,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag4;4.192,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag5;5.506,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag6;6.820,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag7;8.134,1.65;1,1;]",
			"list[detached:" .. F(player_name) .. "_bags;bag8;9.448,1.65;1,1;]",
		}) }
	end,
})

ui.register_button("bags", {
	type = "image",
	image = "ui_bags_icon.png",
	tooltip = S("Bags"),
	hide_lite=true
})

local function get_player_bag_stack(player, i)
	return minetest.get_inventory({
		type = "detached",
		name = player:get_player_name() .. "_bags"
	}):get_stack("bag" .. i, 1)
end

for bag_i = 1, 8 do
	ui.register_page("bag" .. bag_i, {
		get_formspec = function(player)
			local stack = get_player_bag_stack(player, bag_i)
			local image = stack:get_definition().inventory_image
			local slots = stack:get_definition().groups.bagslots

			local formspec = {
				ui.style_full.standard_inv_bg,
				ui.make_inv_img_grid(0.3, 1.5, 8, slots/8),
				"image[9.2,0.4;1,1;" .. image .. "]",
				"label[0.3,0.65;" .. F(S("Bag @1", bag_i)) .. "]",
				"listcolors[#00000000;#00000000]",
				"listring[current_player;main]",
				string.format("list[current_player;bag%icontents;%f,%f;8,3;]",
				    bag_i, 0.3 + ui.list_img_offset, 1.5 + ui.list_img_offset),
				"listring[current_name;bag" .. bag_i .. "contents]",
			}
			local n = #formspec + 1

			--[[
			local player_name = player:get_player_name() -- For if statement.
			if ui.trash_enabled
				or ui.is_creative(player_name)
				or minetest.get_player_privs(player_name).give then
					formspec[n] = ui.make_trash_slot(7.8, 0.25)
					n = n + 1
			end
			]]
			local inv = player:get_inventory()
			for i = 1, 8 do
				local def = get_player_bag_stack(player, i):get_definition()
				if def.groups.bagslots then
					local list_name = "bag" .. i .. "contents"
					local size = inv:get_size(list_name)
					local used = 0
					for si = 1, size do
						local stk = inv:get_stack(list_name, si)
						if not stk:is_empty() then
							used = used + 1
						end
					end
					local img = def.inventory_image
					local label = F(S("Bag @1", i)) .. "\n" .. used .. "/" .. size
					formspec[n] = string.format("image_button[%f,0.4;1,1;%s;bag%i;%s]",
							(i + 0.10)*1.15, img, i, label)
					n = n + 1
				end
			end
			return { formspec = table.concat(formspec) }
		end,
	})
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then
		return
	end
	for i = 1, 8 do
		if fields["bag" .. i] then
			local stack = get_player_bag_stack(player, i)
			if not stack:get_definition().groups.bagslots then
				return
			end
			ui.set_inventory_formspec(player, "bag" .. i)
			return
		end
	end
end)

local function save_bags_metadata(player, bags_inv)
	local is_empty = true
	local bags = {}
	for i = 1, 8 do
		local bag = "bag" .. i
		if not bags_inv:is_empty(bag) then
			-- Stack limit is 1, otherwise use stack:to_string()
			bags[i] = bags_inv:get_stack(bag, 1):get_name()
			is_empty = false
		end
	end
	local meta = player:get_meta()
	if is_empty then
		meta:set_string("unified_inventory:bags", nil)
	else
		meta:set_string("unified_inventory:bags",
			minetest.serialize(bags))
	end
end

local function load_bags_metadata(player, bags_inv)
	local player_inv = player:get_inventory()
	local meta = player:get_meta()
	local bags_meta = meta:get("unified_inventory:bags")
	local bags = bags_meta and minetest.deserialize(bags_meta) or {}
	local dirty_meta = false
	if not bags_meta then
		-- Backwards compatiblity
		for i = 1, 8 do
			local bag = "bag" .. i
			if not player_inv:is_empty(bag) then
				-- Stack limit is 1, otherwise use stack:to_string()
				bags[i] = player_inv:get_stack(bag, 1):get_name()
				dirty_meta = true
			end
		end
	end
	-- Fill detached slots
	for i = 1, 8 do
		local bag = "bag" .. i
		bags_inv:set_size(bag, 1)
		bags_inv:set_stack(bag, 1, bags[i] or "")
	end

	if dirty_meta then
		-- Requires detached inventory to be set up
		save_bags_metadata(player, bags_inv)
	end

	-- Clean up deprecated garbage after saving
	for i = 1, 8 do
		local bag = "bag" .. i
		player_inv:set_size(bag, 0)
	end
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local bags_inv = minetest.create_detached_inventory(player_name .. "_bags",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_size(listname .. "contents",
					stack:get_definition().groups.bagslots)
			save_bags_metadata(player, inv)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local new_slots = stack:get_definition().groups.bagslots
			if not new_slots then
				return 0
			end
			local player_inv = player:get_inventory()
			local old_slots = player_inv:get_size(listname .. "contents")

			if new_slots >= old_slots then
				return 1
			end

			-- using a smaller bag, make sure it fits
			local old_list = player_inv:get_list(listname .. "contents")
			local new_list = {}
			local slots_used = 0
			local use_new_list = false

			for i, v in ipairs(old_list) do
				if v and not v:is_empty() then
					slots_used = slots_used + 1
					use_new_list = i > new_slots
					new_list[slots_used] = v
				end
			end
			if new_slots >= slots_used then
				if use_new_list then
					player_inv:set_list(listname .. "contents", new_list)
				end
				return 1
			end
			-- New bag is smaller: Disallow inserting
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			if player:get_inventory():is_empty(listname .. "contents") then
				return stack:get_count()
			end
			return 0
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_size(listname .. "contents", 0)
			save_bags_metadata(player, inv)
		end,
		allow_move = function()
			return 0
		end,
	}, player_name)

	load_bags_metadata(player, bags_inv)
end)

-- register bag tools
local ch_help = "Batohy slouží k rozšíření hlavního inventáře. Když je vložíte na příslušné místo v okně inventáře,\nmůžete si pak do nich odkládat věci, které by se vám jinak do inventáře nevešly,\nale přesto je chcete mít stále po ruce. Batohy existují ve třech velikostech."
local ch_help_group = "bag"
minetest.register_tool("unified_inventory:bag_small", {
	description = S("Small Bag"),
	_ch_help = ch_help,
	_ch_help_group = ch_help_group,
	inventory_image = "bags_small.png",
	groups = {bagslots=8},
})

minetest.register_tool("unified_inventory:bag_medium", {
	description = S("Medium Bag"),
	_ch_help = ch_help,
	_ch_help_group = ch_help_group,
	inventory_image = "bags_medium.png",
	groups = {bagslots=16},
})

minetest.register_tool("unified_inventory:bag_large", {
	description = S("Large Bag"),
	_ch_help = ch_help,
	_ch_help_group = ch_help_group,
	inventory_image = "bags_large.png",
	groups = {bagslots=24},
})

-- register bag crafts
if minetest.get_modpath("farming") ~= nil then
	minetest.register_craft({
		output = "unified_inventory:bag_small",
		recipe = {
			{"",           "farming:string", ""},
			{"group:wool", "group:wool",     "group:wool"},
			{"group:wool", "group:wool",     "group:wool"},
		},
	})

	minetest.register_craft({
		output = "unified_inventory:bag_medium",
		recipe = {
			{"",               "",                            ""},
			{"farming:string", "unified_inventory:bag_small", "farming:string"},
			{"farming:string", "unified_inventory:bag_small", "farming:string"},
		},
	})

	minetest.register_craft({
		output = "unified_inventory:bag_large",
		recipe = {
			{"",               "",                             ""},
			{"farming:string", "unified_inventory:bag_medium", "farming:string"},
			{"farming:string", "unified_inventory:bag_medium", "farming:string"},
	    },
	})
end
