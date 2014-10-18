local worona = require "worona"

local function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "%%20")
   end
   return str    
end

local function stats()

	if system.getInfo("environment") == "simulator" and worona.local_options:get("stats") ~= true and worona.stats ~= false then
		network.request( "http://www.worona.dev/stats.php?event=app_execution&wp_url="..urlencode(worona.wp_url).."&app_title="..urlencode(worona.app_title).."&id="..urlencode(system.getInfo("deviceID")), "GET", nil )
		worona.local_options:set("stats",true)
	end

end
worona:add_action( "init", stats, 10 )