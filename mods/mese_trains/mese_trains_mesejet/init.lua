local S = attrans

local lines = {
	"#ff1111",
	"#1111ff",
	"#ff9900",
	"#11ff11",
	"#9900ff",
	"#00ffff",
	"#ff9999",
	"#ff00ff",
	"#99ff00",
}

advtrains.register_wagon("mese_trains_mesejet:mese_trains_mesejet_wagon", {
	mesh = "mese_trains_mesejet_wagon.b3d",
	textures = {"mese_trains_mesejet_wagon.png"},
	use_texture_alpha = true,
	drives_on = {default = true},
	max_speed = 20,
	seats = {
		{
			name = "1",
			attach_offset = {x = -4, y = -2, z = 8},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
		{
			name = "2",
			attach_offset = {x = 4, y = -2, z = 8},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
		{
			name = "1a",
			attach_offset = {x = -4, y = -2, z = 0},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
		{
			name = "2a",
			attach_offset = {x = 4, y = -2, z = 0},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
		{
			name = "3",
			attach_offset = {x = -4, y = -2, z = -8},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
		{
			name = "4",
			attach_offset = {x = 4, y = 8, z = -8},
			view_offset = {x = 0, y = -2, z = 0},
			group = "pass",
		},
	},
	seat_groups = {
		pass = {
			name = "Passenger area",
			access_to = {},
			require_doors_open = true,
		},
	},
	assign_to_seat_group = {"pass"},
	doors = {
		open = {
			[-1] = {frames = {x = 0, y = 10}, time = 1},
			[1] = {frames = {x = 20, y = 30}, time = 1}
		},
		close = {
			[-1] = {frames = {x = 10, y = 20}, time = 1},
			[1] = {frames = {x = 30, y = 40}, time = 1}
		}
	},
	door_entry = {-1.7, 1.7},
	visual_size = {x = 1, y = 1},
	wagon_span = 2.96,
	collisionbox = {-1.0, -0.5, -1.0, 1.0, 2.5, 1.0},
	drops = {
		"default:steelblock 2",
		"default:steel_ingot",
		"default:obsidian_glass 2",
		"default:mese",
		"advtrains:wheel 2",
	},
	custom_on_step = function(self, dtime, data, train)
		if train.line and self.line_cache ~= train.line then
			self.line_cache = train.line
			local line = tonumber(train.line)
			if type(line) == "number" and line < 10 and line > 0 then
				local new_line_tex = "mese_trains_mesejet_wagon.png^((mese_trains_mesejet_wagon_lines.png^mese_trains_mesejet_wagon_line_" .. line .. ".png)^[colorize:" .. lines[line] .. ":255)"
				self.object:set_properties({
					textures = {new_line_tex}
				})
			else
				self.object:set_properties({
					textures = {"mese_trains_mesejet_wagon.png"}
				})
			end
			if self.line_cache ~= nil and line == nil then
				self.object:set_properties({
						textures = self.textures,
				})
				self.line_cache = nil
			end
		end
	end,
}, S("MeseJet Wagon"), "mese_trains_mesejet_wagon_inv.png")

advtrains.register_wagon("mese_trains_mesejet:mese_trains_mesejet_engine", {
	mesh = "mese_trains_mesejet_engine.b3d",
	textures = {"mese_trains_mesejet_engine.png"},
	use_texture_alpha = true,
	drives_on = {default = true},
	max_speed = 20,
	seats = {
		{
			name = S("Driver stand"),
			attach_offset = {x = 1, y = 1, z = 0},
			view_offset = {x = 0, y = 1.5, z = 0},
			group = "dstand",
		},
		{
			name = "1",
			attach_offset = {x = -4, y = -2, z = -16},
			view_offset = {x = 0, y = 1.5, z = 0},
			group = "pass",
		},
		{
			name = "2",
			attach_offset = {x = 4, y = -2, z = -16},
			view_offset = {x = 0, y = 1.5, z = 0},
			group = "pass",
		},
		{
			name = "3",
			attach_offset = {x = -4, y = -2, z = -8},
			view_offset = {x = 0, y = 1.5, z = 0},
			group = "pass",
		},
		{
			name = "4",
			attach_offset = {x = 4, y = -2, z = -8},
			view_offset = {x = 0, y = 1.5, z = 0},
			group = "pass",
		},
	},
	seat_groups = {
		dstand = {
			name = S("Driver Stand"),
			access_to = {"pass"},
			require_doors_open = true,
			driving_ctrl_access = true,
		},
		pass = {
			name = S("Passenger area"),
			access_to = {"dstand"},
			require_doors_open = true,
		},
	},
	assign_to_seat_group = {"dstand", "pass"},
	doors = {
		open = {
			[-1] = {frames = {x = 0, y = 10}, time = 1},
			[1] = {frames = {x = 20, y = 30}, time = 1}
		},
		close = {
			[-1] = {frames = {x = 10, y = 20}, time = 1},
			[1] = {frames = {x = 30, y = 40}, time = 1}
		}
	},
	door_entry = {-1.7},
	visual_size = {x = 1, y = 1},
	wagon_span = 3.1,
	is_locomotive = true,
	collisionbox = {-1.0, -0.5, -1.0, 1.0, 2.5, 1.0},
	drops = {
		"default:steelblock 3",
		"default:mese",
		"default:obsidian_glass",
		"advtrains:wheel 2",
	},
	horn_sound = "mese_trains_mesejet_horn",
	custom_on_step = function(self, dtime, data, train)
		if train.line and self.line_cache ~= train.line then
			self.line_cache = train.line
			local line = tonumber(train.line)
			if type(line) == "number" and line < 10 and line > 0 then
				local new_line_tex = "mese_trains_mesejet_engine.png^(mese_trains_mesejet_engine_lines.png^[colorize:" .. lines[line] .. ":255)"
				self.object:set_properties({
					textures = {new_line_tex}
				})
			else
				self.object:set_properties({
					textures = {"mese_trains_mesejet_engine.png"}
				})
			end
			if self.line_cache ~= nil and line == nil then
				self.object:set_properties({
						textures = self.textures,
				})
				self.line_cache = nil
			end
		end
	end,
}, S("MeseJet Engine"), "mese_trains_mesejet_engine_inv.png")

minetest.register_craft({
	output = 'mese_trains_mesejet:mese_trains_mesejet_wagon',
	recipe = {
		{'default:steelblock', 'default:steel_ingot', 'default:steelblock'},
		{'default:obsidian_glass', 'default:mese', 'default:obsidian_glass'},
		{'advtrains:wheel', '', 'advtrains:wheel'},
	},
})

minetest.register_craft({
	output = 'mese_trains_mesejet:mese_trains_mesejet_engine',
	recipe = {
		{'default:steelblock', 'default:steelblock', ''},
		{'default:steelblock', 'default:mese', 'default:obsidian_glass'},
		{'advtrains:wheel', '', 'advtrains:wheel'},
	},
})
