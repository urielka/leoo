require 'yaml'
require 'leoo'

mixin 'PrettyToString' {
  __metatable = {
    __tostring = function (self)
      local s = {'<'}
      local class_name = getmetatable(self).__index.__name__
      table.insert(s,class_name)
      table.insert(s,' (')
      local struct = {}
      for key,val in pairs(self) do
        table.insert(struct,tostring(key) .. ':' .. tostring(val))
      end
      table.insert(s,table.concat(struct,","))
      table.insert(s,') ')
      table.insert(s,'>')
      return table.concat(s)
    end
  }
}

-- this is equivalent to mixin('Comparable')({...})
mixin 'Comparable' {
  __metatable = {
    __eq = function (self,other)
      return self:__cmp(other) == 0
    end,
    __lt = function (self,other)
      return self:__cmp(other) < 0
    end,
    __le = function (self,other)
      return self:__lt(other) or self:__eq(other)
    end
  }
}

class 'Person'
  include 'PrettyToString' {
  __init = function (self, name, age)
    self.name = name
    self.age = age
  end
}

-- this is equivalent to class('Vector2');include('Comparable');include('PrettyToString')({...}))
class 'Vector2'
  include 'Comparable'
  include 'PrettyToString' {
  __init = function (self,x,y)
    self.x = x
    self.y = y
  end,
  __cmp = function (self, other)
    return self:size() - other:size()
  end,
  size = function (self)
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
  end
}

-- this is equivalent to class('Vector3');extends('Vector2')({...})
class 'Vector3' extends 'Vector2' {
  __init = function (self, x, y, z)
    super(self).__init(self, x, y)
    self.z = z
  end,
  size = function (self)
    local v2_size = math.pow(super(self).size(self),2)
    return math.sqrt(v2_size + math.pow(self.z,2))
  end
}

local uriel = Person.new('Uriel',23)
print(uriel)

local v1 = Vector2.new(1, 5)
local v2 = Vector2.new(2, 4)

print('v1: ' .. tostring(v1))
print('v2: ' .. tostring(v2))

print('v1 > v2: ' .. tostring(v1 > v2))
print('v1 == v2: ' .. tostring(v1 == v2))
print('v1 < v2: ' .. tostring(v1 < v2))

local v3 = Vector3.new(1,2,3)
local v4 = Vector3.new(3,2,2)

print('v3: ' .. tostring(v3))
print('v4: ' .. tostring(v4))

print('v3 > v4: ' .. tostring(v3 > v4))
print('v3 == v4: ' .. tostring(v3 == v4))
print('v3 < v4: ' .. tostring(v3 < v4))


