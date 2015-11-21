local cookie = {}

function cookie.get(name, cookies)
	cookies = ";" .. cookies .. ";"
	cookies = string.gsub(cookies, "%s*;%s*", ";")
	local pattern = ";" .. name .. "=(.-);"
	local _, __, value = string.find(cookies, pattern)
	return value
end

return cookie