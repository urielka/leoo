local func_chain = {}
local function call_chain(def)
  local i = #func_chain
  while i > 0 do
    if func_chain[i] ~= nil then
      def = func_chain[i](def)
    end
    i = i - 1
  end
  func_chain = {}
end

local function add_chain(f)
  table.insert(func_chain,f)
  return f
end

local function copy(old,new)
  for key,val in pairs(new) do
    if key ~= "__index" then
      old[key] = val
    end
  end
  return old
end

function mixin(name)
  local env = getfenv(2)
  return function (def)
    def.__name__ = name
    env[name] = def
  end
end

function include(name)
  local env = getfenv(2)
  return add_chain(function (def)
    def.__mixins__ = def.__mixins__ or {}
    table.insert(def.__mixins__,env[name])

    --remove myself so we don't get a infinite recursion
    func_chain[#func_chain] = nil
    call_chain(def)
  end)
end

function extends(name)
  local env = getfenv(2)
  return function (def)
    def.__base__ = env[name]
    call_chain(def)
  end
end

function super(inst)
  local base = getmetatable(inst).__index.__base__
  if base then
    return base.__proto.__index
  else
    return {}
  end
end

function class(name)
  local env = getfenv(2)
  func_chain = {}
  return add_chain(function (def)
    func_chain = {}
    def.__name__ = name
    local base = def.__base__
    if base then
      setmetatable(def,{__index = base.__proto.__index})
    end
    local meta = {__index = def}
    local cls = {
      __name = name,
      __proto = meta,
      new = function (...)
        local c = {}
        setmetatable(c, meta)
        if def.__init then
          def.__init(c, ...)
        end
        return c
      end
    }

    -- extend our definition using our mixins
    for _,mixin in ipairs(def.__mixins__ or {}) do
      for key,val in pairs(mixin) do
        if key == "__metatable" then
          copy(meta,val)
        else
          if key ~= "__name__" then
            def[key] = val
          end
        end
      end
    end

    env[name] = cls
  end)
end