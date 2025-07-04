local sqlite3 = require("lsqlite3")
local db = sqlite3.open("dane.db")

db:exec[[
  CREATE TABLE IF NOT EXISTS dane (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input1_2 TEXT,
    input2_2 TEXT,
    input1_3 TEXT,
    input2_3 TEXT,
    input3_3 TEXT,
    timestamp TEXT
  );
]]

local input1_2 = arg[1] or ""
local input2_2 = arg[2] or ""
local input1_3 = arg[3] or ""
local input2_3 = arg[4] or ""
local input3_3 = arg[5] or ""
local timestamp = os.date("%Y-%m-%d %H:%M:%S")

local stmt = db:prepare([[
  INSERT INTO dane (input1_2, input2_2, input1_3, input2_3, input3_3, timestamp)
  VALUES (?, ?, ?, ?, ?, ?)
]])
stmt:bind_values(input1_2, input2_2, input1_3, input2_3, input3_3, timestamp)
stmt:step()
stmt:finalize()
db:close()
