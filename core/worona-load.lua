local function worona_load( blood_name )
    
    local worona = {}    -- the new instance

    local includes = {
    					-- worona core
    					"services",
    					"scene",
    					"log",
    					"style",
    					"ui",

    					-- libraries
    					"date",
    					"device",
    					"file",
    					"image",
    					"string",
    					"html_server",

    					-- proxies
    					"content",
    					"lang",
    					"local_options",

    					-- actions
    					"load_url",
    					
    					-- scenes
    					"scene-list",
    					"scene-post",
    					"scene-about",
    					"scene-webview",
    					
    					-- styles
    					"style-flat-ui",
    					"style-ios7",

    					-- ui
    					"ui-newBasicNavBar"
					 }

	--------------------------------------------------------------
	--------------------------------------------------------------
	---------------------- EXTENSIONS ----------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------

	local function initializeIncludes()

		for i = 1, #includes do
			local require_path = "worona.includes." .. includes[i] .. "." .. includes[i]
			require ( require_path )
		end
	end
	
	local function initializeExtensions( extensions )
		

		local file = io.open( system.pathForFile( "package.json", system.ResourceDirectory ), "r" )

		if file then
			--: read all contents of file into a string :--
			local file_content = file:read( "*a" )
			local json = require "json"
			local package = json.decode( file_content )
			io.close( file )	--: close the file after using it :--

			local extensions_array = package[ extensions ]
			
			for i = 1, #extensions_array do
				local require_path = extensions .. "." .. extensions_array[i] .. "." .. extensions_array[i]
				require (require_path)
			end
		end
	end


	--------------------------------------------------------------
	--------------------------------------------------------------
	---------------------- ACTIONS -------------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------

	local action_list = {}

	
	function worona:add_action( hook_name, func, priority )
		
		priority = priority or 10 --: default

		--: initializates the hook_name table
		if action_list[ hook_name ] == nil then
			action_list[ hook_name ] = {}
			action_list[ hook_name ][ "priorities" ] = {}
		end

		local hook_name_list = action_list[ hook_name ] --: localise

		--: initializates the priority_table
		if hook_name_list[ priority ] == nil then
			
			hook_name_list[ priority ] = {}
			
			local hook_name_list_priorities = hook_name_list.priorities --: localise
			hook_name_list_priorities[ #hook_name_list_priorities + 1 ] = priority
			table.sort( hook_name_list_priorities )	--: sort the priorities list so we can use it later
		end

		--: actually add the function
		hook_name_list[ priority ][ # hook_name_list[ priority ] + 1 ] = func
		
		if worona.log ~= nil then
			worona.log:info( "add_action: Function '" .. tostring( func ) .. "' added to the '" .. hook_name .. "' hook with priority " .. priority )
		end
	end 

	function worona:do_action( hook_name, ... )
		
		if action_list[ hook_name ] ~= nil then
			local hook_name_list = action_list[ hook_name ] --: localise
			--: iterate thru the priorities table
			local priorities_list = hook_name_list.priorities --: localise
			for i = 1, #priorities_list do
				--: iterate thru the functions table
				local func_list = hook_name_list[ priorities_list[ i ] ] --: localise
				for j = 1, #func_list do
					if worona.log ~= nil then
						worona.log:info( "do_action: Hook '" .. hook_name .. "', calling function '" .. tostring( func_list[j] ) .. "'." )
						worona.log:addIndent()
					end
					func_list[ j ]( unpack( arg ) ) --: call the function :)
					if worona.log ~= nil then
						worona.log:removeIndent()
					end
				end				
			end
		end
	end

	function worona:remove_action( hook_name, func )
		
		local hook_name_list = action_list[ hook_name ]

		if hook_name_list ~= nil then
			--: search for the func in
			local priorities_list = hook_name_list.priorities
			for i = 1, #priorities_list do
				local func_list = hook_name_list[ priorities_list[ i ] ] --: localise
				for j = 1, #func_list do
					if func_list[j] == func then
						worona.log:info( "remove_action: Hook '" .. hook_name .. "', removing function '" .. tostring( func_list[j] ) .. "'." )
						table.remove(func_list, j)
					end
				end
			end
		end
	end

	--------------------------------------------------------------
	--------------------------------------------------------------
	---------------------- INIT ----------------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------

	function worona:initializeWoronaExtensions()	

		-- Initialize includes and extensions
		initializeIncludes()
		initializeExtensions( "extensions" )
	end

	--------------------------------------------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------
	--------------------------------------------------------------



    return worona -- return the instance
end

return worona_load
