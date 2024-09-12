function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
function first_then_lower_case(table, predicate)
  for _, str in ipairs(table) do
    if predicate(str) then
      return str:lower()
    end
  end
  return nil
end

-- Write your powers generator here
function powers_generator(base, limit)
  local co = coroutine.create(function()
    local power = 1
    while power <= limit do
      coroutine.yield(power)
      power = power * base
    end
  end)
  return co
end
  
-- Write your say function here
function say(word)
  local words = {}

  local function chainable(next_word)
    if next_word ~= nil then
      table.insert(words, next_word)
      return chainable
    else
      return table.concat(words, " ")
    end
  end

  return chainable(word)
end

-- Write your line count function here
function meaningful_line_count(filename)
  local file = io.open(filename, "r")
  if not file then error("No such file") end

  local count = 0
  for line in file:lines() do
    local trimmed = line:match("^%s*(.-)%s*$")  -- space for leading and trailing
    if trimmed ~= "" and trimmed:sub(1, 1) ~= "#" then
      count = count + 1
    end
  end

  file:close()
  return count
end

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

-- Constructor
function Quaternion.new(a, b, c, d)
  return setmetatable({a = a, b = b, c = c, d = d}, Quaternion)
end

-- Addition
function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

-- Multiplication
function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

-- Coefficients
function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

-- Conjugate
function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

-- Equality
function Quaternion.__eq(q1, q2)
  return q1.a == q2.a and q1.b == q2.b and q1.c == q2.c and q1.d == q2.d
end

-- String
function Quaternion.__tostring(q)
  local parts = {}

  -- Handle part (a)
  if q.a ~= 0 or (q.b == 0 and q.c == 0 and q.d == 0) then
    table.insert(parts, tostring(q.a))
  end

  -- Handle the 'i' component (b)
  if q.b ~= 0 then
    local bStr = (q.b == 1 and "i" or (q.b == -1 and "-i" or tostring(q.b) .. "i"))
    table.insert(parts, bStr)
  end

  -- Handle the 'j' component (c)
  if q.c ~= 0 then
    local cStr = (q.c == 1 and "j" or (q.c == -1 and "-j" or tostring(q.c) .. "j"))
    table.insert(parts, cStr)
  end

  -- Handle the 'k' component (d)
  if q.d ~= 0 then
    local dStr = (q.d == 1 and "k" or (q.d == -1 and "-k" or tostring(q.d) .. "k"))
    table.insert(parts, dStr)
  end

  -- Combine and add +
  local result = table.concat(parts, "+"):gsub("%+%-", "-")

  -- Remove leading '+' if it's there
  result = result:gsub("^%+", "")

  return result
end


