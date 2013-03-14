leoo - Lua Exterme OO
-----------------------------------------------

While looking for a class system for lua I ran into [this](http://code.google.com/p/lua-class-lib/wiki/Lua_OOP_LuaClassLib#First_Look).

It inspired me to see how much Lua can be pushed to produce a syntax that resembles a language with native class support.

This (hack) project is the result of that moment of inspiration :)

I really recommend against usage of this library because:
* I am not planning on maintaining it, it is just an experiment
* It is a big hack and probably needs a complete rewrite
* I haven't done any real testing except testing example.lua
* The resulting syntax, although cool, is just not lua anymore
* There much better class systems for lua

Features
-----------------------------------------------
* Single base class inheritance using a __index chain
* Mixins support (copying)
* An really cool syntax that resembles Java/Ruby
* Some reflection support (see PrettyToString in example.lua)

Usage
-----------------------------------------------
put leoo.lua in a folder that is package.path (or change package.path)

small example:
```lua
require 'leoo'

class 'Animal' {
  __init = function(self, name)
    self.name = name
  end,
  say_my_name = function(self)
    print(self.name)
  end
}

class 'Dog' extends 'Animal' {
  bark = function(self)
    self:say_my_name()
    print("Whaf Whaf")
  end
}

local dog = Dog.new('Rex')
dog:bark()
```


License
-----------------------------------------------
MIT but really you shouldn't use this ;)