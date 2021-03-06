local db = {}

local function connect(database)
	lease.acquire(database)
	if storage[database] == nil then
		storage[database] = '[]'
	end
end

local function disconnect(database)
	lease.release(database)
end

local function read(database)
	connect(database)
	local database_table = json.parse(storage[database])
	disconnect(database)
	return database_table
end

local function write(database, database_table)
	connect(database)
	storage[database] = json.stringify(database_table)
	disconnect(database)
end

function db.insert(database, id, object)
	local database_table = read(database)
	database_table[id] = object
	write(database, database_table)
end

function db.delete(database, id)
	local database_table = read(database)
	if id then
		database_table[id] = nil
		write(database, database_table)
	else
		for k, v in pairs(database_table) do
			table.remove(database_table,k)
		end
	end
end

function db.select(database, id)
	local database_table = read(database)
	if id then
		local record = database_table[id] or false
		if record then
			return record
			-- record['id'] = id
			-- record['json'] = json.stringify(record)
		end
	else
		local records = {}
		for k, v in pairs(database_table) do
			-- local record = v
			-- record['id'] = k
			-- record['json'] = json.stringify(record)
			table.insert(records, {k = v})
		end
		return records
	end
end

return db
