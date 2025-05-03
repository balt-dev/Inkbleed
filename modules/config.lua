
function G.FUNCS.number_select(e)
	local args = e.config.ref_table
	args.current = (e.config.ref_value and math.min(args.max, math.max(args.min, args.current + e.config.ref_value))) or args.default
	args.callback(args.current)
end

function create_number_select(args)
	args = args or {}
	args.min = args.min or -math.huge
	args.max = args.max or math.huge
	args.step = args.step or 1
	args.scale = args.scale or 1
	args.big_step = args.big_step or args.step * 10
	args.current = args.current or 0
	args.current = math.min(args.current, args.max)
	args.current = math.max(args.current, args.min)
	args.default = args.default or args.current
	args.colour = args.colour or G.C.RED
	args.callback = args.callback or error("must set callback for number selector", 2)
	args.w = (args.w or 2.5) * args.scale
	args.h = (args.h or 0.8) * args.scale
	args.text_scale = (args.text_scale or 0.5) * args.scale

	local info = nil
	if args.info then
		info = {}
		for _, v in ipairs(args.info) do
			table.insert(info, {
				n = G.UIT.R,
				config = { align = "cm", minh = 0.05, colour = G.C.CLEAR },
				nodes = {{
					n = G.UIT.T,
					config = { text = v, scale = 0.3 * args.scale, colour = G.C.UI.TEXT_LIGHT }
				}}
			})
		end
		info = {
			n = G.UIT.R,
			config = { align = "cm", minh = 0.05, colour = G.C.CLEAR },
			nodes = info
		}
	end

	local very_left_button = {
		n = G.UIT.C,
		config = {
			align = "cm", r = 0.1, minw = 0.4 * args.scale, minh = 0.3 * args.scale,
			hover = true, colour = args.colour, shadow = true,
			focus_args = { type = 'none' },
			ref_table = args, ref_value = -args.big_step,
			button = "number_select"
		},
		nodes = {{
			n = G.UIT.T,
			config = {
				text = "--", scale = args.text_scale * 0.8, colour = G.C.UI.TEXT_LIGHT, minh = 0.3 * args.scale
			}
		}}
	}

	local left_button = {
		n = G.UIT.C,
		config = {
			align = "cm", r = 0.1, minw = 0.6 * args.scale, minh = 0.4 * args.scale,
			hover = true, colour = args.colour, shadow = true,
			focus_args = { type = 'none' },
			ref_table = args, ref_value = -args.step,
			button = "number_select"
		},
		nodes = {{
			n = G.UIT.T,
			config = {
				text = "-", scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, minh = 0.4 * args.scale
			}
		}}
	}

	local display = {
		n = G.UIT.C,
		config = {
			id = 'numsel_main', align = "cm",
			minw = args.w, minh = args.h,
			r = 0.1, padding = 0.05, colour = args.colour,
			emboss = 0.1, hover = true, can_collide = true,
			on_demand_tooltip = args.on_demand_tooltip
		},
		nodes = {{
			n = G.UIT.R,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {{
				n = G.UIT.O,
				config = {
					object = DynaText({
						string = { { ref_table = args, ref_value = "current" } },
						colours = { G.C.UI.TEXT_LIGHT },
						pop_in = 0, pop_in_rate = 8, reset_pop_in = false,
						shadow = true, float = true, silent = true,
						bump = true, scale = args.text_scale,
						non_recalc = true
					}), colour = G.C.CLEAR
				}
			}}
		}}
	}

	local right_button = {
		n = G.UIT.C,
		config = {
			align = "cm", r = 0.1, minw = 0.6 * args.scale, minh = 0.4 * args.scale,
			hover = true, colour = args.colour, shadow = true,
			focus_args = { type = 'none' },
			ref_table = args, ref_value = args.step,
			button = "number_select"
		},
		nodes = {{
			n = G.UIT.T,
			config = {
				text = "+", scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, minh = 0.4 * args.scale
			}
		}}
	}

	local very_right_button = {
		n = G.UIT.C,
		config = {
			align = "cm", r = 0.1, minw = 0.4 * args.scale, minh = 0.3 * args.scale,
			hover = true, colour = args.colour, shadow = true,
			focus_args = { type = 'none' },
			ref_table = args, ref_value = args.big_step,
			button = "number_select"
		},
		nodes = {{
			n = G.UIT.T,
			config = {
				text = "++", scale = args.text_scale * 0.8, colour = G.C.UI.TEXT_LIGHT, minh = 0.3 * args.scale
			}
		}}
	}

	local reset_button = {
		n = G.UIT.C,
		config = {
			align = "cm", r = 0.1, minw = 0.6 * args.scale, minh = 0.4 * args.scale,
			padding = 0.1,
			hover = true, colour = args.colour, shadow = true,
			focus_args = { type = 'none' },
			ref_table = args,
			button = "number_select"
		},
		nodes = {{
			n = G.UIT.T,
			config = {
				text = localize("number_select_reset"), scale = args.text_scale * 0.8, colour = G.C.UI.TEXT_LIGHT, minh = 0.8 * args.scale
			}
		}}
	}

	local t = {
		n = G.UIT.R,
		config = { align = "cm", colour = G.C.CLEAR, padding = 0.0 },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "cm", padding = 0.1, r = 0.1,
					colour = G.C.CLEAR, id = args.id and (not args.label and args.id or nil) or nil,
					focus_args = args.focus_args
				},
				nodes = { very_left_button, left_button, display, right_button, very_right_button }
			},
		}
	}

	t = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.05, id = args.id or nil, colour = G.C.CLEAR },
		nodes = {
			args.label and {
				n = G.UIT.R,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.T, config = { text = args.label, scale = 0.5 * args.scale, colour = G.C.UI.TEXT_LIGHT } }
				}
			},
			t,
			info,
			{
				n = G.UIT.R,
				config = {
					align = "cm", padding = 0.1, r = 0.1,
					colour = G.C.CLEAR,
				},
				nodes = { reset_button }
			}
		}
	}

	return t
end

MISPRINTMOD.config_tab = function()
	return {
		n=G.UIT.ROOT,
		config = {align = "cm", padding = 0.05, r = 0.1, minw=8, minh=6, colour = G.C.BLACK}, 
		nodes = {
			create_number_select {
				label = localize("misprint_base"),
				min = 1,
				max = math.huge,
				step = 0.01,
				big_step = 1,
				current = MISPRINTMOD.config.Base,
				callback = function(val)
					MISPRINTMOD.config.Base = val
				end
			}
		}
	}
end