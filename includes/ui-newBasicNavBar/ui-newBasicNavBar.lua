local worona = require "worona"

local function newBasicNavBar( self, params )

	local widget = require "widget"

	-- Create the display group
	local navbar = display.newGroup()

	-- Get the style

	local style = worona.style:get("navbar")

	local attributes = {
		navbar_x                = display.contentWidth / 2,
		navbar_y                = worona.style:getSetting( { ios7 = ( display.topStatusBarContentHeight + style.height ) / 2, default = display.topStatusBarContentHeight + style.height / 2 } ),
		navbar_center_point     = display.topStatusBarContentHeight + style.height / 2,
		navbar_height           = worona.style:getSetting( { ios7 = style.height + display.topStatusBarContentHeight, default = style.height } ),
		navbar_width            = style.width or display.contentWidth,
		background_color        = style.background.color,
		background_stroke_color = style.background.stroke.color,
		background_stroke_width = style.background.stroke.width,
		text                    = "Untitled" or params.text,
		text_size               = style.text.fontSize,
		text_color              = style.text.color
	}

	-- Start the creation

	local background = display.newRect( attributes.navbar_x, attributes.navbar_y, attributes.navbar_width, attributes.navbar_height )
	background:setFillColor( attributes.background_color[1], attributes.background_color[2], attributes.background_color[3], attributes.background_color[4] )
	navbar:insert(background)

	local stroke = display.newRect( navbar, attributes.navbar_x, attributes.navbar_height + attributes.background_stroke_width / 2 - attributes.background_stroke_width, attributes.navbar_width, attributes.background_stroke_width )
	stroke:setFillColor( attributes.background_stroke_color[1], attributes.background_stroke_color[2], attributes.background_stroke_color[3], attributes.background_stroke_color[4] )

	local left_button_width = 0
	if params.left_button_icon ~= nil then
		local left_button_options = {
			x 			= params.left_button_icon.width / 2 - 15,
			y 			= attributes.navbar_center_point,
		    width       = params.left_button_icon.width,
		    height      = params.left_button_icon.height,
		    defaultFile = params.left_button_icon.default,
	        overFile    = params.left_button_icon.over,
	        onRelease   = function() worona:do_action( "navbar_left_button_pushed" ); return true end
		}
		left_button_width = params.left_button_icon.width
		local left_button = widget.newButton( left_button_options )
		navbar:insert( left_button )
	end

	local right_button_width = 0
	if params.right_button_icon ~= nil then
		local right_button_options = {
			x 			= display.contentWidth - ( params.right_button_icon.width / 2 ) + 15,
			y 			= attributes.navbar_center_point,
		    width       = params.right_button_icon.width,
			height      = params.right_button_icon.height,
		    defaultFile = params.right_button_icon.default,
	        overFile    = params.right_button_icon.over,
	        onRelease   = function() worona:do_action( "navbar_right_button_pushed" ); return true end
		}
		right_button_width = params.left_button_icon.width
		local right_button = widget.newButton( right_button_options )
		navbar:insert( right_button )

	end

	local text_options = {
		parent   = navbar,
		text     = params.text or "nothing",
		x        = attributes.navbar_x,
		y        = attributes.navbar_center_point,
		fontSize = attributes.text_size
	}

	local text = display.newText( text_options )
	text:setFillColor( attributes.text_color[1], attributes.text_color[2], attributes.text_color[3], attributes.text_color[4] )

	--. If text is too wide, cut it and add "..."
	local nabvar_available_space = display.contentWidth - right_button_width - left_button_width - 10
	if text.width > nabvar_available_space then
		--. Calculate the width of a character:
		text.text = "o"
		local character_width = text.width
		print(character_width)

		--. Calculate how many character can be placed in the nabvar:
		local characters_number = math.floor(nabvar_available_space / character_width)

		--. Insert text with new length
		text.text = text_options.text:sub(1, characters_number - 3) .. "..."
	end

	-- Insert navbar on the parent group
	if params ~= nil and params.parent ~= nil then
		params.parent:insert( navbar )
	end

	-- Return the object
	return navbar
end
worona:do_action( "extend_service", { service = "ui", creator = newBasicNavBar, name = "newBasicNavBar" } )