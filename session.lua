local session = {}

local db = require('consfuso/lualib/db2.lua')
local cookie = require('consfuso/lualib/cookie.lua')

local session_table = {}

session.id = nil
session.resume = false

local function read()
	session_table = db.select('sessions', session.id) or {}
end

local function write()
	db.insert('sessions', session.id, session_table)
end

function session.init(request)
	local cookies = request.headers['Cookie']
	if cookies then
		session.id = cookie.get('SESSION_ID', cookies)
	end
	if session.id then
		session.resume = true
	else
		session.id = crypto.sha256(request.headers['User-Agent'] .. os.time()).hexdigest()
	end
end

function session.set(name, value)
	read()
	session_table[name] = value
	write()
end

function session.get(name)
	read()
	return session_table[name]
end

return session
